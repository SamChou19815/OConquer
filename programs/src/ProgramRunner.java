import java.util.Scanner;
import java.util.concurrent.atomic.AtomicReference;

/**
 * The Program runner. The user should not worry about this.
 */
public final class ProgramRunner {

    /**
     * The settings for timeout.
     */
    private static final long TIMEOUT = 1000;
    /**
     * Test code that is used to test user's code.
     */
    private AtomicReference<Action> actionAtomic = new AtomicReference<>(Action.DO_NOTHING);

    /**
     * Forbidden instantiation.
     */
    private ProgramRunner() {}

    @SuppressWarnings("deprecation")
    private void computeAction(Program p) {
        Thread tester = new Thread(() -> {
            actionAtomic.set(p.getAction());
        });
        tester.start();
        try {
            // Force an end!
            tester.join(TIMEOUT);
        } catch (InterruptedException e) {
            throw new RuntimeException("Unexpected Behavior!");
        }
        if (tester.isAlive()) {
            tester.stop();
        }
    }

    public static void main(String... args) {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            String request = scanner.nextLine();
            Program p;
            if ("BLACK".equals(request)) {
                System.out.println("CONFIRMED!");
                p = new BlackProgram(new GameSDK(scanner));
            } else if ("WHITE".equals(request)) {
                System.out.println("CONFIRMED!");
                p = new WhiteProgram(new GameSDK(scanner));
            } else if ("END".equals(request)) {
                return;
            } else {
                throw new Error("WRONG CMD!");
            }
            ProgramRunner r = new ProgramRunner();
            r.computeAction(p);
            System.out.println("COMMAND " + r.actionAtomic.get().name());
        }
    }

}
