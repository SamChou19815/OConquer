type state

val run : Command.t -> state -> state

(* TODO getter methods *)

val get_mil_unit : int -> int -> state -> string
