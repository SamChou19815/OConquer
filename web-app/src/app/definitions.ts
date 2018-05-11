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
  readonly x: number;
  readonly y: number;
}

/**
 * Definition for military unit.
 */
export interface MilUnit {
  readonly identity: PlayerIdentity;
  readonly id: number;
  readonly direction: Direction;
  readonly numberOfSoldiers: number;
  readonly morale: number;
  readonly leadership: number;
}

/**
 * Definition for map content.
 */
export interface MapContent {
  readonly position: Position;
  readonly tileType: TileType;
  readonly cityLevel?: number | null;
  readonly milUnit?: MilUnit | null;
}

/**
 * Definition for the entire game report.
 */
export interface GameReport {
  readonly logs: MapContent[][];
  readonly status: GameStatus;
}

/**
 * Definition for the grouped round record.
 */
export interface RoundRecord {
  readonly status: GameStatus;
  readonly record: MapContent[];
}

/**
 * Definition for one row of score board.
 */
export interface ScoreBoardRow {
  readonly username: string;
  readonly rating: number;
}
