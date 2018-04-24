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
