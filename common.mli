(** [Common] defines some common data structures that are frequently used. *)

(**
 * [Position] is an adapter for the [Map] module. It defines how tuple
 * positions should be ordered.
*)
module Position : sig
  include Map.OrderedType with type t = int * int

  (**
   * [to_string p] returns the standard string representation of the
   * position [p].
   * The representation is used as a contract in IO.
   *
   * Requires: [p] is a legal position.
   * Returns: the standard string representation of the position [p].
  *)
  val to_string : t -> string
end

(** [PosMap] is a map where the key is always a tuple position. *)
module PosMap : sig
  include Map.S with type key = Position.t

end

(** [IntMap] is a map where the key is always an int. *)
module IntMap : sig
  include Map.S with type key = int
end
