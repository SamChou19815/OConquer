import {
  GameReport,
  GameStatus,
  MapContent,
  MAX_HEIGHT,
  MAX_WIDTH,
  RoundRecord,
  TileType
} from './definitions';
import { gameReportToRoundRecords } from './util';

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
  get status(): GameStatus {
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
    return this._numberOfTurns;
  }

  /**
   * Apply a diff record to update itself.
   *
   * @param {RoundRecord} roundRecord the board change.
   */
  protected applyRoundRecord(roundRecord: RoundRecord) {
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
    const roundRecords = gameReportToRoundRecords(report);
    const maxLen = roundRecords.length;
    this._numberOfTurns += maxLen;
    this._status = roundRecords[maxLen - 1].status;
    // Flatten record and apply all at once.
    const temp: (MapContent | null)[][] = new Array(MAX_WIDTH);
    for (let i = 0; i < MAX_WIDTH; i++) {
      const t = new Array(MAX_HEIGHT);
      for (let j = 0; j < MAX_HEIGHT; j++) {
        t[j] = null;
      }
      temp[i] = t;
    }
    for (let i = 0; i < maxLen; i++) {
      for (const change of roundRecords[i].record) {
        temp[change.position.x][change.position.y] = change;
      }
    }
    for (let i = 0; i < MAX_WIDTH; i++) {
      for (let j = 0; j < MAX_HEIGHT; j++) {
        const c = temp[i][j];
        if (c !== null) {
          this._board[i][j] = c;
        }
      }
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
    this._numberOfTurns = -1;
  }

}
