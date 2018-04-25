export enum PlayerIdentity { BLACK = 'BLACK', WHITE = 'WHITE' }

export enum GameStatus {
  BLACK_WINS = 'BLACK_WINS',
  WHITE_WINS = 'WHITE_WINS',
  DRAW = 'DRAW',
  IN_PROGRESS = 'IN_PROGRESS'
}

export enum TileType {
  EMPTY = 'EMPTY', MOUNTAIN = 'MOUNTAIN', FORT = 'FORT', CITY = 'CITY'
}

export enum Direction {
  EAST = 'EAST', NORTH = 'NORTH', WEST = 'WEST', SOUTH = 'SOUTH'
}

export interface Position {
  x: number;
  y: number;
}

export interface MilUnit {
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

export class GameState {
  /**
   * The current status of the game. (end or in progress)
   */
  private _status: GameStatus;
  /**
   * A collection of all the round records.
   * The first level is the collection of all known round records.
   * The second and third level is a 2D array description of the
   * game.
   * e.g. this._roundRecords[i] means the map of the world at round i.
   */
  private _roundRecords: MapContent[][][];

  constructor() {
    this._status = GameStatus.IN_PROGRESS;
    this._roundRecords = [];
  }

  get status(): GameStatus {
    return this._status;
  }

  get numberOfRounds() {
    return this._roundRecords.length;
  }

  appendRoundRecord(roundRecord: MapContent[]) {
    const transformed: MapContent[][] = roundRecord
      .sort((a, b) => {
        return 0; // TODO implement with correct sort.
      })
      .map(value => {
        return [];
        // TODO turn flattened to 2-D array representation of game map.
      });
    this._roundRecords.push(transformed);
  }

  getRoundRecord(roundID: number) {
    return [...this._roundRecords[roundID]];
  }

}

/*
A useful example:
const gameState = new GameState();
const newMapContent: MapContent = {
  position: { x: 0, y: 0 },
  tileType: TileType.EMPTY,
  cityLevel: null,
  milUnit: null,
};
const roundRecord = [newMapContent];
gameState.appendRoundRecord(roundRecord);
console.log(gameState.getRoundRecord(0));
 */
