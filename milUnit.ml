open Definitions

type t = {
  identity: player_identity;
  id: int;
  direction: int; (* 0 -> north, 1 -> east, 2 -> south, 3 -> west *)
  num_soliders: int;
  morale: int;
  leadership: int;
}

let init (identity: player_identity) (id: int) (direction: int)
    (num_soliders: int) (morale: int) (leadership: int) =
  { identity; id; direction; num_soliders; morale; leadership }

let default_init (identity: player_identity) (id: int) (direction: int) =
  init identity id direction 10000 1 1

let num_soliders (m: t) : int = m.num_soliders

let morale (m: t) : int = m.morale

let leadership (m: t) : int = m.leadership

let attack (u1, u2: t * t) : (t option * t option) =
  failwith "Unimplemented"

let divide (m: t) : (t * t) option = None

let to_string (m: t) : string =
  let identity = match m.identity with
    | Black -> "Black"
    | White -> "White"
  in
  Printf.sprintf "MIL_UNIT %s %d %d %d %d %d"
    identity m.id m.direction m.num_soliders m.morale m.leadership
