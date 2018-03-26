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
 * [init p1 p2] initializes a world map from two given parsed program [p1] [p2].
 *
 * Requires: [p1] and [p2] are legal programs.
 * Returns: a constructed world map that contains some random mountains and two
 * military units with program [p1] [p2] on opposite corners.
*)
val init : Command.program -> Command.program -> t
