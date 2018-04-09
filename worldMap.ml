open Common

type t = {
  mil_unit_map: MilUnit.t PosMap.t;
  tile_map: Tile.t PosMap.t;
}

let init (m1: MilUnit.t) (m2: MilUnit.t) : t =
  {
    (* TODO fix dummy implementation *)
    mil_unit_map = PosMap.empty;
    tile_map = PosMap.empty;
  }

let to_string (m: t) : string =
  let f1 pos mil_unit acc =
    acc ^ Position.to_string pos ^ " " ^ MilUnit.to_string mil_unit ^ " "
  in
  let f2 pos tile acc =
    acc ^ Position.to_string pos ^ " " ^ Tile.to_string tile ^ " "
  in
  PosMap.fold f1 m.mil_unit_map "" ^ "\n" ^ PosMap.fold f2 m.tile_map ""
