package android.os;

import java.util.PriorityQueue;

/** Deterministic time queue; all real integration scheduling code is retained. */
public final class Handler {
    private static long nextOrder;
    private static final PriorityQueue<Task> QUEUE = new PriorityQueue<Task>();
    private final Looper looper;
    public Handler(Looper looper) { this.looper = looper; }
    public Looper getLooper() { return looper; }
    public boolean post(Runnable task) { return postDelayed(task, 0); }
    public boolean postDelayed(Runnable task, long delay) {
        QUEUE.add(new Task(this, task, SystemClock.elapsedRealtime() + Math.max(0, delay), nextOrder++));
        return true;
    }
    public void removeCallbacks(Runnable task) {
        QUEUE.removeIf(value -> value.owner == this && value.task == task);
    }
    public static void runUntil(long target) {
        if (target < SystemClock.elapsedRealtime()) throw new IllegalArgumentException("time reversal");
        int executed = 0;
        while (!QUEUE.isEmpty() && QUEUE.peek().when <= target) {
            if (++executed > 10000) throw new AssertionError("unbounded scheduler loop");
            Task task = QUEUE.remove();
            SystemClock.setElapsedRealtime(Math.max(SystemClock.elapsedRealtime(), task.when));
            task.task.run();
        }
        SystemClock.setElapsedRealtime(target);
    }
    public static int pendingTasks() { return QUEUE.size(); }
    private static final class Task implements Comparable<Task> {
        final Handler owner;
        final Runnable task;
        final long when;
        final long order;
        Task(Handler owner, Runnable task, long when, long order) {
            this.owner = owner; this.task = task; this.when = when; this.order = order;
        }
        public int compareTo(Task other) {
            int time = Long.compare(when, other.when);
            return time != 0 ? time : Long.compare(order, other.order);
        }
    }
}
