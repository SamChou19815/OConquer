open Definitions

type program

(** [Context] is used to give relevant information to program interpreter. *)
module type Context = sig
  open Common

  (**
   * [get_mil_unit pos] returns the military unit at the given position [pos].
   * The military unit may or may not exist.
   *
   * Requires: [pos] is a legal representation of position.
   * Returns: [Some m] where [m] is a military unit if [m] is at [pos]; [None]
   * if [pos] has no military units.
  *)
  val get_mil_unit : Position.t -> MilUnit.t option

  (**
   * [get_tile pos] returns the tile at the given position [pos].
   * The tile may or may not exist.
   *
   * Requires: [pos] is a legal representation of position.
   * Returns: [Some t] where [t] is a tile if there exists a tile at pos; [None]
   * if there is no tile at [pos].
  *)
  val get_tile : Position.t -> Tile.t option

  (**
   * [get_position mil_unit] returns the position of the given military unit
   * [mil_unit].
   * The position may not exist when there is no such military unit [mil_unit].
   *
   * Requires: [mil_unit] is a legal military unit.
   * Returns: [Some pos] where [pos] is the position of the military unit;
   * [None] if there is no such military unit [mil_unit].
  *)
  val get_position : MilUnit.t -> Position.t option

  (**
   * [get_map] reports the current world map of the game.
   *
   * Requires: None
   * Returns: the current world map of the game state [s].
  *)
  val get_map : WorldMap.t

end

(**
 * [from_string i program_str] parses a string [program_str] into a program.
 * If the [program_str] is not a legal program, [None] will be returned;
 * otherwise, [Some p] is returned, where [p] represents a legal program.
 *
 * Requires:
 * - [i] is the player identity.
 * - [string] can be any string.
 * Returns: [Some p] where  where [p] represents a legal program.
 * [None] if the program is illegal.
*)
val from_string : player_identity -> string -> program option

(**
 * [ProgramInterpreter] is responsible for interpret the program with the
 * given [Context].
*)
module ProgramInterpreter (Cxt: Context) : sig
  (**
   * [run_program program] should run the program to produce a command.
   *
   * Requires: [program] is a legal program.
   * Returns: the command chosen by the program.
  *)
  val run_program : program -> command
end
