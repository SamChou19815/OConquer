open Definitions

type t = {
  identity: player_identity;
  id: int;
  direction: int;
  num_soliders: int;
  morale: int;
  leadership: int;
}

let init (identity: player_identity) (id: int) (direction: int)
    (num_soliders: int) (morale: int) (leadership: int) =
  { identity; id; direction; num_soliders; morale; leadership }

let default_init (identity: player_identity) (id: int) (direction: int) =
  init identity id direction 10000 1 1

let num_soliders (mil_unit: t) : int = mil_unit.num_soliders

let morale (mil_unit: t) : int = mil_unit.morale

let leadership (mil_unit: t) : int = mil_unit.leadership

let attack (u1, u2: t * t) : (t option * t option) =
  failwith "Unimplemented"

let divide (mil_unit: t) : (t * t) option = None
