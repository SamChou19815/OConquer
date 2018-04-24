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
    
    private ProgramRunner() {}
    
    @SuppressWarnings("deprecation")
    private void computeAction(Program p) {
        Thread tester = new Thread(() -> {
            try {
                actionAtomic.set(p.getAction());
            } catch (TooManySDKCallsException e) {
                actionAtomic.set(Action.DO_NOTHING);
            }
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
        String which = args[0];
        Program p;
        if ("black".equals(which)) {
            p = new BlackProgram();
        } else if ("white".equals(which)) {
            p = new WhiteProgram();
        } else {
            throw new Error();
        }
        ProgramRunner r = new ProgramRunner();
        r.computeAction(p);
        System.out.println("COMMAND " + r.actionAtomic.get());
    }
    
}
