open Common
open Yojson.Basic

type user = {
  username: string;
  password: string;
  token: int;
  rating: float;
}

let username (user: user) : string = user.username

let password (user: user) : string = user.password

let token (user: user) : int = user.token

let rating (user: user) : float = user.rating

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
