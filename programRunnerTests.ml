open OUnit
open Common

(**
 * [black_program_initial] is the initial trivial black program we give to
 * the user.
*)
let black_program_initial = "/**
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
"

(**
 * [white_program_initial] is the initial trivial white program we give to
 * the user.
*)
let white_program_initial = "/**
 * User defined program for white side.
 * Do not use {@code System.in} here.
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
"

(**
 * [get_compiled_programs _] compiles [black_program_initial] and
 * [white_program_initial] and return their compiled version.
 *
 * Requires: None.
 * @return compiled programs.
 * Effect: compiled programs will be generated in the file system.
*)
let get_compiled_programs () : Command.program * Command.program =
  match Command.from_string black_program_initial white_program_initial with
  | None -> failwith "DOES NOT COMPILE!"
  | Some v -> v

(** A pair of compiled black and white programs. *)
let (compiled_black, compiled_white) as p = get_compiled_programs ()

(**
 * [simple_program_tests] is a set of simple programs that always do nothing.
*)
let simple_program_tests = [
  "simple_programs_do_get_result" >:: (fun _ ->
      let state_init = Engine.init compiled_black compiled_white in
      let next (s, _) = Engine.next s in
      ignore(repeats 500 next state_init)
    );
  "program_does_end" >:: (fun _ -> Command.stop_program p)
]

let tests =
  List.flatten [
    simple_program_tests;
  ]