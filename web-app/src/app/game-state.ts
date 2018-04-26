import {
  GameReport,
  GameStatus,
  MapContent,
  MAX_HEIGHT,
  MAX_WIDTH,
  TileType
} from './definitions';

/**
 * The definition of a game board.
 */
export class GameBoard {
  /**
   * The backing board field.
   */
  private _board: MapContent[][];

  /**
   * Construct an initial board.
   */
  constructor() {
    const initialRecord = new Array(MAX_HEIGHT);
    for (let j = 0; j < MAX_HEIGHT; j++) {
      const row = new Array(MAX_WIDTH);
      for (let i = 0; i < MAX_WIDTH; i++) {
        row[i] = {
          position: { x: i, y: j },
          tileType: TileType.EMPTY,
          cityLevel: null,
          militaryUnit: null,
        };
      }
      initialRecord[j] = row;
    }
    this._board = initialRecord;
  }

  /**
   * Obtain the content at the specified position.
   *
   * @param {number} x x coordinate.
   * @param {number} y y coordinate.
   * @returns {MapContent}
   */
  getContent(x: number, y: number): MapContent {
    return this._board[x][y];
  }

  /**
   * Apply a diff record to update itself.
   *
   * @param {MapContent[][]} diffRecordBoard the board change.
   */
  applyDiffRecord(diffRecordBoard: (MapContent | null)[][]) {
    for (let i = 0; i < diffRecordBoard.length; i++) {
      const row = diffRecordBoard[i];
      for (let j = 0; j < row.length; j++) {
        const c: MapContent | null = row[j];
        if (c != null) {
          // Only apply changes that is not null (no change).
          this._board[i][j] = c;
        }
      }
    }
  }

}

/**
 * The definition of all the game state.
 */
export class GameState {
  /**
   * The current status of the game. (end or in progress)
   */
  private _status: GameStatus;
  /**
   * A collection of all the recorded round records.
   * The first level is the collection of all known round records.
   * The second and third level is a 2D array description of the
   * game.
   * e.g. this._roundRecords[i] means the map of the world at round i.
   */
  private readonly _roundRecords: (MapContent | null)[][][];

  /**
   * Construct an game state from an empty template, which represents the start
   * of the game.
   */
  constructor() {
    this._status = GameStatus.IN_PROGRESS;
    // Initial Record Init
    const initialRecord = new Array(MAX_HEIGHT);
    for (let j = 0; j < MAX_HEIGHT; j++) {
      const row = new Array(MAX_WIDTH);
      for (let i = 0; i < MAX_WIDTH; i++) {
        row[i] = {
          position: { x: i, y: j },
          tileType: TileType.EMPTY,
          cityLevel: null,
          militaryUnit: null,
        };
      }
      initialRecord[j] = row;
    }
    this._roundRecords = [initialRecord];
  }

  /**
   * Obtain the current status of the game.
   *
   * @returns {GameStatus} the current status of the game.
   */
  get status(): GameStatus {
    return this._status;
  }

  /**
   * Obtain number of rounds passed.
   *
   * @returns {number} number of rounds passed.
   */
  get numberOfRounds(): number {
    return this._roundRecords.length;
  }

  /**
   * Obtain the round record at a particular round ID.
   *
   * @param {number} roundID the ID of the round.
   * @returns {MapContent[]} the content of the record.
   */
  getRoundRecord(roundID: number): MapContent[] {
    return [...this._roundRecords[roundID]];
  }

  /**
   * Append a round record to the end of the records.
   *
   * @param {MapContent[]} roundRecord the record to be appended.
   */
  private appendRoundRecord(roundRecord: (MapContent | null)[]) {
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

  /**
   * Apply changes from the given report from server.
   *
   * @param {GameReport} report the report that is the basis for change.
   */
  applyChanges(report: GameReport) {
    this._status = report.status;
    for (const roundRecord of report.logs) {
      this.appendRoundRecord(roundRecord);
    }
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
