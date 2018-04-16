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
