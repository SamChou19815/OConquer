(**
 * [t] is the collection of all possible tiles in the game.
 * The associated int to [City] is the level of the city.
*)
type t = Empty | Mountain | Fort | City of int
