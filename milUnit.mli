type t

val init : int -> int -> int -> int -> Command.program -> t

val default_init : int -> Command.program -> t

val num_soliders : t -> int

val morale : t -> int

val leadership : t -> int

val attack : (t * t) -> (t option * t option)

val divide : t -> (t * t) option
