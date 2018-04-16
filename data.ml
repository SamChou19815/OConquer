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

(* Stored in the reserve order. *)
type diff_logs = diff_record list

let create_map_content ?(mil_unit: MilUnit.t option = None)
    ~(pos: Position.t) ~(tile: Tile.t) : map_content =
  { position = pos; tile; mil_unit; }

let create_diff_record (f: 'a -> map_content) (lst: 'a list) : diff_record =
  lst |> List.map f |> DiffSet.of_list

let empty_diff_logs : diff_logs = []

let append_new_diff_record (r: diff_record) (l: diff_logs) : diff_logs = r::l
