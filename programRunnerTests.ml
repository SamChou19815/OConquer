open OUnit

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
let (compiled_black_program, compiled_white_program) =
  match Command.from_string black_program_initial white_program_initial with
  | None -> failwith "DOES NOT COMPILE!" | Some v -> v

let simple_program_tests = [
  "simple_programs_compile" >:: (fun _ ->
      ignore compiled_black_program; ignore compiled_white_program);
  "do_get_result" >:: (fun _ ->
      let state = Engine.init compiled_black_program compiled_white_program in
      ignore(Engine.(state |> next |> next |> next |> next |> next))
    )
]

let tests =
  List.flatten [
    simple_program_tests
  ]
