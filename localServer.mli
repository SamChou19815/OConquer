(** [LocalServer] defines how a local server can be spawned. *)

(**
 * [Kernel] contains all the supporting functions for a local server to run.
*)
module type Kernel = sig
  (** [state] encapsulates the current mutable state of the server. *)
  type state

  (**
   * [init] creates a brand new legal server state.
   * This function is used at the start of the server.
   *
   * Requires: None.
   * Returns: a brand new legal server state.
  *)
  val init : unit -> state

  (**
   * [start_simulation p1 p2 s] starts a local simulation with two programs in
   * a given server state [s].
   *
   * Requires:
   * - [p1] [p2] are programs that may not compile.
   * - [s] is a legal server state.
   * Returns: the response of the server, defined by all the return values.
   * Effect: The server starts to run a new local simulation if the response
   * is [OK].
  *)
  val start_simulation : string -> string -> state ->
    [`OK | `DoesNotCompile | `AlreadyRunning]

  (**
   * [query round_id s] returns all changes that has occured since the given
   * round id [round_id] in a given server state [s].
   *
   * Requires:
   * - [round_id] is between 0 and the current round id on the server.
   * - [s] is a legal server state.
   * Returns: TODO the data structure for changed is SUBJECT TO CHANGE!
  *)
  val query : int -> state -> unit
end

module Make : functor (K: Kernel) -> sig
  (**
   * [start_local_server ()] starts a local server.
   * Requires: None.
   * Returns: None.
   * Effect: A local server is started at http://localhost:8080.
  *)
  val start_local_server : unit -> unit
end
