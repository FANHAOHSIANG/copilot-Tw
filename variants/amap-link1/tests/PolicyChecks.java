package com.navipilot.obf;

/** Checks externally visible retry, refusal and generation barriers without Android scheduling. */
public final class PolicyChecks {
    private static int checks;

    private static void check(boolean condition, String message) {
        checks++;
        if (!condition) throw new AssertionError(message);
    }

    private static void finiteRetryBudget() {
        WideAmapLinkPolicy policy = new WideAmapLinkPolicy();
        check(!policy.beginAttempt(), "stopped policy cannot bind");
        check(policy.retryDelayMs() == -1, "stopped policy cannot schedule retry");
        check(policy.start(), "first start enables reader");
        check(!policy.start(), "repeated start is idempotent");
        long[] delays = {1500, 3000, 6000, 10000, -1};
        for (int i = 0; i < delays.length; i++) {
            check(policy.beginAttempt(), "attempt " + (i + 1) + " within finite budget");
            check(policy.attempts() == i + 1, "attempt count");
            check(policy.retryDelayMs() == delays[i], "bounded backoff after attempt " + (i + 1));
            check(!policy.start(), "periodic start cannot replenish consumed attempts");
        }
        check(!policy.beginAttempt(), "sixth automatic attempt rejected");
        check(!policy.start(), "exhaustion is not reset by periodic start");
        check(!policy.beginAttempt(), "ordinary start still cannot bind after exhaustion");
        check(policy.retryAfterMapLaunch(), "explicit user map launch can permit new attempt");
        check(policy.attempts() == 0, "explicit retry resets budget");
        check(policy.beginAttempt(), "explicit retry starts once");
        check(policy.attempts() == 1, "fresh budget increments normally");
    }

    private static void authenticationRefusalIsTerminalUntilExplicitRetry() {
        WideAmapLinkPolicy policy = new WideAmapLinkPolicy();
        policy.start();
        long generation = policy.invalidate();
        policy.beginAttempt();
        check(policy.isCurrent(generation), "active callback generation recognized before refusal");
        policy.refuse();
        check(!policy.isCurrent(generation), "auth refusal immediately blocks data callbacks");
        check(!policy.beginAttempt(), "auth refusal cannot trigger automatic bind");
        check(policy.retryDelayMs() == -1, "auth refusal has no retry timer");
        check(!policy.start(), "periodic reader start cannot silently reset refusal");
        check(!policy.beginAttempt(), "refusal persists across periodic starts");
        policy.invalidate();
        check(!policy.beginAttempt(), "generation reset alone cannot bypass refusal");
        check(policy.retryAfterMapLaunch(), "explicit retry can ask provider again using normal identity");
        check(policy.beginAttempt(), "explicit retry uses a new normal attempt");
        check(!policy.isCurrent(generation), "old refused generation remains invalid");
    }

    private static void generationsAndLifecycle() {
        WideAmapLinkPolicy policy = new WideAmapLinkPolicy();
        policy.start();
        long first = policy.invalidate();
        check(policy.generation() == first && policy.isCurrent(first), "first binding generation");
        long second = policy.invalidate();
        check(second > first, "generation increases on replacement");
        check(!policy.isCurrent(first), "stale binder callback rejected");
        check(policy.isCurrent(second), "replacement binder callback accepted");
        policy.stop();
        check(!policy.isCurrent(second), "stop blocks current callback");
        check(!policy.beginAttempt() && policy.retryDelayMs() == -1, "stop cancels retry eligibility");
        policy.invalidate();
        check(policy.start(), "explicit source reselection can restart stopped reader");
        check(!policy.isCurrent(second), "stop/reselect barrier preserves old callback rejection");
        policy.close();
        check(policy.isClosed() && !policy.isRunning(), "close is terminal");
        check(!policy.start(), "closed reader cannot restart");
        check(!policy.retryAfterMapLaunch(), "map launch cannot revive a closed instance");
        check(!policy.beginAttempt() && policy.retryDelayMs() == -1, "closed reader has no future retries");
        check(!policy.isCurrent(policy.generation()), "close invalidates every callback");
    }

    public static void main(String[] args) {
        finiteRetryBudget();
        authenticationRefusalIsTerminalUntilExplicitRetry();
        generationsAndLifecycle();
        System.out.println("PolicyChecks: " + checks + " assertions passed");
    }
}
