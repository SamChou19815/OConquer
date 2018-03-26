open Definitions

type program = unit (* TODO Dummy Impl *)

module type Context = sig
  open Common
  val get_mil_unit : Position.t -> MilUnit.t option
  val get_tile : Position.t -> Tile.t option
  val get_position : MilUnit.t -> Position.t option
  val get_map : WorldMap.t
end

let from_string (p_str: string) : program option = None

module ProgramInterpreter (Cxt: Context) = struct
  let rec run_program (program: program) : command = Attack (* TODO Dummy Impl *)
end
