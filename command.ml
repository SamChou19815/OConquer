open Definitions

type program = string

module type Context = sig
  open Common
  val get_mil_unit : Position.t -> MilUnit.t option
  val get_tile : Position.t -> Tile.t option
  val get_position : MilUnit.t -> Position.t option
  val get_map : WorldMap.t
end

let from_string (i: player_identity) (p_str: string) : program option =
  let class_name = match i with
    | Black -> "BlackProgram"
    | White -> "WhiteProgram"
  in
  let fd = Unix.openfile class_name [O_CREAT; O_WRONLY; O_TRUNC] 0o640 in
  let l = Unix.single_write_substring fd p_str 0 (String.length p_str) in
  Unix.close fd;
  if l > 0 then
    if Runner.compile_program class_name then Some class_name else None
  else None

module ProgramInterpreter (Cxt: Context) = struct
  let rec run_program (program: program) : command = Attack (* TODO Dummy Impl *)
end
