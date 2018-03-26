(**
 * [Position] is an adapter for the [Map] module. It defines how tuple
 * positions should be ordered.
*)
module Position : (Map.OrderedType with type t = int * int) = struct
  type t = int * int

  let compare ((p1x, p1y): t) ((p2x, p2y): t) : int =
    let c = compare p1x p2x in
    if c = 0 then compare p1y p2y else c
end

(** [PosMap] is a map where the key is always a tuple position. *)
module PosMap = struct
  include Map.Make (Position)

  (* prepare for future extension *)
end
