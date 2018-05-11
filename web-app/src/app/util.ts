import {
  GameReport,
  GameStatus,
  RoundRecord
} from './definitions';

/**
 * Sleep for a while.
 *
 * @param {number} time number of MS to sleep.
 * @returns {Promise<void>} the promise after sleep.
 */
export async function sleep(time: number): Promise<void> {
  await new Promise<void>(resolve => setTimeout(resolve, time));
}

/**
 * Convert one game report into an array of round records.
 *
 * @param {GameReport} report report to split.
 * @returns {RoundRecord[]} an array of round records from the game report.
 */
export function gameReportToRoundRecords(report: GameReport): RoundRecord[] {
  const maxLen = report.logs.length;
  const records: RoundRecord[] = new Array(maxLen);
  for (let i = 0; i < maxLen; i++) {
    records[i] = {
      status: i === maxLen - 1 ? report.status : GameStatus.IN_PROGRESS,
      record: report.logs[i]
    };
  }
  return records;
}
