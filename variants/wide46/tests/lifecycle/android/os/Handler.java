package android.os;
import java.util.PriorityQueue;
/** Deterministic host event queue: no sleeping or Android message-loop claim. */
public final class Handler {
    private static long serial;
    private static final PriorityQueue<Task> QUEUE = new PriorityQueue<Task>();
    private static final class Task implements Comparable<Task> {
        final Runnable runnable; final long at, order;
        Task(Runnable runnable, long at) { this.runnable = runnable; this.at = at; this.order = ++serial; }
        public int compareTo(Task other) { int c = Long.compare(at, other.at); return c == 0 ? Long.compare(order, other.order) : c; }
    }
    public Handler(Looper looper) { }
    public boolean post(Runnable task) { return postDelayed(task, 0); }
    public boolean postDelayed(Runnable task, long delay) {
        synchronized (QUEUE) { QUEUE.add(new Task(task, SystemClock.now + delay)); }
        return true;
    }
    public void removeCallbacks(Runnable task) {
        synchronized (QUEUE) { QUEUE.removeIf(item -> item.runnable == task); }
    }
    public static void runReady() {
        for (int count = 0; count < 10000; count++) {
            Task task;
            synchronized (QUEUE) {
                task = QUEUE.peek();
                if (task == null || task.at > SystemClock.now) return;
                QUEUE.remove();
            }
            task.runnable.run();
        }
        throw new AssertionError("unbounded Handler loop");
    }
    public static void clearQueue() { synchronized (QUEUE) { QUEUE.clear(); } }
}
