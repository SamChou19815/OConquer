open Definitions
open Common

type state

val init : Command.program -> Command.program -> state

val next : state -> state

(* TODO getter methods *)

val get_mil_unit : Position.t -> state -> MilUnit.t option

val get_tile : Position.t -> state -> Tile.terrain option

val get_position : MilUnit.t -> state -> Position.t option

val get_game_status : state -> game_status

val get_map : state -> WorldMap.t
