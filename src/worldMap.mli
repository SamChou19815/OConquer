(** [WorldMap] encapsulates many operations on the world map. *)

open Common
open Data

(**
 * [t] is the type of the world map, which is a collection of military unit map
 * and tile map.
*)
type t

(**
 * [IllegalWorldMapOperation error_msg] is an exception indicating that the
 * developer is incorrectly using this module. The error message is in
 * [error_msg].
*)
exception IllegalWorldMapOperation of string

(**
 * [init (m1 m2)] initializes a world map from two given military units [m1]
 * and [m2].
 *
 * Requires: [m1] [m2] should not be the same military unit.
 * @return: a constructed legal world map that contains some random mountains
 * and two military units [m1] [m2] on opposite corners.
*)
val init : MilUnit.t -> MilUnit.t -> t

(**
 * [number_of_units m] computes the number of military units for black and white
 * side.
 *
 * Requires: [m] is a legal world map.
 * @return [black_num, white_num] where they are number of military units for
 * black and white respectively.
*)
val number_of_units : t -> int * int

(**
 * [get_position_by_id id m] tries to find the position of the military
 * unit with id [id].
 *
 * Requires: [m] is a legal world map.
 * @return: [v] where [v] is the position of the military unit;
 * @raise Not_found if there is no such military unit with id [id].
*)
val get_position_by_id : int -> t -> Position.t

(**
 * [get_position_opt_by_id id m] tries to find the position of the military
 * unit with id [id].
 *
 * Requires: [m] is a legal world map.
 * @return: [Some v] where [v] is the position of the military unit; [None] if
 * there is no such military unit with id [id].
*)
val get_position_opt_by_id : int -> t -> Position.t option

(**
 * [get_mil_unit id m] tries to find the military unit with [id] in the map [m].
 *
 * Requires: [m] is a legal world map.
 * @return: [v] where [v] has [id] and is in the map [m].
 * @raise Not_found if there is no military unit in the map that has [id].
*)
val get_mil_unit_by_id : int -> t -> MilUnit.t

(**
 * [get_mil_unit_opt id m] tries to find the military unit with [id] in the
 * map [m].
 *
 * Requires: [m] is a legal world map.
 * @return: [Some v] if [v] has [id] and is in the map [m]; [None] otherwise.
*)
val get_mil_unit_opt_by_id : int -> t -> MilUnit.t option

(**
 * [get_mil_unit_by_pos_opt pos m] tries to find the military unit with
 * position [pos] in the map [m].
 *
 * Requires: [m] is a legal world map.
 * @return: [Some v] if [v] has position [pos]; [None] otherwise.
*)
val get_mil_unit_opt_by_pos : Position.t -> t -> MilUnit.t option

(**
 * [get_tile_by_pos pos m] outputs the tile at the given position [pos] for a
 * given world map [m]. If the tile is out of bound, mountain will be returned.
 *
 * Requires:
 * - [pos] is a legal representation of position.
 * - [m] is a legal world map.
 * @return: the tile at the given position [pos] for a given world map [m].
*)
val get_tile_by_pos : Position.t -> t -> Tile.t

(**
 * [get_tile_by_mil_id id m] tries to find the tile where the military unit
 * with id [id] stays.
 *
 * Requires:
 * - [id] must be an existing military unit id.
 * - [m] is a legal world map.
 * @return: [v], if it is occupied by the military unit with id [id] in the
 * map [m].
 * @raise Not_found if there is no military unit in the map that has [id].
*)
val get_tile_by_mil_id : int -> t -> Tile.t

(**
 * [get_tile_opt_by_mil_id id m] tries to find the tile where the military unit
 * with id [id] stays.
 *
 * Requires:
 * - [id] can be anything.
 * - [m] is a legal world map.
 * @return: [Some v] if [v] is occupied by the military unit with id [id] in the
 * map [m]; [None] otherwise.
*)
val get_tile_opt_by_mil_id : int -> t -> Tile.t option

(**
 * [randomize_map m] randomizes the map by randomly adding some mountains.
 *
 * Requires: [m] is a legal world map.
 * @return: [(map, diff_record)], where [map] is a new world map with randomly
 * created mountain and [diff_record] is a set of changed map content.
 * We ensure that the newly created mountain will not collide with existing
 * units.
*)
val randomize_map : t -> t * diff_record

(**
 * [update_mil_unit id f m] updates a military unit with [id] on the map [m] by
 * the given function [f] and produces a new map with the updated state.
 *
 * Requires:
 * - [f] should preserves the identity of the military unit. It should not
 *   change the given military unit to refer to someone else.
 * - [id] can be anything. If it refers to an non-existing unit, nothing
 *   happens.
 * @return: a new map with the updated state, or the old map if the [id] refers
 * to a non-existing military unit. The new map is legal.
*)
val update_mil_unit : int -> (MilUnit.t -> MilUnit.t) -> t -> t

(**
 * [upgrade_tile pos m] upgrades a tile at position [pos] in map [m].
 * There must be a tile there that is not a mountain.
 *
 * Requires: [pos] in map [m] should contains a tile that is not mountain.
 * @return: a new map with the upgraded tile. The new map is legal.
 * @raise BadTileInput if the tile cannot be upgraded due to violation of
 * requirement stated above.
*)
val upgrade_tile : Position.t -> t -> t

(**
 * [move_mil_unit_forward id m] moves a military unit with [id] forward by 1.
 * If the tile in front is not passable, it will do nothing.
 *
 * Requires:
 * - [id] can be anything. However, if it refers to a non-existing military unit
 *   [m] will be directly returned.
 * - [m] is a legal world map.
 * @return: a new world map with the military unit with [id] moved forward by 1.
 * Or the old map if this operation is impossible.
*)
val move_mil_unit_forward : int -> t -> t

(**
 * [attack id m] lets a military unit with [id] do ATTACK!
 * If the operation is not possible, it will do nothing.
 *
 * Requires:
 * - [id] can be anything. However, if it refers to a non-existing military unit
 *   [m] will be directly returned.
 * - [m] is a legal world map.
 * @return: a new world map with the military unit with [id] performed an
 * attack operation. Or the old map if this operation is impossible.
*)
val attack : int -> t -> t

(**
 * [divide id m] lets a military unit with [id] do DIVIDE!
 * If the operation is not possible, it will do nothing.
 *
 * Requires:
 * - [id] can be anything. However, if it refers to a non-existing military unit
 *   [m] will be directly returned.
 * - [m] is a legal world map.
 * @return: a new world map with the military unit with [id] performed an
 * divide operation. Or the old map if this operation is impossible.
*)
val divide : int -> t -> t

(**
 * [next process_mil_unit m] steps through the entire round for the world map
 * to produce a new world map and a diff record.
 * [process_mil_unit] does some operation on the military unit to change some
 * state in the world map [m] for processing each military unit.
 * This function is reserved for the [Engine] module only.
 *
 * Requires:
 * - [process_next_id] takes a military unit id and the world map to produce a
 *   new world map.
 * - [m] is a legal world map.
 * @return: a new world map that stepped a whole round from the old given world
 * map [m] and a diff record that contains everything changed in this round.
*)
val next : (int -> t -> t) -> t -> t * diff_record
