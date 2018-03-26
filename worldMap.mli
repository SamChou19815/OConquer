open Common

type t = {
  mil_unit_map: MilUnit.t PosMap.t;
  tile_map: Tile.terrain PosMap.t;
}

val init : Command.program -> Command.program -> t
