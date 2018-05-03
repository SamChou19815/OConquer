(**
 * [User] module is responsible for dealing with the user registration, signing
 * in, and validation.
*)

(** [user] is the abstract type of the user object. *)
type user

(**
 * [username user] reports the username of the user [user].
 *
 * Requires: [user] is a legal user.
 * @return the username of the user [user].
*)
val username : user -> string

(**
 * [password user] reports the password of the user [user].
 *
 * Requires: [user] is a legal user.
 * @return the password of the user [user].
*)
val password : user -> string

(**
 * [token user] reports the token of the user [user].
 *
 * Requires: [user] is a legal user.
 * @return the token of the user [user].
*)
val token : user -> int

(**
 * [Database] is the module that handles the in-memory database operation
 * related to users. The database will be indexed by the users.
*)
module Database : sig
  (** [t] is the abstract type for the user database object. *)
  type t

  (** [empty] is the empty user database. *)
  val empty : t

  (**
   * [register username password db] tries to register for a new user with given
   * [username] and [password] in the given database [db].
   *
   * Requires:
   * - [username] and [password] can be any string.
   * - [db] must be a legal database.
   * @return [None] if registration failed due to duplicate username;
   * [Some (db, token)] when it succeeds and gives back new database [db] and
   * token [token] for the new user.
  *)
  val register : string -> string -> t -> (t * int) option

  (**
   * [sign_in username password db] tries to sign in for the user and give
   * the signed in user's token.
   *
   * Requires:
   * - [username] and [password] can be any string.
   * - [db] must be a legal database.
   * @return [None] if signing in failed due to wrong username and password;
   * [Some token] when it succeeds and gives back the token [token] for the
   * signed-in user.
  *)
  val sign_in : string -> string -> t -> int option

  (**
   * [has_token token db] checks whether the given [token] is in [db].
   *
   * Requires:
   * - [t] can be any int.
   * - [db] must be a legal database.
   * @return whether the given [token] is in [db].
  *)
  val has_token : int -> t -> bool
end
