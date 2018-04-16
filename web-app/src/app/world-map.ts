enum PlayerIdentity { BLACK, WHITE }

enum TileType {

  EMPTY, MOUNTAIN, FORT, CITY

}

enum Direction {
  EAST, NORTH, WEST, SOUTH
}

interface Position {
  x: number;
  y: number;
}

interface MilUnit {
  playerIdentity: PlayerIdentity;
  id: number;
  direction: Direction;
  numberOfSoldiers: number;
  morale: number;
  leadership: number;
}

interface MapContent {
  position: Position;
  tileType: TileType;
  cityLevel?: number;
  milUnit?: MilUnit;
}
