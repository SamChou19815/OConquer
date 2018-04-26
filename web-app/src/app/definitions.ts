/**
 * Maximum width of the game board.
 * @type {number}
 */
export const MAX_WIDTH = 10;
/**
 * Maximum height of the game board.
 * @type {number}
 */
export const MAX_HEIGHT = 10;

/**
 * A collection of all possible player identity.
 */
export enum PlayerIdentity { BLACK = 'BLACK', WHITE = 'WHITE' }

/**
 * A collection of all game status.
 */
export enum GameStatus {
  BLACK_WINS = 'BLACK_WINS',
  WHITE_WINS = 'WHITE_WINS',
  DRAW = 'DRAW',
  IN_PROGRESS = 'IN_PROGRESS'
}

/**
 * A collection of all tile types.
 */
export enum TileType {
  EMPTY = 'EMPTY', MOUNTAIN = 'MOUNTAIN', FORT = 'FORT', CITY = 'CITY'
}

/**
 * A collection of all supported direction.
 */
export enum Direction {
  EAST = 'EAST', NORTH = 'NORTH', WEST = 'WEST', SOUTH = 'SOUTH'
}

/**
 * Definition for position.
 */
export interface Position {
  x: number;
  y: number;
}

/**
 * Definition for military unit.
 */
export interface MilUnit {
  playerIdentity: PlayerIdentity;
  id: number;
  direction: Direction;
  numberOfSoldiers: number;
  morale: number;
  leadership: number;
}

/**
 * Definition for map content.
 */
export interface MapContent {
  position: Position;
  tileType: TileType;
  cityLevel?: number | null;
  milUnit?: MilUnit | null;
}

export interface GameReport {
  logs: MapContent[][];
  status: GameStatus;
}
