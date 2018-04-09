open Definitions
open Common

(**
 * [state] is the type of the game state.
 * The exact representation should not be known to the client.
*)
type state

(**
 * [init p1 p2] creates a new game state with two given parsed programs [p1]
 * [p2]. The created new state represents the initial legal state of the game.
 *
 * Requires: [p1] [p2] must be legal programs.
 * Returns: the returned state is the initial state of the game. If [p1] [p2]
 * are legal, the returned state is also legal. *)
val init : Command.program -> Command.program -> state

(**
 * [next s] produces a new state from the old given state [s]. This function is
 * used to advance the game into a new round. It is not responsible for checking
 * whether the game has ended. For any legal state, it is guaranteed to produce
 * a new legal state regardless whether the game has ended.
 *
 * Requires: [s] must be a legal state.
 * Returns: a new legal state created from the given state [s] where the game
 * has been advanced for one more round by executing programs of each military
 * unit.
*)
val next : state -> state

(**
 * [get_mil_unit pos s] returns the military unit at the given position [pos]
 * for a given game state [s]. The military unit may or may not exist.
 *
 * Requires:
 * - [pos] is a legal representation of position.
 * - [s] is a legal state.
 * Returns: [Some m] where [m] is a military unit if [m] is at [pos]; [None] if
 * [pos] has no military units.
*)
val get_mil_unit : Position.t -> state -> MilUnit.t option

(**
 * [get_tile pos s] returns the tile at the given position [pos] for a given
 * game state [s]. If the tile is out of bound, mountain will be returned.
 *
 * Requires:
 * - [pos] is a legal representation of position.
 * - [s] is a legal state.
 * Returns: the tile at the given position [pos] for a given game state [s].
*)
val get_tile : Position.t -> state -> Tile.t

(**
 * [get_position mil_unit s] returns the position of the given military unit
 * [mil_unit] for a given game state [s]. The position may not exist when there
 * is no such military unit [mil_unit].
 *
 * Requires:
 * - [mil_unit] is a legal military unit.
 * - [s] is a legal state.
 * Returns: [Some pos] where [pos] is the position of the military unit; [None]
 * if there is no such military unit [mil_unit].
*)
val get_position : MilUnit.t -> state -> Position.t option

(**
 * [get_game_status s] reports the winning status of the game.
 *
 * Requires: [s] is a legal state.
 * Returns: the winning status of the given game state [s].
*)
val get_game_status : state -> game_status

(**
 * [get_map s] reports the current world map of the game.
 *
 * Requires: [s] is a legal state.
 * Returns: the current world map of the game state [s].
*)
val get_map : state -> WorldMap.t

(**
 * [get_context s id] creates a specialized Context module that reports various
 * aspects of the map for a given state [s] and military program [id], which are
 * both infused into the context.
 *
 * Requires: [s] is a legal state.
 * Returns: a context with the given state [s] infused in it.
*)
val get_context : state -> int -> (module Command.Context)
