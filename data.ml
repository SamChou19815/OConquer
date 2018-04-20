open Common
open Definitions
(* open Yojson.Basic *)
open Yojson.Safe
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
type diff_logs = {
  last_id: int;
  logs: diff_record list;
}

let create_map_content ?(mil_unit: MilUnit.t option = None)
    ~(pos: Position.t) ~(tile: Tile.t) : map_content =
  { position = pos; tile; mil_unit; }

let create_diff_record (f: 'a -> map_content) (lst: 'a list) : diff_record =
  lst |> List.map f |> DiffSet.of_list

let empty_diff_logs (i: int) : diff_logs =
  if i < 0 then failwith ("Illegal value of index i: " ^ string_of_int i ^ ".")
  else { last_id = i; logs = [] }

let append_new_diff_record (r: diff_record) (l: diff_logs) : diff_logs =
  { last_id = l.last_id + 1; logs = r::l.logs }

let mil_unit_to_json (mil_unit: MilUnit.t) : json =
  let identity  = mil_unit |> MilUnit.identity |> MilUnit.string_of_identity in
  let id = mil_unit |> MilUnit.id in
  let dir = mil_unit |> MilUnit.direction in
  let num_soliders = mil_unit |> MilUnit.num_soliders in
  let morale = mil_unit |> MilUnit.morale in
  let leadership = mil_unit |> MilUnit.leadership in
  `Assoc [
    "Milunit", `Assoc [
      "identity", `String identity;
      "id", `Int id;
      "dir", `Int dir;
      "num_soliders", `Int num_soliders;
      "morale", `Int morale;
      "leadership", `Int leadership;
    ]
  ]


let map_content_to_safe_json (map_content: map_content) : json =
  let position = (fun (x, y) -> [`Int x; `Int y] ) map_content.position in
  let mil_unit = begin
    match map_content.mil_unit with
    | None -> `String "Null"
    | Some x -> x|> mil_unit_to_json
    end
    in
    let tile = map_content.tile in
    let tile_city_lvl = begin
     match map_content.tile with
       | City x -> Some (`Int x)
      | _ -> None
     end
     in
      `Assoc [
        "map_content", `Assoc [
        "position", `Tuple (position);
        "MilUnit", mil_unit;
        "tile", `Variant (tile |> Tile.to_string_json, tile_city_lvl);
        ]
      ]

let map_content_to_json (map_content: map_content) :Yojson.Basic.json =
  map_content |> map_content_to_safe_json |> to_basic

let diff_record_to_json (r: diff_record) : Yojson.Basic.json = `String "dd"

let diff_logs_to_json (l: diff_logs) : Yojson.Basic.json = `Null
