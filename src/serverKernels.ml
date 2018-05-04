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
   * [run_simulation p s] runs a simulation on the given state [s], updating
   * state in-place when necessary.
   *
   * Requires:
   * - [p] is a pair of programs.
   * - [s] is a legal server state.
   * @return None.
   * Effect: [s] got updated as running.
  *)
  let rec run_simulation (p: Command.program * Command.program) (s: state) =
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
            let (next_state, diff_record) = Engine.next game_state in
            s.game_state <- Some next_state;
            ArrayList.add diff_record s.diff_logs;
            false
        in
        Mutex.unlock s.mutex;
        if ended then Command.stop_program p else run_simulation p s
      end

  let start_simulation (p1: string) (p2: string) (s: state) =
    if s.game_state <> None then `AlreadyRunning
    else match Command.from_string p1 p2 with
      | None -> `DoesNotCompile
      | Some p -> begin
          let (b, w) = p in
          Mutex.lock s.mutex;
          (* Clear old diff logs *)
          s.diff_logs <- ArrayList.make (create_diff_record []);
          let (init_state, diff_record) = Engine.init b w in
          s.game_state <- Some init_state;
          s.game_status <- InProgress;
          ArrayList.add diff_record s.diff_logs;
          Mutex.unlock s.mutex;
          let _ = Thread.create (run_simulation p) s in
          `OK
        end

  let query (last_seen_round_id: int) (s: state) : string =
    Mutex.lock s.mutex;
    let id = last_seen_round_id + 1 in
    let start_i = if id >= 0 then id else 0 in
    let end_i = ArrayList.size s.diff_logs in
    let diff_logs_lst = ArrayList.sub start_i end_i s.diff_logs in
    let status = s.game_status in
    Mutex.unlock s.mutex;
    let diff_logs = create_diff_logs diff_logs_lst in
    create_game_report diff_logs status
    |> game_report_to_json
    |> Yojson.Basic.to_string

end

module RemoteServerKernel = struct

  (**
   * [game_record] is a mutable record that contains the information of one
   * single game.
  *)
  type game_record = {
    mutable game_status: Definitions.game_status;
    diff_logs: diff_record ArrayList.t;
  }

  type state = {
    mutex: Mutex.t;
    (** [running] reports whether the server is running a simulation. *)
    mutable running: bool;
    (** [signal] is used for thread waiting communication. *)
    mutable signal: Condition.t;
    (** [user_db] records user related information. *)
    mutable user_db: User.Database.t;
    (** [game_records] stores a collection of game histories. *)
    mutable game_records: game_record IntMap.t;
    (** [match_making_queue] contains the queue for match making. *)
    mutable match_making_queue: User.MatchMaking.queue;
  }

  let init () : state = {
    mutex = Mutex.create ();
    signal = Condition.create ();
    running = false;
    user_db = User.Database.empty;
    game_records = IntMap.empty;
    match_making_queue = User.MatchMaking.empty_queue;
  }

  let register (username: string) (password: string) (s: state) : int option =
    Mutex.lock s.mutex;
    let resp =
      match User.Database.register username password s.user_db with
      | None -> None
      | Some (db', token) ->
        let () = s.user_db <- db' in
        Some token
    in
    Mutex.unlock s.mutex;
    resp

  let sign_in (username: string) (password: string) (s: state) : int option =
    Mutex.lock s.mutex;
    let token_opt = User.Database.sign_in username password s.user_db in
    Mutex.unlock s.mutex;
    token_opt

  (**
   * [run_simulation (bt, wt) (bp, wp) s] runs the simulation for player with
   * token [bt] [wt] with program [bp, wp] on server state [s].
   *
   * Requires:
   * - [bt] [wt] are existing user tokens.
   * - [bp] [wp] are legal programs.
   * - [s] is a legal server state.
   * @return None.
   * Effect: one simulation has been run and the game records are updated
   * accordingly.
  *)
  let run_simulation (bt, wt: int * int)
      (bp, wp as p: Command.program * Command.program) (s: state) : unit =
    (* Prep *)
    let (state_init, diff_record_init) = Engine.init bp wp in
    let b_record = {
      game_status = Engine.get_game_status state_init;
      diff_logs = ArrayList.make (create_diff_record []);
    } in
    ArrayList.add diff_record_init b_record.diff_logs;
    let w_record = {
      game_status = Engine.get_game_status state_init;
      diff_logs = ArrayList.make (create_diff_record []);
    } in
    ArrayList.add diff_record_init w_record.diff_logs;
    let game_records = IntMap.(
        s.game_records |> add bt b_record |> add wt w_record
      ) in
    Mutex.lock s.mutex;
    s.game_records <- game_records;
    Mutex.unlock s.mutex;
    (* Run *)
    let game_state = ref state_init in
    let () = s.running <- true in
    let rec run_on_game_state () : unit =
      let game_status = Engine.get_game_status !game_state in
      Mutex.lock s.mutex;
      (* Update Game Status *)
      b_record.game_status <- game_status;
      w_record.game_status <- game_status;
      (* Update Diff Record *)
      let ended = match game_status with
        | BlackWins | WhiteWins | Draw ->
          let () = s.running <- false in
          let () = Command.stop_program p in
          true
        | InProgress ->
          let (next_state, diff_record) = Engine.next !game_state in
          let () = game_state := next_state in
          let () = ArrayList.add diff_record b_record.diff_logs in
          let () = ArrayList.add diff_record w_record.diff_logs in
          false
      in
      Mutex.unlock s.mutex;
      (* Stop Simulation *)
      if ended then Condition.signal s.signal
      else run_on_game_state ()
    in
    run_on_game_state ()

  let submit_programs (token: int) (b: string) (w: string) (s: state) : unit =
    let open User.MatchMaking in
    (* Find best possible legal program from two players. *)
    let find_program_opt p1 p2 =
      let bp_str = get_black_program_from_player p1 in
      let wp_str = get_white_program_from_player p2 in
      match Command.from_string bp_str wp_str with
      | Some p -> Some p
      | None ->
        let bp_str = get_black_program_from_player p2 in
        let wp_str = get_white_program_from_player p1 in
        Command.from_string bp_str wp_str
    in
    (**
     * [wait_until_simulation_stops ()] waits until simulation stops.
     * It's not thread safe.
    *)
    let wait_until_simulation_stops () =
      while s.running do
        Condition.wait s.signal s.mutex
      done
    in
    (* DO the main processing. To be run in a new thread. *)
    let processing () =
      Mutex.lock s.mutex;
      match User.Database.get_user_opt_by_token token s.user_db with
      | None -> Mutex.unlock s.mutex
      | Some user ->
        let player = create_player user b w in
        let queue = accept_player player s.match_making_queue in
        let () = s.match_making_queue <- queue in
        (* Start next part only if the simulation stops *)
        let () = wait_until_simulation_stops () in
        match form_match queue with
        | None -> Mutex.unlock s.mutex
        | Some (queue', p1, p2) ->
          let bt = p1 |> get_user_from_player |> User.token in
          let wt = p2 |> get_user_from_player |> User.token in
          match find_program_opt p1 p2 with
          | None ->
            let () = s.match_making_queue <- queue' in
            Mutex.unlock s.mutex
          | Some (bp, wp) ->
            let () = Mutex.unlock s.mutex in
            ignore (Thread.create (run_simulation (bt, wt) (bp, wp)) s)
    in
    ignore (Thread.create processing ())

  let query_match (token: int) (round_id: int) (s: state) : string option =
    match IntMap.find_opt token s.game_records with
    | None -> None
    | Some game_record ->
      begin
        let id = round_id + 1 in
        let start_i = if id >= 0 then id else 0 in
        Mutex.lock s.mutex;
        let end_i = ArrayList.size game_record.diff_logs in
        let diff_logs_lst = ArrayList.sub start_i end_i game_record.diff_logs in
        let status = game_record.game_status in
        Mutex.unlock s.mutex;
        let diff_logs = create_diff_logs diff_logs_lst in
        let json = create_game_report diff_logs status
                   |> game_report_to_json
                   |> Yojson.Basic.to_string
        in
        Some json
      end

  let score_board (s: state) : string =
    Mutex.lock s.mutex;
    let json = User.Database.score_board s.user_db in
    Mutex.unlock s.mutex;
    Yojson.Basic.to_string json

end
