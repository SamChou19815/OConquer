open OUnit
open ProgramLists

(**
 * [server_client_interaction_test ()] tests the server kernel by simulating
 * the server client interaction.
 *
 * Requires: None.
 * @return None.
 * Effect: a test is run.
*)
let server_client_interaction_test () : unit =
  let open ServerKernels.LocalServerKernel in
  let server_state = init () in
  let contains s1 s2 =
    let re = Str.regexp_string s2 in
    try ignore (Str.search_forward re s1 0); true
    with Not_found -> false
  in
  match start_simulation
          black_program_initial white_program_initial server_state with
  | `AlreadyRunning | `DoesNotCompile -> failwith "Impossible!"
  | `OK ->
    let terminate = ref false in
    let id = ref (-1) in
    while not (!terminate) do
      let s = query (!id) server_state in
      if not (contains s "IN_PROGRESS") then
        terminate := true
      else incr id
    done

let tests = [
  "server_client_interaction_test" >:: server_client_interaction_test
]
