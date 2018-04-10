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

let same_mil_unit (m1: t) (m2: t) : bool =
  m1.identity = m2.identity && m1.id = m2.id

let identity (m: t) : player_identity = m.identity

let id (m: t) : int = m.id

let num_soliders (m: t) : int = m.num_soliders

let morale (m: t) : int = m.morale

let leadership (m: t) : int = m.leadership

(**
 * [turn right m] lets the military unit [m] turn right or left depending on
 * whether [right] is true.
 *
 * Requires: [m] is a legal military unit.
 * Returns: the result of turning for that military unit.
*)
let turn (right: bool) (m: t) : t =
  let offset = if right then 1 else -1 in
  let direction' = (m.direction + offset + 4) mod 4 in
  { m with direction = direction' }

let turn_left : t -> t = turn false

let turn_right : t -> t = turn true

let train (m: t) : t =
  (* TODO fix value *)
  { m with morale = m.morale + 1; leadership = m.leadership + 1 }

let attack (t1, t2: Tile.t * Tile.t) (m1, m2: t * t) : (t option * t option) =
  failwith "Unimplemented"

let divide (m: t) : (t * t) option = None

let to_string (m: t) : string =
  let identity = match m.identity with
    | Black -> "Black"
    | White -> "White"
  in
  Printf.sprintf "MIL_UNIT %s %d %d %d %d %d"
    identity m.id m.direction m.num_soliders m.morale m.leadership
