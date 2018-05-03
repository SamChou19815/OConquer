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
    mutable game_state: Engine.state;
    mutable game_status: Definitions.game_status;
    diff_logs: diff_record ArrayList.t;
  }

  type state = {
    mutex: Mutex.t;
    (** [user_db] records user related information. *)
    mutable user_db: User.Database.t;
    (** [game_records] stores a collection of game histories. *)
    mutable game_records: game_record IntMap.t;
    (** [score_board] records the score board of the users. *)
    mutable score_board: int IntMap.t;
    (* TODO add more relevent fields. *)
  }

  let init () : state = {
    mutex = Mutex.create ();
    user_db = User.Database.empty;
    game_records = IntMap.empty;
    score_board = IntMap.empty;
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

  let submit_programs (token: int) (b: string) (w: string)
      (s: state) : bool = false

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
