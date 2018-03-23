type t

val num_soliders : t -> int

val morale_level : t -> int

val leadership_level : t -> int

val attack : (t * t) -> (t option * t option)

val divide : t -> (t * t) option
