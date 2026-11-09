package com.navipilot.obf;
import android.os.IInterface;
import android.view.Surface;
public interface Mt extends IInterface {
 void a(int id); boolean b(int id,int key); int d(String pkg,int id); boolean e(String pkg,int id);
 int f(String name,int width,int height,int dpi,float fps,Surface surface);
 boolean h(int display,int stream,int action,float x,float y,int pointer);
}
