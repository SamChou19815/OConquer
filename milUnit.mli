(**
 * [MilUnit] specifies properties and computations that are done on
 * military units.
*)

open Definitions

(**
 * [t] is the type of the military unit.
 * The exact representation should not be known to the client.
*)
type t

(**
 * [init identity id direction num_soliders morale leadership] creates a
 * new military unit with the given initial value of [identity] [id] [direction]
 * [num_soliders] [morale] [leadership].
 *
 * Requires:
 * - [id] must be unique in the system and non-negative.
 * - [direction] must be 0, 1, 2, 3.
 * - [num_soliders], [morale], [leadership] must be positive.
 * @return: a new legal military unit with the prescribed information specified
 * in arguments.
*)
val init : player_identity -> int -> int -> int -> int -> int -> t

(**
 * [default_init identity id direction program] creates a new military unit with
 * the prescribed [identity], [id], and [direction], but with default values
 * for its number of soldiers, morale, and leadership.
 *
 * Requires:
 * - [id] must be unique in the system and non-negative.
 * - [direction] must be 0, 1, 2, 3.
 * @return: a new legal military unit with the prescribed information specified
 * in arguments and default values for its number of soldiers, morale, and
 * leadership.
*)
val default_init : player_identity -> int -> int -> t

(**
 * [same_mil_unit m1 m2] reports whether two military unit refers to the same
 * military unit, but in different states.
 * The check should be performed after performing an in-place update operation
 * on a military unit.
 *
 * Requires: [m1] [m2] are legal military units.
 * @return: whether [m1] [m2] refers to the same military unit, just in
 * different states.
*)
val same_mil_unit : t -> t -> bool

(**
 * [identity mil_unit] reports the identity of the military unit.
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return: the identity of the military unit [mil_unit].
*)
val identity : t -> player_identity

(**
 * [id mil_unit] reports the id of the military unit.
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return: the id of the military unit [mil_unit].
*)
val id : t -> int

(**
 * [direction mil_unit] reports the direction of the military unit.
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return: the direction of the military unit [mil_unit].
*)
val direction : t -> int

(**
 * [num_soliders mil_unit] reports the number of soldiers for the given
 * military unit [mil_unit].
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return: the number of soldiers for the given military unit [mil_unit].
*)
val num_soliders : t -> int

(**
 * [morale mil_unit] reports the morale for the given military unit [mil_unit].
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return: the morale for the given military unit [mil_unit].
*)
val morale : t -> int

(**
 * [leadership mil_unit] reports the leadership for the given military unit
 * [mil_unit].
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return: the leadership for the given military unit [mil_unit].
*)
val leadership : t -> int

(**
 * [increase_soldier_by n m] increases the number of the given military unit by
 * [n].
 *
 * Requires:
 * - [n] is non-negative.
 * - [m] is a legal military unit.
 * @return: the result of increasing soliders for that military unit.
*)
val increase_soldier_by : int -> t -> t

(**
 * [turn_left m] lets the military unit [m] turn left.
 *
 * Requires: [m] is a legal military unit.
 * @return: the result of turning left for that military unit.
*)
val turn_left : t -> t

(**
 * [turn_right m] lets the military unit [m] turn right.
 *
 * Requires: [m] is a legal military unit.
 * @return: the result of turning right for that military unit.
*)
val turn_right : t -> t

(**
 * [train m] increases the fighting ability of a military unit after training.
 *
 * Requires: [m] is a legal military unit.
 * @return: the result of training the military unit.
*)
val train : t -> t

(**
 * [apply_retreat_penalty n] decreases the fighting ability of a military unit
 * after retreating.
 *
 * Requires: [m] is a legal military unit.
 * @return: the result of retreating for the military unit.
*)
val apply_retreat_penalty : t -> t

(**
 * [attack (t1, t2) (m1, m2)] lets [m1] attacks [m2] under their tile [t1] and
 * [t2]. It outputs the result of attack as a tuple. Each component in the tuple
 * correspondes to the resultant state after attack for [m1] and [m2].
 * If the component is [None], it means that the military unit has been
 * eliminated as a result of attack.
 *
 * Requires: [m1] and [m2] are legal military units.
 * @return: the result of attack stored in a tuple.
*)
val attack : (Tile.t * Tile.t) -> (t * t) -> (t option * t option)

(**
 * [divide next_id mil_unit] divides a military unit into two units, each with
 * half of number of original soldiers (+- 1), equal morale and equal leadership.
 * If the military unit has only 1 solider, division will fail and return
 * [None].
 *
 * Requires:
 * - [next_id] is the next id for the potentially new military unit.
 * - [mil_unit] is a legal military unit.
 * @return: [Some (m1, m2)] where [m1] [m2] are the divided units, [m1] with
 * [id] of [mil_unit.id] and [m2] with [id] of [next_id]. if the
 * division is successful and [None] if the division fails due to insufficient
 * number of soldiers.
*)
val divide : int -> t -> (t * t) option

(**
 * [to_string mil_unit] outputs the standard string representation of the
 * military unit [mil_unit]. The representation is used as a contract in IO.
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return: the standard string representation of the military unit [mil_unit].
*)
val to_string : t -> string
