open Definitions

type program

(** [Context] is used to give relevant information to program interpreter. *)
module type Context = sig

  val get_mil_unit : int -> int -> string

end

(** [from_string] parses a string into a program AST. *)
val from_string : string -> program

module ProgramInterpreter (Cxt: Context) : sig
  val run_program : program -> command
end
