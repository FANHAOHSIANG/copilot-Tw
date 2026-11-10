package com.navipilot.obf;

import android.hardware.display.VirtualDisplay;
import android.os.Parcel;
import android.os.RemoteException;
import android.util.Log;
import java.util.concurrent.ConcurrentHashMap;

public final class WideDisplayResize {
    private static final int RESIZE = 0x31;
    private static final String DESCRIPTOR = "com.navipilot.amap2tesla.privileged.IPrivilegedDisplayService";

    static boolean send(Mt api, int id, int width, int height, int density) throws RemoteException {
        Parcel request = Parcel.obtain();
        Parcel reply = Parcel.obtain();
        try {
            request.writeInterfaceToken(DESCRIPTOR);
            request.writeInt(id);
            request.writeInt(width);
            request.writeInt(height);
            request.writeInt(density);
            if (!api.asBinder().transact(RESIZE, request, reply, 0)) return false;
            reply.readException();
            return reply.readInt() != 0;
        } finally {
            reply.recycle();
            request.recycle();
        }
    }

    /** Called after the original Binder stub validates its interface token. */
    public static void receive(ConcurrentHashMap<Integer, zM> displays, Parcel request, Parcel reply) {
        int id = request.readInt();
        int width = request.readInt();
        int height = request.readInt();
        int density = request.readInt();
        boolean valid = id > 0 && width >= 2 && width <= 1280 && height >= 2 && height <= 1280
                && density >= 120 && density <= 1280;
        boolean[] changed = {false};
        if (valid) displays.computeIfPresent(id, (key, entry) -> {
            VirtualDisplay display = entry.a;
            String name = display.getDisplay().getName();
            if (!"WideAmapAuto".equals(name) && !WideAmapIme.isPhoneDisplay(name)
                    && !WideVariant.GOOGLE_DISPLAY.equals(name) && !"WideShield".equals(name)) return entry;
            try {
                display.resize(width, height, density);
                changed[0] = true;
                return new zM(display, width, height);
            } catch (RuntimeException rejected) {
                Log.w("WideDisplayResize", "Display resize rejected: " + id, rejected);
                return entry;
            }
        });
        reply.writeNoException();
        reply.writeInt(changed[0] ? 1 : 0);
    }
}
