/**
 * User defined program for black side.
 */
public class BlackProgram implements Program {

    BlackProgram() {}

    /*
     * ******************************************
     * DO NOT EDIT ABOVE THIS LINE.
     * ******************************************
     */

    @Override
    public Action getAction() {
        Position myPosition = GameSDK.getMyPosition();
        GameSDK.getMilitaryUnit(myPosition);
        GameSDK.getTile(myPosition);
        return Action.DO_NOTHING;
    }

    /*
     * ******************************************
     * DO NOT EDIT BELOW THIS LINE.
     * ******************************************
     */

}
