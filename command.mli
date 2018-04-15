(**
 * [Command] specifies how the main [Engine] and a program interacts with each
 * other.
*)

open Definitions

type program

(** [Context] is used to give relevant information to program interpreter. *)
module type Context = sig
  open Common

  (**
   * [get_my_pos] outputs the position of the owner of the program.
   *
   * Requires: None.
   * @return: the position of the owner of the program.
  *)
  val get_my_pos : Position.t

  (**
   * [get_mil_unit pos] outputs the military unit at the given position [pos].
   * The military unit may or may not exist.
   *
   * Requires: [pos] is a legal representation of position.
   * @return: [Some m] where [m] is a military unit if [m] is at [pos]; [None]
   * if [pos] has no military units.
  *)
  val get_mil_unit : Position.t -> MilUnit.t option

  (**
   * [get_tile pos s] outputs the tile at the given position [pos].
   * If the tile is out of bound, mountain will be returned.
   *
   * Requires:
   * - [pos] is a legal representation of position.
   * @return: the tile at the given position [pos].
  *)
  val get_tile : Position.t -> Tile.t
end

(**
 * [from_string i program_str] parses a string [program_str] into a program.
 * If the [program_str] is not a legal program, [None] will be returned;
 * otherwise, [Some p] is returned, where [p] represents a legal program.
 *
 * Requires:
 * - [i] is the player identity.
 * - [string] can be any string.
 * @return: [Some p] where  where [p] represents a legal program.
 * [None] if the program is illegal.
*)
val from_string : player_identity -> string -> program option

(** [Runner] is the module type for a runner of program. *)
module type Runner = sig
  (**
   * [run_program program] should run the program to produce a command.
   *
   * Requires: [program] is a legal program.
   * @return: the command chosen by the program.
  *)
  val run_program : program -> command
end

(**
 * [ProgramRunner] is responsible for interpret the program with the
 * given [Context].
*)
module ProgramRunner (Cxt: Context) : Runner
