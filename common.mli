(**
 * [Position] is an adapter for the [Map] module. It defines how tuple
 * positions should be ordered.
*)
module Position : (Map.OrderedType with type t = int * int)

(** [PosMap] is a map where the key is always a tuple position. *)
module PosMap : sig
  include Map.S with type key = Position.t

end
