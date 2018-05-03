(** [RemoteServer] defines how a local server can be spawned. *)

module type Kernel = sig
  (** [state] encapsulates the current mutable state of the server. *)
  type state

  (**
   * [init] creates a brand new legal server state.
   * This function is used at the start of the server.
   *
   * Requires: None.
   * @return: a brand new legal server state.
  *)
  val init : unit -> state

  (**
   * [register username password] registers a user with given [username] and
   * [password]. If [username] is already used, registration will fail.
   *
   * Requires: [username] and [password] can be any string.
   * @return [Some t] where [t] is the token of the newly registered, or [None]
   * if the registration failed due to used username.
   * Effect: new user with [username] and [password] will be added to the
   * remote server system.
  *)
  val register : string -> string -> state -> int option

  (**
   * [sign_in username password] tried to sign in for a user.
   * If the pair [username] and [password] is not found, sign in will fail.
   *
   * Requires: [username] and [password] can be any string.
   * @return [Some t] where [t] is the token of the newly signed in, or [None]
   * if sign-in failed due to wrong [username] and [password]
  *)
  val sign_in : string -> string -> state -> int option

  (**
   * [submit_programs token b w s] submits a program of black [b] and white [w]
   * of the user with token [token] under a given state [s].
   * It can fail either because the user's programs do not compile or there is
   * no such user with token [token].
   *
   * Requires:
   * - [token] is the user's token.
   * - [b] [w] are the black and white programs given by the users.
   * - [s] is a legal state.
   * @return [true] if the program gets submitted or [false] if [b] [w] do not
   * compile or no such user with token [token].
  *)
  val submit_programs : int -> string -> string -> state -> bool

  (**
   * [query_match token round_id] gives the match change associated with the
   * user of a given token [token]. The changes given are since [round_id]
   * under a given state [s].
   *
   * Requires:
   * - [token] is the user's token.
   * - [round_id] must be between 0 and the id of the current round.
   * - [s] is a legal state.
   * Returns: [Some s] where [s] is a string representation of the world that
   * has changed since [round_id]; [None] if there is no running or executed
   * match with this given ID or no such user with token [token].
  *)
  val query_match : int -> int -> state -> string option

  (**
   * [scoreboard s] returns the score board of the current state [s].
   *
   * Requires: [s] is a legal server state.
   * Returns: a list of scores in string.
  *)
  val score_board : state -> string
end

module Make : functor (K: Kernel) -> sig
  (**
   * [start_remote_server ()] starts a remote server.
   * Requires: None.
   * @return: None.
   * Effect: A remote server is started at http://localhost:8088.
  *)
  val start_remote_server : unit -> unit
end
