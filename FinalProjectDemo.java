import java.util.LinkedList;
import java.util.List;

/**
 * Illustrate the architecture of final project by Java code with some dummy
 * implementations.
 */
public final class FinalProjectDemo {
    
    private interface Context {
        
        String getMilitaryUnit(int row, int col);
        
        String getNearby(int direction, int distance);
        
    }
    
    private interface State {
        State init = null;
    }
    
    private interface Program {}
    
    private static class WorldMap implements Context {
        
        public State run(Action action) {
            // TODO
            return null;
        }
        
        public List<Program> getProgramList() {
            return new LinkedList<>();
        }
        
        public String getMilitaryUnit(int row, int col) {
            // TODO
            return null;
        }
        
        public String getNearby(int direction, int distance) {
            // TODO
            return null;
        }
        
    }
    
    enum Action {
        ATTACK, NO_NOTHING
    }
    
    private static final class Command {
        
        static Action runProgram(Context c, Program p) {
            return Math.random() < 0.5? Action.ATTACK: Action.NO_NOTHING;
        }
        
    }
    
    public static void main(String... args) {
        // initialize
        WorldMap worldMap = new WorldMap();
        State s = State.init;
        while (true) {
            for (Program program : worldMap.getProgramList()) {
                Action a = Command.runProgram(worldMap, program);
                s = worldMap.run(a);
            }
        }
    }
    
}
