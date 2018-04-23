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
 * A new diff record representing the randomized map is also returned.
 *
 * Requires: [p1] [p2] must be legal programs.
 * @return: [s, d] where [s] is the returned state is the initial state of the
 * game and [d] is the initial diff logs.
*)
val init : Command.program -> Command.program -> state * Data.diff_record

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
 * @return: [s', diff_record] where [s'] is a new legal state created from the
 * given state [s] where the game has been advanced for one more round by
 * executing programs of each military unit, and [diff_record] represents all
 * changed map content in that round.
*)
val next : state -> state * Data.diff_record
