package com.navipilot.obf;

public final class Wide26AutoStartTest {
    private static void check(boolean actual, boolean expected, String message) {
        if (actual != expected) throw new AssertionError(message);
    }
    public static void main(String[] args) {
        WideAutoStart.LaunchGate gate = new WideAutoStart.LaunchGate();
        check(gate.shouldRequest(false, false), false, "disabled must not request");
        check(gate.shouldStart(false, true), false, "disabled must not start");
        check(gate.shouldRequest(true, false), true, "request missing permission once");
        gate.requested = true;
        check(gate.shouldRequest(true, false), false, "do not repeat a denied request");
        check(gate.shouldStart(true, false), false, "no source without permission");
        check(gate.shouldStart(true, true), true, "grant resumes startup");
        gate.completed = true;
        check(gate.shouldStart(true, true), false, "do not undo a manual stop/source change");
        check(gate.shouldRequest(true, false), false, "do not reprompt after startup");
        gate.reset();
        check(gate.shouldStart(true, true), true, "next app launch can start again");
        System.out.println("PASS: auto-start permission, stop, opt-out and restart transitions");
    }
}
