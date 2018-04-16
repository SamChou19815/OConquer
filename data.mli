(**
 * [Data] module defines the data structures that are responsible for
 * interoperation between the front-end and backend. It specifies how diffrent
 * part of the system is connected to each other.
*)

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
