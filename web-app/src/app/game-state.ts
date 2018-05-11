import { GameReport, MapContent, RoundRecord } from './definitions';
import { GameBoard } from './game-board';
import { gameReportToRoundRecords, sleep } from './util';

/**
 * The definition of all the game state.
 */
export class GameState extends GameBoard {

  /**
   * A collection of all the recorded round records.
   * e.g. this._roundRecords[i] means the map of the world at round i.
   */
  private _roundRecords: RoundRecord[];

  /**
   * Construct an game state from an empty template, which represents the start
   * of the game.
   */
  constructor() {
    super();
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
   * Obtain the game board.
   *
   * @returns {GameBoard} the game board.
   */
  get gameBoard(): GameBoard {
    return this;
  }

  /**
   * Apply changes from the given report from server.
   *
   * @param {GameReport} report the report that is the basis for change.
   */
  applyChanges(report: GameReport) {
    super.applyChanges(report);
    const records = gameReportToRoundRecords(report);
    for (const record of records) {
      this._roundRecords.push(record);
    }
  }

  /**
   * Helper function for replay.
   * It apply the record record at the given index, and it reports when it
   * reaches the end.
   *
   * @param {number} index index index of the record record applied.
   * @param {() => void} doneReporter the reporter called when finished.
   */
  private replayHelper(index: number, doneReporter: () => void) {
    if (index >= this._roundRecords.length) {
      doneReporter();
      return; // end of replay
    }
    super.applyRoundRecord(this._roundRecords[index]);
    sleep(50).then(
      () => this.replayHelper(index + 1, doneReporter));
  }

  /**
   * Replay the entire game.
   * This function can be only called after the entire game has finished.
   *
   * @param {() => void} doneReporter the reporter called when finished
   * replaying.
   */
  replay(doneReporter: () => void) {
    super.reset();
    this.replayHelper(0, doneReporter);
  }

  /**
   * Reset the entire game state.
   */
  reset() {
    super.reset();
    this._roundRecords = [];
  }

}
