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

/*
Example:
{
    "playerIdentity": "BLACK",
    "id": 10,
    "direction": "EAST",
    "numberOfSoldiers": 100,
    "morale": 10,
    "leadership": 30
}
*/

interface MapContent {
  position: Position;
  tileType: TileType;
  cityLevel?: number;
  milUnit?: MilUnit;
}
