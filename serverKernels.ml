open Data

module LocalServerKernel : LocalServer.Kernel = struct

  (* TODO do something to ensure thread safety! *)

  type state = {
    mutex: Mutex.t;
    (* Currnet game state.
     * Option type is used to indicate whether a game is running. *)
    mutable game_state: Engine.state option;
    (* diff logs of current running game
     * or last runned game if there is no game running. *)
    mutable diff_logs: diff_logs option;
  }

  let init () = {
    mutex = Mutex.create ();
    game_state = None;
    diff_logs = None;
  }

  (**
   * [run_simulation s] runs a simulation on the given state [s], updating
   * state in-place when necessary.
   *
   * Requires: [s] is a legal server state.
   * @return None.
   * Effect: [s] got updated as running.
  *)
  let run_simulation (s: state) : unit = () (* TODO fix dummy implementation! *)

  let start_simulation (p1: string) (p2: string) (s: state) =
    if s.game_state <> None then `AlreadyRunning
    else match Command.from_string p1 p2 with
      | None -> `DoesNotCompile
      | Some (black_program, white_program) -> begin
          let init_state = Engine.init black_program white_program in
          Mutex.lock s.mutex;
          s.game_state <- Some init_state;
          Mutex.unlock s.mutex;
          (* Should dispatch a new thread here! TODO *)
          run_simulation s;
          `OK
        end
  let query (last_seen_round_id: int) (s: state) : string = "TODO"

end
