open Common

module IntMap = Map.Make (struct
    type t = int
    let compare i1 i2 = Pervasives.compare i1 i2
  end)

type mil_unit_map = MilUnit.t PosMap.t

type id_map = Position.t IntMap.t

type tile_map = Tile.t PosMap.t

type t = {
  mil_unit_map: mil_unit_map;
  id_map: id_map;
  tile_map: tile_map;
}

let init (m1: MilUnit.t) (m2: MilUnit.t) : t =
  {
    (* TODO fix dummy implementation *)
    mil_unit_map = PosMap.empty;
    id_map = IntMap.empty;
    tile_map = PosMap.empty;
  }

let mil_unit_map (m: t) : mil_unit_map = m.mil_unit_map

let tile_map (m: t) : tile_map = m.tile_map

let to_string (m: t) : string =
  let f1 pos mil_unit acc =
    acc ^ Position.to_string pos ^ " " ^ MilUnit.to_string mil_unit ^ " "
  in
  let f2 pos tile acc =
    acc ^ Position.to_string pos ^ " " ^ Tile.to_string tile ^ " "
  in
  PosMap.fold f1 m.mil_unit_map "" ^ "\n" ^ PosMap.fold f2 m.tile_map ""
