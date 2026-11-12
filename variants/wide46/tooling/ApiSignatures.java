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
import org.jf.dexlib2.iface.value.ArrayEncodedValue;
import org.jf.dexlib2.iface.value.EncodedValue;
import org.jf.dexlib2.iface.value.StringEncodedValue;
import org.jf.dexlib2.iface.value.TypeEncodedValue;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;

/** Compiler-only signatures from the real base DEX, including Java member-class metadata.
 * No method body or this signature JAR is ever packaged into the output APK. */
public final class ApiSignatures {
    private static String name(String descriptor) { return descriptor.substring(1,descriptor.length()-1); }
    private static String signature(Iterable<? extends Annotation> annotations) {
        for (Annotation a:annotations) if ("Ldalvik/annotation/Signature;".equals(a.getType()))
            for (AnnotationElement e:a.getElements()) if (e.getValue() instanceof ArrayEncodedValue) {
                StringBuilder s=new StringBuilder();
                for (EncodedValue v:((ArrayEncodedValue)e.getValue()).getValue())
                    if (v instanceof StringEncodedValue)s.append(((StringEncodedValue)v).getValue());
                return s.toString();
            }
        return null;
    }
    private static final class Inner {
        String type,outer,simple;
        int flags;
    }
    private static Inner inner(ClassDef c) {
        Inner i = new Inner(); i.type=c.getType(); boolean found=false;
        for (Annotation a:c.getAnnotations()) {
            if ("Ldalvik/annotation/EnclosingClass;".equals(a.getType()))
                for (AnnotationElement e:a.getElements())
                    if ("value".equals(e.getName()) && e.getValue() instanceof TypeEncodedValue)
                        i.outer=((TypeEncodedValue)e.getValue()).getValue();
            if ("Ldalvik/annotation/InnerClass;".equals(a.getType())) {
                found=true;
                for (AnnotationElement e:a.getElements()) {
                    if ("name".equals(e.getName()) && e.getValue() instanceof StringEncodedValue)
                        i.simple=((StringEncodedValue)e.getValue()).getValue();
                    if ("accessFlags".equals(e.getName()) && e.getValue() instanceof IntEncodedValue)
                        i.flags=((IntEncodedValue)e.getValue()).getValue();
                }
            }
        }
        return found && i.outer!=null && i.simple!=null ? i : null;
    }
    public static void main(String[] args) throws Exception {
        if(args.length!=2)throw new IllegalArgumentException("classes.dex output-api.jar");
        DexFile dex=DexFileFactory.loadDexFile(new File(args[0]),org.jf.dexlib2.Opcodes.forApi(35));
        List<Inner> members=new ArrayList<Inner>();
        for(ClassDef c:dex.getClasses()){Inner i=inner(c);if(i!=null)members.add(i);}
        try(JarOutputStream out=new JarOutputStream(new FileOutputStream(args[1]))) {
            for(ClassDef c:dex.getClasses()) {
                ClassWriter w=new ClassWriter(0);
                String[] interfaces=new String[c.getInterfaces().size()];
                for(int k=0;k<interfaces.length;k++)interfaces[k]=name(c.getInterfaces().get(k));
                w.visit(Opcodes.V1_8,c.getAccessFlags(),name(c.getType()),signature(c.getAnnotations()),
                        c.getSuperclass()==null?null:name(c.getSuperclass()),interfaces);
                for(Inner i:members)if(i.type.equals(c.getType())||i.outer.equals(c.getType()))
                    w.visitInnerClass(name(i.type),name(i.outer),i.simple,i.flags);
                for(Field f:c.getFields())w.visitField(f.getAccessFlags(),f.getName(),f.getType(),signature(f.getAnnotations()),null).visitEnd();
                for(Method m:c.getMethods()) {
                    if("<clinit>".equals(m.getName()))continue;
                    StringBuilder d=new StringBuilder("(");
                    for(CharSequence p:m.getParameterTypes())d.append(p);
                    d.append(')').append(m.getReturnType());
                    int flags=m.getAccessFlags()&0xffff;
                    MethodVisitor body=w.visitMethod(flags,m.getName(),d.toString(),signature(m.getAnnotations()),null);
                    if((flags&(Opcodes.ACC_ABSTRACT|Opcodes.ACC_NATIVE))==0) {
                        body.visitCode();body.visitInsn(Opcodes.ACONST_NULL);body.visitInsn(Opcodes.ATHROW);body.visitMaxs(1,100);
                    }
                    body.visitEnd();
                }
                w.visitEnd();out.putNextEntry(new JarEntry(name(c.getType())+".class"));out.write(w.toByteArray());out.closeEntry();
            }
        }
    }
}
