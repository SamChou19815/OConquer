open Common

(**
 * [t] is the type of the world map, which is a collection of military unit map
 * and tile map.
 * The type is known to the client for easier information transmission and
 * processing.
*)
type t = {
  mil_unit_map: MilUnit.t PosMap.t;
  tile_map: Tile.t PosMap.t;
}

(**
 * [init (m1 m2)] initializes a world map from two given military units [m1]
 * and [m2].
 *
 * Requires: [m1] and [m2] are legal military units.
 * Returns: a constructed world map that contains some random mountains and two
 * military units [m1] [m2] on opposite corners.
*)
val init : MilUnit.t -> MilUnit.t -> t
