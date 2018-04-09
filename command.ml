open Definitions
open Common

type program = string

module type Context = sig
  val get_my_pos : Position.t
  val get_mil_unit : Position.t -> MilUnit.t option
  val get_tile : Position.t -> Tile.t
  val get_map : WorldMap.t
end

let from_string (i: player_identity) (p_str: string) : program option =
  let class_name = match i with
    | Black -> "BlackProgram"
    | White -> "WhiteProgram"
  in
  if Runner.compile_program class_name p_str then Some class_name else None

module ProgramInterpreter (Cxt: Context) = struct

  (** [request_type] defines a set of all supported request types. *)
  type request_type =
    | GetMyPos | GetMilUnit of Position.t | GetTile of Position.t | GetMap

  let rec run_program (program: program) : command = Attack (* TODO Dummy Impl *)
end
