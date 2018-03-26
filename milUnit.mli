(**
 * [t] is the type of the military unit.
 * The exact representation should not be known to the client.
*)
type t

(**
 * [init id direction num_soliders morale leadership program] creates a
 * new military unit with the given initial value of [id] [direction]
 * [num_soliders] [morale] [leadership].
 *
 * Requires:
 * - [id] must be unique in the system and non-negative.
 * - [direction] must be 0, 1, 2, 3.
 * - [num_soliders], [morale], [leadership] must be positive.
 * Returns: a new legal military unit with the prescribed information specified
 * in arguments.
*)
val init : int -> int -> int -> int -> int -> t

(**
 * [default_init id direction program] creates a new military unit with the
 * prescribed [id] and [direction], but with default values for its
 * number of soldiers, morale, and leadership.
 *
 * Requires:
 * - [id] must be unique in the system and non-negative.
 * - [direction] must be 0, 1, 2, 3.
 * Returns: a new legal military unit with the prescribed information specified
 * in arguments and default values for its number of soldiers, morale, and
 * leadership.
*)
val default_init : int -> int -> t

(**
 * [num_soliders mil_unit] reports the number of soldiers for the given
 * military unit [mil_unit].
 *
 * Requires: [mil_unit] is a legal military unit.
 * Returns: the number of soldiers for the given military unit [mil_unit].
*)
val num_soliders : t -> int

(**
 * [morale mil_unit] reports the morale for the given military unit [mil_unit].
 *
 * Requires: [mil_unit] is a legal military unit.
 * Returns: the morale for the given military unit [mil_unit].
*)
val morale : t -> int

(**
 * [leadership mil_unit] reports the leadership for the given military unit
 * [mil_unit].
 *
 * Requires: [mil_unit] is a legal military unit.
 * Returns: the leadership for the given military unit [mil_unit].
*)
val leadership : t -> int

(**
 * [attack (m1, m2)] lets [m1] attacks [m2] and returns the result of the
 * attack as a tuple. Each component in the tuple correspondes to the resultant
 * state after attack for [m1] and [m2]. If the component is [None], it means
 * that the military unit has been eliminated as a result of attack.
 *
 * Requires: [m1] and [m2] are legal military units.
 * Returns: the result of attack stored in a tuple.
*)
val attack : (t * t) -> (t option * t option)

(**
 * [divide mil_unit] divides a military unit into two units, each with half of
 * number of original soldiers (+- 1), equal morale and equal leadership.
 * If the military unit has only 1 solider, division will fail and return
 * [None].
 *
 * Requires: [mil_unit] is a legal military unit.
 * Returns: [Some (m1, m2)] where [m1] [m2] are the divided units if the
 * division is successful and [None] if the division fails due to insufficient
 * number of soldiers.
*)
val divide : t -> (t * t) option
