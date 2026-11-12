import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import org.jf.dexlib2.DexFileFactory;
import org.jf.dexlib2.Opcodes;
import org.jf.dexlib2.iface.ClassDef;
import org.jf.dexlib2.iface.DexFile;
import org.jf.dexlib2.iface.Field;
import org.jf.dexlib2.iface.Method;
import org.jf.dexlib2.iface.MultiDexContainer;
import org.jf.dexlib2.iface.instruction.DualReferenceInstruction;
import org.jf.dexlib2.iface.instruction.Instruction;
import org.jf.dexlib2.iface.instruction.ReferenceInstruction;
import org.jf.dexlib2.iface.reference.FieldReference;
import org.jf.dexlib2.iface.reference.MethodReference;
import org.jf.dexlib2.iface.reference.Reference;
import org.jf.dexlib2.iface.reference.TypeReference;
import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;

/** Structural member resolution for selected classes in the final APK, not an ART verifier. */
public final class CheckReferences {
    private static final class Definition {
        String parent;
        final List<String> interfaces = new ArrayList<String>();
        final Set<String> methods = new HashSet<String>();
        final Set<String> fields = new HashSet<String>();
    }

    private final Map<String, ClassDef> appClasses = new HashMap<String, ClassDef>();
    private final Map<String, Definition> definitions = new HashMap<String, Definition>();
    private final Set<String> missingPlatform = new HashSet<String>();
    private final Set<String> errors = new LinkedHashSet<String>();
    private final JarFile platform;
    private int methodReferences;
    private int fieldReferences;
    private int typeReferences;
    private int externalReferencesSkipped;
    private int platformInheritedMembers;
    private int checkedMethods;
    private int instructions;

    private CheckReferences(File apk, File androidJar) throws Exception {
        platform = new JarFile(androidJar);
        MultiDexContainer<? extends DexFile> container = DexFileFactory.loadDexContainer(apk, Opcodes.forApi(35));
        for (String entry : container.getDexEntryNames()) {
            DexFile dex = container.getEntry(entry).getDexFile();
            for (ClassDef item : dex.getClasses()) {
                if (appClasses.put(item.getType(), item) != null) {
                    throw new IllegalArgumentException("Duplicate APK class: " + item.getType());
                }
                Definition definition = new Definition();
                definition.parent = item.getSuperclass();
                definition.interfaces.addAll(item.getInterfaces());
                for (Method method : item.getMethods()) definition.methods.add(methodKey(method));
                for (Field field : item.getFields()) definition.fields.add(field.getName() + ":" + field.getType());
                definitions.put(item.getType(), definition);
            }
        }
    }

    private static String descriptor(String internalName) {
        return internalName == null ? null : "L" + internalName + ";";
    }

    private Definition definition(String type) throws Exception {
        Definition existing = definitions.get(type);
        if (existing != null || type == null || missingPlatform.contains(type)) return existing;
        if (!type.startsWith("L") || !type.endsWith(";")) return null;
        JarEntry entry = platform.getJarEntry(type.substring(1, type.length() - 1) + ".class");
        if (entry == null) {
            missingPlatform.add(type);
            return null;
        }
        final Definition loaded = new Definition();
        try (java.io.InputStream input = platform.getInputStream(entry)) {
            new ClassReader(input).accept(new ClassVisitor(org.objectweb.asm.Opcodes.ASM9) {
                @Override public void visit(int version, int access, String name, String signature,
                        String parent, String[] interfaces) {
                    loaded.parent = descriptor(parent);
                    for (String item : interfaces) loaded.interfaces.add(descriptor(item));
                }
                @Override public MethodVisitor visitMethod(int access, String name, String desc,
                        String signature, String[] exceptions) {
                    loaded.methods.add(name + desc);
                    return null;
                }
                @Override public FieldVisitor visitField(int access, String name, String desc,
                        String signature, Object value) {
                    loaded.fields.add(name + ":" + desc);
                    return null;
                }
            }, ClassReader.SKIP_CODE | ClassReader.SKIP_DEBUG | ClassReader.SKIP_FRAMES);
        }
        definitions.put(type, loaded);
        return loaded;
    }

    private static String methodKey(MethodReference method) {
        StringBuilder key = new StringBuilder(method.getName()).append('(');
        for (CharSequence parameter : method.getParameterTypes()) key.append(parameter);
        return key.append(')').append(method.getReturnType()).toString();
    }

    /** Returns the actual declaring class or null. Constructors cannot be inherited. */
    private String resolve(String owner, String key, boolean method, Set<String> seen) throws Exception {
        if (owner == null || !seen.add(owner)) return null;
        Definition candidate = definition(owner);
        if (candidate == null) return null;
        if ((method ? candidate.methods : candidate.fields).contains(key)) return owner;
        if (method && key.startsWith("<init>(")) return null;
        for (String contract : candidate.interfaces) {
            String resolved = resolve(contract, key, method, seen);
            if (resolved != null) return resolved;
        }
        return resolve(candidate.parent, key, method, seen);
    }

    private static boolean appNamespace(String type) {
        return type.startsWith("Lcom/navipilot/obf/")
                || type.startsWith("Lcom/jixiexiaoge/drivingassist/");
    }

    private void check(Reference reference, String caller) throws Exception {
        if (reference instanceof MethodReference) {
            MethodReference method = (MethodReference) reference;
            String owner = method.getDefiningClass();
            if (!appClasses.containsKey(owner) && !appNamespace(owner)) {
                externalReferencesSkipped++;
                return;
            }
            methodReferences++;
            String resolved = resolve(owner, methodKey(method), true, new HashSet<String>());
            if (resolved == null) errors.add(caller + " -> missing method " + owner + "->" + methodKey(method));
            else if (!appClasses.containsKey(resolved)) platformInheritedMembers++;
        } else if (reference instanceof FieldReference) {
            FieldReference field = (FieldReference) reference;
            String owner = field.getDefiningClass();
            if (!appClasses.containsKey(owner) && !appNamespace(owner)) {
                externalReferencesSkipped++;
                return;
            }
            fieldReferences++;
            String key = field.getName() + ":" + field.getType();
            String resolved = resolve(owner, key, false, new HashSet<String>());
            if (resolved == null) errors.add(caller + " -> missing field " + owner + "->" + key);
            else if (!appClasses.containsKey(resolved)) platformInheritedMembers++;
        } else if (reference instanceof TypeReference) {
            String type = ((TypeReference) reference).getType();
            while (type.startsWith("[")) type = type.substring(1);
            if (appNamespace(type)) {
                typeReferences++;
                if (!appClasses.containsKey(type)) errors.add(caller + " -> missing type " + type);
            }
        }
    }

    private void checkClass(String type) throws Exception {
        ClassDef definition = appClasses.get(type);
        if (definition == null) {
            errors.add("Missing selected class " + type);
            return;
        }
        for (Method method : definition.getMethods()) {
            if (method.getImplementation() == null) continue;
            checkedMethods++;
            String caller = type + "->" + methodKey(method);
            for (Instruction instruction : method.getImplementation().getInstructions()) {
                instructions++;
                if (instruction instanceof ReferenceInstruction)
                    check(((ReferenceInstruction) instruction).getReference(), caller);
                if (instruction instanceof DualReferenceInstruction)
                    check(((DualReferenceInstruction) instruction).getReference2(), caller);
            }
        }
    }

    private static String quote(String value) {
        return "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t") + "\"";
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 3) throw new IllegalArgumentException("APK class-descriptor-list android.jar");
        CheckReferences checker = new CheckReferences(new File(args[0]), new File(args[2]));
        Set<String> selected = new LinkedHashSet<String>();
        for (String line : Files.readAllLines(new File(args[1]).toPath(), StandardCharsets.UTF_8)) {
            if (!line.trim().isEmpty()) selected.add(line.trim());
        }
        for (String type : selected) checker.checkClass(type);
        checker.platform.close();
        StringBuilder result = new StringBuilder("{");
        result.append("\"apkClassCount\":").append(checker.appClasses.size());
        result.append(",\"selectedClassCount\":").append(selected.size());
        result.append(",\"checkedMethods\":").append(checker.checkedMethods);
        result.append(",\"checkedInstructions\":").append(checker.instructions);
        result.append(",\"internalMethodReferences\":").append(checker.methodReferences);
        result.append(",\"internalFieldReferences\":").append(checker.fieldReferences);
        result.append(",\"internalTypeReferences\":").append(checker.typeReferences);
        result.append(",\"resolvedInheritedPlatformMembers\":").append(checker.platformInheritedMembers);
        result.append(",\"externalReferencesSkipped\":").append(checker.externalReferencesSkipped);
        result.append(",\"unresolved\":[");
        boolean first = true;
        for (String error : checker.errors) {
            if (!first) result.append(',');
            first = false;
            result.append(quote(error));
        }
        result.append("],\"androidRuntimeValidated\":false}");
        System.out.println(result);
        if (!checker.errors.isEmpty()) System.exit(1);
    }
}
