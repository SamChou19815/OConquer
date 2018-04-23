(**
 * [Data] module defines the data structures that are responsible for
 * interoperation between the front-end and backend. It specifies how diffrent
 * part of the system is connected to each other.
*)

open Common

(**
 * [map_content] is the abstract type for all the information that belongs to
 * a position in the world map. It contains tile information and optionally
 * information about a military unit.
*)
type map_content

(**
 * [diff_record] is the abstract type for the difference record that describes
 * changed in one round of simulation of the game.
*)
type diff_record

(**
 * [diff_logs] is the abstract type for the collection of all the existing
 * difference records.
*)
type diff_logs

(**
 * [create_map_content mil_unit pos tile] creates a map content with
 * an optional military unit [mil_unit], position [pos], and tile [tile].
 *
 * Requires:
 * - [mil_unit] must be a legal military unit that is at [pos]. If it's not
 *   supplied, it defaults to [None].
 * - [pos] must be a legal, in-bound position.
 * - [tile] can be any tile, but it must corresponds to the [pos].
 * @return a [map_content] object that contains all the aforementioned info.
*)
val create_map_content : ?mil_unit:MilUnit.t option
  -> pos:Position.t -> tile:Tile.t -> map_content

(**
 * [create_diff_record f lst] creates a [diff_record] from a list of items [lst]
 * and a function [f] that maps each item to a [map_content].
 *
 * Requires: [lst] should contain a list of map content that has changed. It
 * should not contain duplicate elements.
 * @return a diff record of the list that represents all the changes in one
 * round.
*)
val create_diff_record : map_content list -> diff_record

(**
 * [empty_diff_logs i] creates an empty diff logs.
 *
 * Requires: None.
 * @return an empty diff logs.
*)
val empty_diff_logs : diff_logs

(** [append_new_diff_record r l] appends [r] to the end of [l].
 *
 * Requires:
 * - [r] is a legal [diff_record].
 * - [l] is a legal [diff_logs].
 * @return the updated diff logs with the new [r] appended to the end.
*)
val append_new_diff_record : diff_record -> diff_logs -> diff_logs

(**
 * [diff_logs_to_json l] converts a diff log into json format.
 *
 * Requires: [l] is a legal [diff_logs].
 * @return the json format of the given [l].
*)
val diff_logs_to_json : diff_logs -> Yojson.Basic.json
