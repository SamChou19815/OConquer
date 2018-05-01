open Common
open Definitions
open Yojson.Basic

type map_content = {
  position: Position.t;
  tile: Tile.t;
  mil_unit: MilUnit.t option;
}

type diff_record = map_content list

(* Stored in the reserve order. *)
type diff_logs = diff_record list

type game_report = {
  diff_logs: diff_logs;
  game_status: game_status
}

let create_map_content ?(mil_unit: MilUnit.t option = None)
    ~(pos: Position.t) ~(tile: Tile.t) : map_content =
  { position = pos; tile; mil_unit; }

let create_diff_record (lst: map_content list) : diff_record = lst

let create_diff_logs (lst: diff_record list) : diff_logs = lst

let create_game_report (logs: diff_logs) (status: game_status) : game_report =
  { diff_logs = logs; game_status = status; }

(**
 * [mil_unit_to_json mil_unit] converts a [mil_unit] to json format.
 *
 * Requires: [mil_unit] is a legal military unit.
 * @return json representation of [mil_unit].
*)
let mil_unit_to_json (mil_unit: MilUnit.t) : json =
  `Assoc [
    "identity", `String (MilUnit.identity_string mil_unit);
    "id", `Int (MilUnit.id mil_unit);
    "direction", `String (MilUnit.direction_string mil_unit);
    "numberOfSoldiers", `Int (MilUnit.num_soldiers mil_unit);
    "morale", `Int (MilUnit.morale mil_unit);
    "leadership", `Int (MilUnit.leadership mil_unit);
  ]

(**
 * [map_content_to_json map_content] converts a [map_content] into its json
 * representation.
 *
 * Requires: [map_content] is a legal map content.
 * @return json representation of [map_content].
*)
let map_content_to_json (map_content: map_content) : json =
  let (x, y) = map_content.position in
  let position = `Assoc ["x", `Int x; "y", `Int y] in
  let mil_unit = match map_content.mil_unit with
    | None -> `Null
    | Some mil_u -> mil_unit_to_json mil_u
  in
  let tile_type = `String (Tile.type_string map_content.tile) in
  let city_level = match map_content.tile with
    | City x -> `Int x
    | _ -> `Null
  in
  `Assoc [
    "position", position;
    "milUnit", mil_unit;
    "tileType", tile_type;
    "cityLevel", city_level;
  ]

(**
 * [diff_record_to_json r] converts a diff record into json format.
 *
 * Requires: [r] is a legal [diff_record].
 * @return the json format of the given [r].
*)
let diff_record_to_json (r: diff_record) : json =
  `List (List.map map_content_to_json r)

(**
 * [diff_logs_to_json l] converts a diff logs into json format.
 *
 * Requires: [l] is a legal [diff_logs].
 * @return the json format of the given [r].
*)
let diff_logs_to_json (l: diff_logs) : json =
  `List (List.map diff_record_to_json l)

let game_report_to_json (r: game_report) : json =
  let status = match r.game_status with
    | InProgress -> `String "IN_PROGRESS"
    | BlackWins -> `String "BLACK_WINS"
    | WhiteWins -> `String "WHITE_WINS"
    | Draw -> `String "DRAW"
  in
  `Assoc [
    "logs", diff_logs_to_json r.diff_logs;
    "status", status;
  ]
