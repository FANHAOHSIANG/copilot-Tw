package com.navdashn.navigation;

public class NavController {
    public static final NavController INSTANCE = new NavController();
    public NavState getState() { throw new AssertionError(); }
}
