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

let to_string (m: t) : string = ""
