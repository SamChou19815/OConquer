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
        Position myPosition = SDK.getMyPosition();
        SDK.getMilitaryUnit(myPosition);
        SDK.getTile(myPosition);
        return Action.DO_NOTHING;
    }

    /*
     * ******************************************
     * DO NOT EDIT BELOW THIS LINE.
     * ******************************************
     */

}
