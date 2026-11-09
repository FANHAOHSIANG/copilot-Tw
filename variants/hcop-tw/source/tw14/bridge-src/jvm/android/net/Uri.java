package android.net;public class Uri{java.net.URI uri;public static Uri parse(String s){Uri u=new Uri();u.uri=java.net.URI.create(s);return u;}public String getHost(){return uri.getHost();}}
