public class GameSDK {

    // PART 1: Information about itself.

    public static int getNumberOfMySolidiers() {
        return 0;
    }

    public static int getMyMoraleLevel() {
        return 0;
    }

    public static int getMyLeadershipLevel() {
        return 0;
    }

    // PART 2: Information about surrounding information.

    public static int[] getNearbyInformation(int[] param) {
        int direction = param[0];
        int distance = param[1];
        return new int[]{
            1, 2, 3, 4 // type, number of soldiers, ...
        };
    }

    // PART 3: Information about the game.

    public static int[] getDimension() {
        return new int[]{50, 68};
    }

}
