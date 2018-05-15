open OUnit2
open Definitions

let tests = [
  "engine_start_with_in_progress" >:: (fun _ ->
      let open ProgramLists in
      match Command.from_string black_program_initial white_program_initial with
      | None -> failwith "Bad!"
      | Some (b, w) ->
        let (s, _) = Engine.init b w in
        assert_equal InProgress (Engine.get_game_status s);
        Command.stop_program (b, w)
    )
]
