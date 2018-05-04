let black_program_initial = "import java.util.Random;

/*
 * YOU CAN IMPORT IF YOU WANT.
 */

/**
 * User defined program for black side.
 */
public class BlackProgram implements Program {

    private final GameSDK SDK;

    BlackProgram(GameSDK SDK) {
        this.SDK = SDK;
    }

    /*
     * ******************************************
     * DO NOT EDIT ABOVE THIS LINE.
     * ******************************************
     */

    @Override
    public Action getAction() {
        int random = (int) (Math.random() * 10);
        for (int i = 0; i < random; i++) {
            Position myPosition = SDK.getMyPosition();
            SDK.getMilitaryUnit(myPosition);
            SDK.getTile(myPosition);
        }
        Action[] values = Action.values();
        return values[new Random().nextInt(values.length)];
    }

    /*
     * ******************************************
     * DO NOT EDIT BELOW THIS LINE.
     * ******************************************
     */

}
"

let white_program_initial = "import java.util.Random;

/*
 * YOU CAN IMPORT IF YOU WANT.
 */

/**
 * User defined program for white side.
 */
public class WhiteProgram implements Program {

    private final GameSDK SDK;

    WhiteProgram(GameSDK SDK) {
        this.SDK = SDK;
    }

    /*
     * ******************************************
     * DO NOT EDIT ABOVE THIS LINE.
     * ******************************************
     */

    @Override
    public Action getAction() {
        int random = (int) (Math.random() * 10);
        for (int i = 0; i < random; i++) {
            Position myPosition = SDK.getMyPosition();
            SDK.getMilitaryUnit(myPosition);
            SDK.getTile(myPosition);
        }
        Action[] values = Action.values();
        return values[new Random().nextInt(values.length)];
    }

    /*
     * ******************************************
     * DO NOT EDIT BELOW THIS LINE.
     * ******************************************
     */

}
"
