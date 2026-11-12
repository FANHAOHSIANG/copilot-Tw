import java.io.File;
import java.io.FileOutputStream;
import java.util.jar.JarEntry;
import java.util.jar.JarOutputStream;
import org.jf.dexlib2.DexFileFactory;
import org.jf.dexlib2.iface.ClassDef;
import org.jf.dexlib2.iface.DexFile;
import org.jf.dexlib2.iface.Field;
import org.jf.dexlib2.iface.Method;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;

/** Compiler-only signatures for the original APK. Never package this JAR in the app. */
public final class ApiSignatures {
    private static String internalName(String descriptor) {
        return descriptor.substring(1, descriptor.length() - 1);
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) throw new IllegalArgumentException("classes.dex output-api.jar");
        DexFile dex = DexFileFactory.loadDexFile(new File(args[0]),
                org.jf.dexlib2.Opcodes.forApi(35));
        try (JarOutputStream output = new JarOutputStream(new FileOutputStream(args[1]))) {
            for (ClassDef definition : dex.getClasses()) {
                ClassWriter writer = new ClassWriter(0);
                String[] interfaces = new String[definition.getInterfaces().size()];
                for (int i = 0; i < interfaces.length; i++) {
                    interfaces[i] = internalName(definition.getInterfaces().get(i));
                }
                writer.visit(Opcodes.V1_8, definition.getAccessFlags(),
                        internalName(definition.getType()), null,
                        definition.getSuperclass() == null ? null
                                : internalName(definition.getSuperclass()), interfaces);
                for (Field field : definition.getFields()) {
                    writer.visitField(field.getAccessFlags(), field.getName(),
                            field.getType(), null, null).visitEnd();
                }
                for (Method method : definition.getMethods()) {
                    if ("<clinit>".equals(method.getName())) continue;
                    StringBuilder descriptor = new StringBuilder("(");
                    for (CharSequence parameter : method.getParameterTypes()) descriptor.append(parameter);
                    descriptor.append(')').append(method.getReturnType());
                    int flags = method.getAccessFlags() & 0xffff;
                    MethodVisitor body = writer.visitMethod(flags, method.getName(),
                            descriptor.toString(), null, null);
                    if ((flags & (Opcodes.ACC_ABSTRACT | Opcodes.ACC_NATIVE)) == 0) {
                        body.visitCode();
                        body.visitInsn(Opcodes.ACONST_NULL);
                        body.visitInsn(Opcodes.ATHROW);
                        body.visitMaxs(1, 100);
                    }
                    body.visitEnd();
                }
                writer.visitEnd();
                output.putNextEntry(new JarEntry(internalName(definition.getType()) + ".class"));
                output.write(writer.toByteArray());
                output.closeEntry();
            }
        }
    }
}
