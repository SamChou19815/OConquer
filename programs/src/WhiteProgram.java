/**
 * User defined program for white side.
 * Do not use {@code System.in} here.
 */
public class WhiteProgram implements Program {

    WhiteProgram() {}

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
