open Common
open Yojson.Basic

type user = {
  username: string; (** [username] is the username. *)
  password: string; (** [password] is the password. *)
  token: int; (** [token] is the security token of the user. *)
  rating: float; (** [rating] is the rating of the user. *)
}

let token (user: user) : int = user.token

module Elo = struct

  (** [k] is the constant used in the ELO rating algorithm. *)
  let k = 30.

  (**
   * [winning_probability rating1 rating2] calculates the expected winning
   * probability pair of the players of [rating1] and [rating2].
   *
   * Requires: [rating1] [rating2] are valid ELO ratings.
   * @return expected winning probability pair.
  *)
  let winning_probability (rating1: float) (rating2: float) : float * float =
    let p1 = 1. /. (1. +. 10. ** ((rating1 -. rating2) /. 400.)) in
    let p2 = 1. -. p1 in
    (p1, p2)

  let update_rating (p1_wins: float)
      (rating1, rating2: float * float) : float * float =
    let (p1_expected, p2_expected) = winning_probability rating1 rating2 in
    let r1 = rating1 +. k *. (p1_wins -. p1_expected) in
    let r2 = rating2 +. k *. (1. -. p1_wins -. p2_expected) in
    (r1, r2)

end

module Database = struct
  (** [t] should always been synced between [token_map] and [username_map]. *)
  type t = {
    token_map: user IntMap.t;
    username_map: user StringMap.t;
  }

  let empty : t = { token_map = IntMap.empty; username_map = StringMap.empty; }

  let register (username: string) (password: string)
      (db: t) : (t * int) option =
    if StringMap.mem username db.username_map then None
    else
      begin
        Random.self_init ();
        let rec find_non_conflicting_token () =
          let random_token = Random.int max_int in
          if IntMap.mem random_token db.token_map then
            find_non_conflicting_token ()
          else random_token
        in
        let token = find_non_conflicting_token () in
        let user = { username; password; token; rating = 0. } in
        let db' = {
          token_map = IntMap.add token user db.token_map;
          username_map = StringMap.add username user db.username_map;
        } in
        Some (db', token)
      end

  let sign_in (username: string) (password: string) (db: t) : int option =
    match StringMap.find_opt username db.username_map with
    | None -> None
    | Some user -> Some user.token

  let has_token (token: int) (db: t) : bool = IntMap.mem token db.token_map

  let get_user_opt_by_token (token: int) (db: t) : user option =
    IntMap.find_opt token db.token_map

  let update_rating (game_result: Definitions.game_status)
      (black_token: int) (white_token: int) (db: t) : t =
    let p1_wins = match game_result with
      | InProgress -> invalid_arg "Game has not ended!"
      | BlackWins -> 1.
      | WhiteWins -> 0.
      | Draw -> 0.5
    in
    let (u1, u2) = (
      IntMap.find black_token db.token_map,
      IntMap.find white_token db.token_map
    ) in
    let (r1, r2) = Elo.update_rating p1_wins (u1.rating, u2.rating) in
    let u1' = { u1 with rating = r1 } in
    let u2' = { u2 with rating = r2 } in
    {
      username_map = StringMap.(
          db.username_map |> add u1'.username u1' |> add u2'.username u2'
        );
      token_map = IntMap.(
          db.token_map |> add u1'.token u1' |> add u2'.token u2'
        );
    }

  let score_board (db: t) : json =
    let p_to_json (_, user: 'a * user) : json = `Assoc [
        "username", `String user.username;
        "rating", `Float user.rating
      ]
    in
    `List (db.token_map |> IntMap.bindings |> List.map p_to_json)

end

module MatchMaking = struct

  type player = {
    user: user;
    black_program: string;
    white_program: string;
  }

  type queue = player FloatMap.t

  let create_player (user: user)
      (black_program: string) (white_program: string) : player =
    { user; black_program; white_program; }

  let get_user_from_player (player: player) : user = player.user

  let get_black_program_from_player (player: player) : string =
    player.black_program

  let get_white_program_from_player (player: player) : string =
    player.white_program

  let empty_queue : queue = FloatMap.empty

  let accept_player (player: player) : queue -> queue =
    FloatMap.add player.user.rating player

  let form_match (queue: queue) : (queue * player * player) option =
    (* Helps to the the min diff pair. *)
    let rec form_match_helper (q: (float * player) list)
        (acc: float * player * player) : (float * player * player) =
      let (acc_min, p1, p2) = acc in
      match q with
      | [] | _::[] -> acc
      | (rating1, p3)::((rating2, p4)::_ as tl) ->
        let temp_rating = rating2 -. rating1 in
        let acc' =
          if temp_rating < acc_min then (temp_rating, p3, p4)
          else (acc_min, p1, p2)
        in
        form_match_helper tl acc'
    in
    match FloatMap.bindings queue with
    | [] | _::[] -> None
    | (rating1, p1)::((rating2, p2)::_ as tl) ->
      let curr_diff_min = rating2 -. rating1 in
      let (target, player1, player2) =
        form_match_helper tl (curr_diff_min, p1, p2)
      in
      let queue' = FloatMap.(queue |> remove rating1 |> remove rating2) in
      Some (queue', player1, player2)

end
