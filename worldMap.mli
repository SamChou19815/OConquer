open Common

(**
 * [t] is the type of the world map, which is a collection of military unit map
 * and tile map.
*)
type t

(**
 * [init (m1 m2)] initializes a world map from two given military units [m1]
 * and [m2].
 *
 * Requires: [m1] and [m2] are legal military units.
 * Returns: a constructed world map that contains some random mountains and two
 * military units [m1] [m2] on opposite corners.
*)
val init : MilUnit.t -> MilUnit.t -> t

(**
 * [mil_unit_map m] returns the military unit map in the world map.
 *
 * Requires: [m] is a legal world map.
 * Returns: the military unit map in the world map [m].
*)
val mil_unit_map : t -> MilUnit.t PosMap.t

(**
 * [tile_map m] returns the tile map in the world map.
 *
 * Requires: [m] is a legal world map.
 * Returns: the tile map in the world map [m].
*)
val tile_map : t -> Tile.t PosMap.t

(**
 * [to_string m] returns the standard string representation of the map [m].
 * The representation is used as a contract in IO.
 *
 * Requires: [m] is a legal world map.
 * Returns: the standard string representation of the map [m].
*)
val to_string : t -> string
