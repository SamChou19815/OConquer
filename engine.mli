type state

type game_info = {
  info: string;
}

val init : Command.program -> Command.program -> state

val next : state -> state

(* TODO getter methods *)

val get_mil_unit : int -> int -> state -> string

val get_game_info : state -> game_info
