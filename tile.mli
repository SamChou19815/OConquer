(**
 * [t] is the collection of all possible tiles in the game.
 * The associated int to [City] is the level of the city.
*)
type t = Empty | Mountain | Fort | City of int

(**
 * [to_string tile] returns the standard string representation of the [tile].
 * The representation is used as a contract in IO.
 *
 * Requires: None.
 * Returns: the standard string representation of the [tile].
*)
val to_string : t -> string
