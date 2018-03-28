(**
 * [scoreboard ()] returns the score board of the current time.
 *
 * Requires: None.
 * Returns: a list of scores.
*)
val scoreboard: unit -> string list

(**
 * [accept_program program] accepts a program from user to be used for later
 * matching.
 *
 * Requires: the given [program] must be legal.
 * Returns: None.
 * Effect: a new program has been added to the matching list internally.
*)
val accept_program : Command.program -> unit

(**
 * [match_and_start ()] tries to start a match between two programs. If a
 * matching is impossible it will give [None]; otherwise, it will give a
 * Some matching id.
 *
 * Requires: None.
 * Returns: [Some id] where [id] is the matching id. [None] if matching is
 * impossible.
 * Effect: If matching is possible, a simulation will start.
*)
val match_and_start : unit -> int option

(**
 * [query_match matching_id round_id] gives the world map of a given matching
 * specified by a given [matching_id] and a world that changed since [round_id].
 *
 * Requires:
 * - [matching_id] must exists in the system.
 * - [round_id] must be between 0 and the id of the current round.
 * Returns: a world that changed since [round_id].
*)
val query_match : int -> int -> WorldMap.t
