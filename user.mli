(**
 * [User] module is responsible for dealing with the user registration, signing
 * in, and validation.
*)

(** [Base] contains some basic definitions of [User] module. *)
module Base : sig
  (** [user] is the abstract type of the user object. *)
  type user
end

(**
 * [Database] is the module that handles the in-memory database operation
 * related to users. The database will be indexed by the users.
*)
module Database : sig
  (** [t] is the abstract type for the user database object. *)
  type t
end
