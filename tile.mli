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
 * Rules of Soldier Increase:
 * 1. On [Empty] and [Fort] tiles the number of soldier increase is always 0.
 * 2. On [City i] tiles, the number of soldier increase is the product of city
 * level [i] and a constant [GameConstants.increase_soldier_factor].
 * 3. On [Mountain] tiles no soldiers can be on the tile, so the function is
 * undefined.
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
 * Rules of Defender Bonus:
 * 1. On [Empty] tiles the defender_bonus is the min value 1.0.
 * 2. On [Fort] and [City i] tiles the defender_bonus is the constant
 * [GameConstants.fort_city_bonus_factor].
 * 3. On [Mountain] tiles no soldiers can be on the tile, so the function is
 * undefined.
 *
 * Requires: [t] is not [Mountain].
 * @return the bonus for the defender, which tells how much damage on the
 * defender can be reduced with given tile [t].
 * @raise BadTileInput if [t = Mountain].
*)
val defender_bonus : t -> float

(**
 * [upgrade_tile t] upgrades a tile [t] to its new level.
 * [t] cannot be [Mountain].
 *
 * Rules of Upgrade Tile:
 * 1. The upgrade of [Empty] tile is a [Fort] tile.
 * 2. The upgrade of [Fort] tile is a [City 1] tile.
 * 3. The upgrade of [City i] tile is a [City (i+1)] tile for integer [i >= 1].
 * 4. [Mountain] tiles can't be upgraded, so the function is undefined.
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

(**
 * [type_string tile] outputs the standard string representation of the [tile].
 * The representation is used for json output.
 *
 * Requires: None.
 * @return the standard string representation of the [tile].
*)
val type_string : t -> string
