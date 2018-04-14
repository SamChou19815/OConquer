(**
 * [start_simulation p1 p2] starts a local simulation with two programs.
 *
 * Requires:
 * - [p1] [p2] are legal programs.
 * - There is no running simulation on the local server.
 * Returns: None.
 * Effect: The server starts to run a new local simulation.
*)
val start_simulation : Command.program -> Command.program -> unit

(**
 * [query round_id] returns the world map that has changed since the given
 * round id [round_id].
 *
 * Requires: [round_id] is between 0 and the current round id on the server.
 * Returns: the world map that has changed since the given round id [round_id].
*)
val query: int -> WorldMap.t

(**
 * [delegate cmd] delegates the given [cmd] to the remote server.
 *
 * Requires: [cmd] is a legal command to delegate.
 * (Legal command is not defined yet.)
 * Returns: None.
 * Effect: the [cmd] has been sent to the remote server.
*)
val delegate : string -> unit

(**
 * [start_local_server ()] starts a local server.
 * Requires: None.
 * Returns: None.
 * Effect: A local server is started at http://localhost:8080.
*)
val start_local_server : unit -> unit
