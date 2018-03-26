open Definitions

type program = unit (* TODO Dummy Impl *)

module type Context = sig

  val get_mil_unit : int -> int -> string

end

let from_string (p_str: string) : program = ()

module ProgramInterpreter (Cxt: Context) = struct
  let rec run_program (program: program) : command = Attack (* TODO Dummy Impl *)
end
