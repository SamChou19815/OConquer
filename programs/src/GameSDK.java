import java.util.Scanner;

/**
 * The Game SDK provided to the user.
 */
public final class GameSDK {
    
    /**
     * Scanner of the SDK.
     */
    private final Scanner scanner;
    
    /**
     * Forbidden instantiation of GameSDK.
     */
    GameSDK(Scanner scanner) {
        this.scanner = scanner;
    }
    
    /**
     * Obtain the position of myself.
     *
     * @return the position of myself.
     */
    public Position getMyPosition() {
        System.out.println("REQUEST MY_POS");
        String[] words = scanner.nextLine().split(" ");
        int x = Integer.parseInt(words[0]), y = Integer.parseInt(words[1]);
        return new Position(x, y);
    }
    
    /**
     * Obtain the military unit at the given position.
     *
     * @param p given position of the military unit.
     * @return the military unit at the given position {@code p},
     * {@code null} if there is no military unit there.
     */
    public MilitaryUnit getMilitaryUnit(Position p) {
        System.out.println("REQUEST MIL_UNIT " + p.getX() + " " + p.getY());
        String line = scanner.nextLine();
        if ("NONE".equals(line)) {
            return null;
        }
        return new MilitaryUnit(line);
    }
    
    /**
     * Obtain the tile at the given position.
     *
     * @param p given position of the tile.
     * @return the tile at the given position {@code p}.
     */
    public Tile getTile(Position p) {
        System.out.println("REQUEST TILE " + p.getX() + " " + p.getY());
        String line = scanner.nextLine();
        return new Tile(line);
    }

}
