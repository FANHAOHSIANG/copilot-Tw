import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarOutputStream;
import org.jf.dexlib2.DexFileFactory;
import org.jf.dexlib2.iface.Annotation;
import org.jf.dexlib2.iface.AnnotationElement;
import org.jf.dexlib2.iface.ClassDef;
import org.jf.dexlib2.iface.DexFile;
import org.jf.dexlib2.iface.Field;
import org.jf.dexlib2.iface.Method;
import org.jf.dexlib2.iface.value.IntEncodedValue;
import org.jf.dexlib2.iface.value.StringEncodedValue;
import org.jf.dexlib2.iface.value.TypeEncodedValue;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;

/** Compiler-only exact-base signatures, including DEX member-class metadata. Never package this JAR. */
public final class ApiSignatures44 {
    private static String internal(String descriptor) {
        return descriptor.substring(1, descriptor.length() - 1);
    }

    private static final class Member {
        String inner, outer, name;
        int flags;
    }

    private static Member member(ClassDef definition) {
        Member m = new Member();
        m.inner = internal(definition.getType());
        for (Annotation annotation : definition.getAnnotations()) {
            for (AnnotationElement value : annotation.getElements()) {
                if ("Ldalvik/annotation/EnclosingClass;".equals(annotation.getType())
                        && value.getValue() instanceof TypeEncodedValue) {
                    m.outer = internal(((TypeEncodedValue) value.getValue()).getValue());
                }
                if ("Ldalvik/annotation/InnerClass;".equals(annotation.getType())) {
                    if ("name".equals(value.getName()) && value.getValue() instanceof StringEncodedValue)
                        m.name = ((StringEncodedValue) value.getValue()).getValue();
                    if ("accessFlags".equals(value.getName()) && value.getValue() instanceof IntEncodedValue)
                        m.flags = ((IntEncodedValue) value.getValue()).getValue();
                }
            }
        }
        return m.outer != null && m.name != null ? m : null;
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) throw new IllegalArgumentException("classes.dex output-api.jar");
        DexFile dex = DexFileFactory.loadDexFile(new File(args[0]), org.jf.dexlib2.Opcodes.forApi(35));
        List<Member> members = new ArrayList<>();
        for (ClassDef definition : dex.getClasses()) {
            Member m = member(definition);
            if (m != null) members.add(m);
        }
        try (JarOutputStream output = new JarOutputStream(new FileOutputStream(args[1]))) {
            for (ClassDef definition : dex.getClasses()) {
                ClassWriter writer = new ClassWriter(0);
                String owner = internal(definition.getType());
                String[] interfaces = new String[definition.getInterfaces().size()];
                for (int i = 0; i < interfaces.length; i++) interfaces[i] = internal(definition.getInterfaces().get(i));
                writer.visit(Opcodes.V1_8, definition.getAccessFlags(), owner, null,
                        definition.getSuperclass() == null ? null : internal(definition.getSuperclass()), interfaces);
                for (Member m : members) if (owner.equals(m.inner) || owner.equals(m.outer))
                    writer.visitInnerClass(m.inner, m.outer, m.name, m.flags);
                for (Field field : definition.getFields())
                    writer.visitField(field.getAccessFlags(), field.getName(), field.getType(), null, null).visitEnd();
                for (Method method : definition.getMethods()) {
                    if ("<clinit>".equals(method.getName())) continue;
                    StringBuilder descriptor = new StringBuilder("(");
                    for (CharSequence parameter : method.getParameterTypes()) descriptor.append(parameter);
                    descriptor.append(')').append(method.getReturnType());
                    int flags = method.getAccessFlags() & 0xffff;
                    MethodVisitor body = writer.visitMethod(flags, method.getName(), descriptor.toString(), null, null);
                    if ((flags & (Opcodes.ACC_ABSTRACT | Opcodes.ACC_NATIVE)) == 0) {
                        body.visitCode(); body.visitInsn(Opcodes.ACONST_NULL); body.visitInsn(Opcodes.ATHROW);
                        body.visitMaxs(1, 100);
                    }
                    body.visitEnd();
                }
                writer.visitEnd();
                output.putNextEntry(new JarEntry(owner + ".class"));
                output.write(writer.toByteArray()); output.closeEntry();
            }
        }
    }
}
