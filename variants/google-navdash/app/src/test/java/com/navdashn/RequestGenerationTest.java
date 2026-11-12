package com.navdashn;

import org.junit.Test;
import static org.junit.Assert.*;

public final class RequestGenerationTest {
    @Test public void selectingANewDestinationRejectsAnOlderResult() {
        RequestGeneration gate = new RequestGeneration();
        long first = gate.begin(), second = gate.begin();
        assertFalse(gate.accepts(first));
        assertTrue(gate.accepts(second));
    }

    @Test public void stopCancelsAnInflightRouteAndExplicitRestartCanProceed() {
        RequestGeneration gate = new RequestGeneration();
        long beforeStop = gate.begin();
        gate.cancel();
        assertFalse(gate.accepts(beforeStop));
        long restart = gate.begin();
        assertTrue(gate.accepts(restart));
        assertFalse(gate.accepts(beforeStop));
    }

    @Test public void rotationDisposesTheOldActivityWithoutAffectingItsReplacement() {
        RequestGeneration oldActivity = new RequestGeneration();
        long oldRequest = oldActivity.begin();
        oldActivity.close();
        RequestGeneration replacement = new RequestGeneration();
        long newRequest = replacement.begin();
        assertFalse(oldActivity.accepts(oldRequest));
        assertTrue(replacement.accepts(newRequest));
        try { oldActivity.begin(); fail("Destroyed activity must not issue another request"); }
        catch (IllegalStateException expected) { }
    }

    @Test public void neverAcceptsUnissuedOrFutureRequests() {
        RequestGeneration gate = new RequestGeneration();
        assertFalse(gate.accepts(0));
        long request = gate.begin();
        assertFalse(gate.accepts(request + 1));
        gate.close();
        gate.cancel();
        assertFalse(gate.accepts(request));
    }
}
