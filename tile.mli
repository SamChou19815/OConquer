(**
 * [t] is the collection of all possible tiles in the game.
 * The associated int to [City] is the level of the city.
*)
type t = Empty | Mountain | Fort | City of int

(** [NotUpgradable] is an error indicating that a tile cannot be upgraded. *)
exception NotUpgradable

(**
 * [upgrade_tile t] upgrades a tile [t] to its new level.
 * [t] cannot be [Mountain].
 *
 * Requires: [t] is not [Mountain].
 * Returns: an upgraded tile.
 * Raises: [NotUpgradable] if [t = Mountain].
*)
val upgrade_tile : t -> t

(**
 * [to_string tile] returns the standard string representation of the [tile].
 * The representation is used as a contract in IO.
 *
 * Requires: None.
 * Returns: the standard string representation of the [tile].
*)
val to_string : t -> string
