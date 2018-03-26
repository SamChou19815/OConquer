open Common

type t = {
  mil_unit_map: MilUnit.t PosMap.t;
  tile_map: Tile.terrain PosMap.t;
}

let init (p1: Command.program) (p2: Command.program) : t =
  {
    (* TODO fix dummy implementation *)
    mil_unit_map = PosMap.empty;
    tile_map = PosMap.empty;
  }
