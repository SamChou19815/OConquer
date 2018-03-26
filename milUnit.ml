type t = {
  id: int;
  direction: int;
  num_soliders: int;
  morale: int;
  leadership: int;
}

let init (id: int) (direction: int) (num_soliders: int) (morale: int)
    (leadership: int) =
  { id; direction; num_soliders; morale; leadership }

let default_init (id: int) (direction: int) = init id direction 10000 1 1

let num_soliders (mil_unit: t) : int = mil_unit.num_soliders

let morale (mil_unit: t) : int = mil_unit.morale

let leadership (mil_unit: t) : int = mil_unit.leadership

let attack (u1, u2: t * t) : (t option * t option) =
  failwith "Unimplemented"

let divide (mil_unit: t) : (t * t) option = None
