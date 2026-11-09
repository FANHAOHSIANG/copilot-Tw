package android.content.res;public class AssetManager{
 public java.io.InputStream open(String n)throws java.io.IOException{return new java.io.FileInputStream("work/assets/"+n);}
 public String[] list(String n){String[] a=new java.io.File("work/assets/"+n).list();return a==null?new String[0]:a;}
}
