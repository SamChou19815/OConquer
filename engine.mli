(**
 * [Engine] specifies how the game runs in a high level abstraction, without
 * exposing any low level details to the clients.
*)

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
 * @return: the returned state is the initial state of the game. If [p1] [p2]
 * are legal, the returned state is also legal. *)
val init : Command.program -> Command.program -> state

(**
 * [get_game_status s] reports the winning status of the game.
 *
 * Requires: [s] is a legal state.
 * @return: the winning status of the given game state [s].
*)
val get_game_status : state -> game_status

(**
 * [get_map s] reports the current world map of the game.
 *
 * Requires: [s] is a legal state.
 * @return: the current world map of the game state [s].
*)
val get_map : state -> WorldMap.t

(**
 * [next s] produces a new state from the old given state [s]. This function is
 * used to advance the game into a new round. It is not responsible for checking
 * whether the game has ended. For any legal state, it is guaranteed to produce
 * a new legal state regardless whether the game has ended.
 *
 * Requires: [s] must be a legal state.
 * @return: a new legal state created from the given state [s] where the game
 * has been advanced for one more round by executing programs of each military
 * unit.
*)
val next : state -> state
