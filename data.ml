open Common
open Definitions

type map_content = {
  position: Position.t;
  tile: Tile.t;
  mil_unit: MilUnit.t option;
}

(**
 * [DiffSet] is the set that is responsible for managing a set of map content
 * change in one round.
*)
module DiffSet = Set.Make (struct
    type t = map_content
    let compare = Pervasives.compare
  end)

type diff_record = DiffSet.t

type diff_logs = diff_record list
