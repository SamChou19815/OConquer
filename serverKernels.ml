open Common
open Data

module LocalServerKernel : LocalServer.Kernel = struct

  type state = {
    mutex: Mutex.t;
    (* Currnet game state.
     * Option type is used to indicate whether a game is running. *)
    mutable game_state: Engine.state option;
    (* diff logs of current running game
     * or last runned game if there is no game running. *)
    mutable diff_logs: diff_record ArrayList.t;
  }

  let init () = {
    mutex = Mutex.create ();
    game_state = None;
    diff_logs = ArrayList.make (create_diff_record []);
  }

  (**
   * [run_simulation s] runs a simulation on the given state [s], updating
   * state in-place when necessary.
   *
   * Requires: [s] is a legal server state.
   * @return None.
   * Effect: [s] got updated as running.
  *)
  let rec run_simulation (s: state) : unit = () (* TODO fix dummy impl. *)

  let start_simulation (p1: string) (p2: string) (s: state) =
    if s.game_state <> None then `AlreadyRunning
    else match Command.from_string p1 p2 with
      | None -> `DoesNotCompile
      | Some (black_program, white_program) -> begin
          let init_state = Engine.init black_program white_program in
          Mutex.lock s.mutex;
          s.game_state <- Some init_state;
          Mutex.unlock s.mutex;
          let _ = Thread.create run_simulation s in
          `OK
        end

  let query (last_seen_round_id: int) (s: state) : string =
    let start_i = if last_seen_round_id >= 0 then last_seen_round_id else 0 in
    Mutex.lock s.mutex;
    let end_i = ArrayList.size s.diff_logs in
    let diff_logs_lst = ArrayList.sub start_i end_i s.diff_logs in
    Mutex.unlock s.mutex;
    diff_logs_lst |> create_diff_logs
    |> diff_logs_to_json |> Yojson.Basic.to_string

end
