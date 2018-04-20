let black_program_initial = "/**
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
        return Action.DO_NOTHING;
    }

    /*
     * ******************************************
     * DO NOT EDIT BELOW THIS LINE.
     * ******************************************
     */

}
"

let white_program_initial = "/**
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
        return Action.DO_NOTHING;
    }

    /*
     * ******************************************
     * DO NOT EDIT BELOW THIS LINE.
     * ******************************************
     */

}
"
let they_do_compile =
  Runner.compile_program black_program_initial white_program_initial

let () = print_endline (string_of_bool they_do_compile)
