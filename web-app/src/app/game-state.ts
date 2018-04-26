import {
  GameReport,
  GameStatus,
  MapContent,
  MAX_HEIGHT,
  MAX_WIDTH,
  TileType
} from './definitions';

/**
 * Definition for the grouped round record.
 */
interface RoundRecord {
  status: GameStatus;
  record: MapContent[];
}

/**
 * The definition of a game board.
 */
export class GameBoard {

  /**
   * The backing field of status.
   */
  private _status: GameStatus;
  /**
   * The backing board field.
   */
  private _board: MapContent[][];
  /**
   * Number of turns passed.
   */
  private _numberOfTurns: number;

  /**
   * Construct an initial board.
   */
  constructor() {
    this.reset();
  }

  /**
   * Obtain the current status.
   *
   * @returns {GameStatus} the current status.
   */
  get status() {
    return this._status;
  }

  /**
   * Obtain the current board.
   *
   * @returns {MapContent[][]} the current board.
   */
  get board(): MapContent[][] {
    return this._board;
  }

  /**
   * Obtain the number of turns passed.
   *
   * @returns {number} Obtain the number of turns passed.
   */
  get numberOfTurns(): number {
    if (this._numberOfTurns === 0) {
      return 0;
    }
    return this._numberOfTurns - 1;
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
   * @param {RoundRecord} roundRecord the board change.
   */
  applyRoundRecord(roundRecord: RoundRecord) {
    this._numberOfTurns++;
    this._status = roundRecord.status;
    for (const change of roundRecord.record) {
      this._board[change.position.x][change.position.y] = change;
    }
  }

  /**
   * Apply changes from the given report from server.
   *
   * @param {GameReport} report the report that is the basis for change.
   */
  applyChanges(report: GameReport) {
    for (const record of report.logs) {
      const roundRecord = {
        status: report.status,
        record: [...record]
      };
      this.applyRoundRecord(roundRecord);
    }
  }

  /**
   * Reset the board.
   */
  reset(): void {
    this._status = GameStatus.IN_PROGRESS;
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
    this._numberOfTurns = 0;
  }

}

/**
 * The definition of all the game state.
 */
export class GameState {
  /**
   * A collection of all the recorded round records.
   * e.g. this._roundRecords[i] means the map of the world at round i.
   */
  private readonly _roundRecords: RoundRecord[];

  /**
   * Construct an game state from an empty template, which represents the start
   * of the game.
   */
  constructor() {
    this._roundRecords = [];
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
  getRoundRecord(roundID: number): RoundRecord {
    return this._roundRecords[roundID];
  }

  /**
   * Apply changes from the given report from server.
   *
   * @param {GameReport} report the report that is the basis for change.
   */
  applyChanges(report: GameReport) {
    for (const record of report.logs) {
      const roundRecord = {
        status: report.status,
        record: [...record]
      };
      this._roundRecords.push(roundRecord);
    }
  }

}
