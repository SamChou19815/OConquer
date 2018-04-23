open Common
open Data

module LocalServerKernel : LocalServer.Kernel = struct

  type state = {
    mutex: Mutex.t;
    (* Currnet game state.
     * Option type is used to indicate whether a game is running. *)
    mutable game_state: Engine.state option;
    (* Game result, it should only be used for querying. *)
    mutable game_status: Definitions.game_status;
    (* diff logs of current running game
     * or last runned game if there is no game running. *)
    mutable diff_logs: diff_record ArrayList.t;
  }

  let init () = {
    mutex = Mutex.create ();
    game_state = None;
    game_status = InProgress;
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
  let rec run_simulation (s: state) : unit =
    match s.game_state with
    | None -> failwith "Unexpected state!"
    | Some game_state ->
      begin
        Mutex.lock s.mutex;
        let game_status = Engine.get_game_status game_state in
        s.game_status <- game_status;
        let ended = match game_status with
          | BlackWins | WhiteWins | Draw ->
            s.game_state <- None;
            true
          | InProgress ->
            Mutex.lock s.mutex;
            let (next_state, diff_record) = Engine.next game_state in
            s.game_state <- Some next_state;
            ArrayList.add diff_record s.diff_logs;
            false
        in
        Mutex.unlock s.mutex;
        if ended then () else run_simulation s
      end

  let start_simulation (p1: string) (p2: string) (s: state) =
    if s.game_state <> None then `AlreadyRunning
    else match Command.from_string p1 p2 with
      | None -> `DoesNotCompile
      | Some (b, w) -> begin
          Mutex.lock s.mutex;
          (* Clear old diff logs *)
          s.diff_logs <- ArrayList.make (create_diff_record []);
          let (init_state, diff_record) = Engine.init b w in
          s.game_state <- Some init_state;
          s.game_status <- InProgress;
          ArrayList.add diff_record s.diff_logs;
          Mutex.unlock s.mutex;
          let _ = Thread.create run_simulation s in
          `OK
        end

  let query (last_seen_round_id: int) (s: state) : string =
    Mutex.lock s.mutex;
    let start_i = if last_seen_round_id >= 0 then last_seen_round_id else 0 in
    let end_i = ArrayList.size s.diff_logs in
    let diff_logs_lst = ArrayList.sub start_i end_i s.diff_logs in
    let status = s.game_status in
    Mutex.unlock s.mutex;
    let diff_logs = create_diff_logs diff_logs_lst in
    create_game_report diff_logs status
    |> game_report_to_json
    |> Yojson.Basic.to_string

end
