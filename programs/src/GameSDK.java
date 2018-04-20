import java.util.Scanner;

/**
 * The Game SDK provided to the user.
 */
public final class GameSDK {
    
    /**
     * Scanner of the SDK.
     */
    private static final Scanner scanner = new Scanner(System.in);
    
    private GameSDK() {}
    
    /**
     * Obtain the position of myself.
     *
     * @return the position of myself.
     */
    public static Position getMyPosition() {
        System.out.println("REQUEST MY_POS");
        return new Position(scanner.nextInt(), scanner.nextInt());
    }
    
    /**
     * Obtain the military unit at the given position.
     *
     * @param p given position of the military unit.
     * @return the military unit at the given position {@code p},
     * {@code null} if there is no military unit there.
     */
    public static MilitaryUnit getMilitaryUnit(Position p) {
        System.out.println("REQUEST MIL_UNIT");
        return new MilitaryUnit(scanner.nextLine());
    }
    
    /**
     * Obtain the tile at the given position.
     *
     * @param p given position of the tile.
     * @return the tile at the given position {@code p}.
     */
    public static Tile getTile(Position p) {
        System.out.println("REQUEST TILE");
        return new Tile(scanner.nextLine());
    }

}
