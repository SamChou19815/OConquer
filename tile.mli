(** [Tile] defines some properties and computations on tile. *)

(**
 * [t] is the collection of all possible tiles in the game.
 * The associated int to [City] is the level of the city.
*)
type t =
  | Empty (** [Empty] represents an empty tile. *)
  | Mountain (** [Mountain] represents an impassable mountain tile. *)
  | Fort (** [Fort] represents a fort that increases defense. *)
  | City of int (** [City level] is a city of level [level]. *)

(** [BadTileInput] is an error indicating that a tile is a bad input. *)
exception BadTileInput

(**
 * [num_of_soldier_increase t] reports the number of soldier increase for the
 * tile if a military unit is on it.
 *
 * Requires: [t] is not [Mountain].
 * @return number of soldier increase for the tile if a military unit is on it.
 * @raise BadTileInput if [t = Mountain].
*)
val num_of_soldier_increase : t -> int

(**
 * [defender_bonus t] reports the defender bonus while defending on the given
 * tile [t]. The min value is 1.0.
 *
 * Requires: [t] is not [Mountain].
 * @return the bonus for the defender, which tells how much damage on the
 * defender can be reduced with given tile [t].
*)
val defender_bonus : t -> float

(**
 * [upgrade_tile t] upgrades a tile [t] to its new level.
 * [t] cannot be [Mountain].
 *
 * Requires: [t] is not [Mountain].
 * @return an upgraded tile.
 * @raise BadTileInput if [t = Mountain].
*)
val upgrade_tile : t -> t

(**
 * [to_string tile] outputs the standard string representation of the [tile].
 * The representation is used as a contract in IO.
 *
 * Requires: None.
 * @return the standard string representation of the [tile].
*)
val to_string : t -> string
