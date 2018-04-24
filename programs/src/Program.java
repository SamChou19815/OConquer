/**
 * Program is the interface that the user's program must obey.
 */
@FunctionalInterface
public interface Program {
    
    /**
     * Obtain the action to perform.
     *
     * @return the action to perform.
     */
    Action getAction();
    
}
