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
 * Requires: [m1] [m2] should not be the same military unit.
 * Returns: a constructed world map that contains some random mountains and two
 * military units [m1] [m2] on opposite corners.
*)
val init : MilUnit.t -> MilUnit.t -> t

(**
 * [get_mil_unit id m] tries to find the military unit with [id] in the map [m].
 *
 * Requires: None.
 * Returns: [v] where [v] has [id] and is in the map [m].
 * Raises: [Not_found] if there is no military unit in the map that has [id].
*)
val get_mil_unit_by_id : int -> t -> MilUnit.t

(**
 * [get_mil_unit_opt id m] tries to find the military unit with [id] in the
 * map [m].
 *
 * Requires: None.
 * Returns: [Some v] if [v] has [id] and is in the map [m]; [None] otherwise.
*)
val get_mil_unit_by_id_opt : int -> t -> MilUnit.t option

(**
 * [get_mil_unit_by_pos_opt pos m] tries to find the military unit with
 * position [pos] in the map [m].
 *
 * Requires: None.
 * Returns: [Some v] if [v] has position [pos]; [None] otherwise.
*)
val get_mil_unit_by_pos_opt : Position.t -> t -> MilUnit.t option

(**
 * [update_mil_unit id f m] updates a military unit with [id] on the map [m] by
 * the given function [f] and produces a new map with the updated state.
 *
 * Requires:
 * - [f] should preserves the identity of the military unit. It should not
 *   change the given military unit to refer to someone else.
 * - [id] can be anything. If it refers to an non-existing unit, nothing
 *   happens.
 * Returns: a new map with the updated state, or the old map if the [id] refers
 * to a non-existing military unit.
*)
val update_mil_unit : int -> (MilUnit.t -> MilUnit.t) -> t -> t

(**
 * [tile_map m] returns the tile map in the world map.
 *
 * Requires: None.
 * Returns: the tile map in the world map [m].
*)
val tile_map : t -> Tile.t PosMap.t
