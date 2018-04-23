enum PlayerIdentity { BLACK = "BLACK", WHITE = "WHITE" }

enum TileType {
  EMPTY = "EMPTY", MOUNTAIN = "MOUNTAIN", FORT = "FORT", CITY = "CITY"
}

enum Direction {
  EAST = "EAST", NORTH = "NORTH", WEST = "WEST", SOUTH = "SOUTH"
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
  cityLevel?: number | null;
  milUnit?: MilUnit | null;
}
