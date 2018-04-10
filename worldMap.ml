open Common

(* Some type alias to improve readability of code. *)
type pos_2_id_map = int PosMap.t
type pos_2_tile_map = Tile.t PosMap.t
type id_2_mil_unit_map = Position.t IntMap.t

type t = {
  pos_2_id_map: pos_2_id_map;
  pos_2_tile_map: pos_2_tile_map;
  id_2_mil_unit_map: id_2_mil_unit_map;
}

let init (m1: MilUnit.t) (m2: MilUnit.t) : t =
  {
    (* TODO fix dummy implementation *)
    pos_2_id_map = PosMap.empty;
    pos_2_tile_map = PosMap.empty;
    id_2_mil_unit_map = IntMap.empty;
  }

let mil_unit_map (m: t) : MilUnit.t PosMap.t = failwith "Unimplemented"

let tile_map (m: t) : pos_2_tile_map = m.pos_2_tile_map

let to_string (m: t) : string =
  let f1 pos mil_unit acc =
    acc ^ Position.to_string pos ^ " " ^ MilUnit.to_string mil_unit ^ " "
  in
  let f2 pos tile acc =
    acc ^ Position.to_string pos ^ " " ^ Tile.to_string tile ^ " "
  in
  PosMap.fold f1 (mil_unit_map m) "" ^ "\n" ^ PosMap.fold f2 (tile_map m) ""
