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
    private Action action = null;
    
    private ProgramRunner() {}
    
    @SuppressWarnings("deprecation")
    private void computeAction(Program p) {
        Thread tester = new Thread(() -> {
            Action action = p.getAction();
            synchronized (ProgramRunner.this) {
                this.action = action;
            }
        });
        tester.start();
        try {
            tester.join(TIMEOUT);
        } catch (InterruptedException e) {
            action = Action.DO_NOTHING;
        }
        if (tester.isAlive()) {
            tester.stop();
            action = Action.DO_NOTHING;
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
        System.out.println("COMMAND " + r.action);
    }
    
}
