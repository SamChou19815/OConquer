type t = {
  direction: int;
  num_soliders: int;
  morale_level: int;
  leadership_level: int
}

let num_soliders (mil_unit: t) : int = mil_unit.num_soliders

let morale_level (mil_unit: t) : int = mil_unit.morale_level

let leadership_level (mil_unit: t) : int = mil_unit.leadership_level

let attack (u1, u2: t * t) : (t option * t option) =
  failwith "Unimplemented"

let divide (mil_unit: t) : (t * t) option = None
