type t = {
  direction: int;
  num_soliders: int;
  morale: int;
  leadership: int;
  program: Command.program;
}

let init (direction: int) (num_soliders: int) (morale: int)
    (leadership: int) (program: Command.program) =
  { direction; num_soliders; morale; leadership; program }

let default_init (direction: int) (program: Command.program) =
  { direction; num_soliders = 10000; morale = 1; leadership = 1; program }

let num_soliders (mil_unit: t) : int = mil_unit.num_soliders

let morale (mil_unit: t) : int = mil_unit.morale

let leadership (mil_unit: t) : int = mil_unit.leadership

let program (mil_unit: t) : Command.program = mil_unit.program

let attack (u1, u2: t * t) : (t option * t option) =
  failwith "Unimplemented"

let divide (mil_unit: t) : (t * t) option = None
