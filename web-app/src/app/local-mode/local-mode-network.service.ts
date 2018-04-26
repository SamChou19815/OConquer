import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { GameReport } from '../definitions';

/**
 * URL prefix.
 * @type {string}
 */
const PREFIX = '/apis/local/';

@Injectable()
export class LocalModeNetworkService {

  /**
   * Construct a network service dedicated for the local mode.
   *
   * @param {HttpClient} http HTTP client from Angular.
   */
  constructor(private http: HttpClient) {
  }

  /**
   * Send a start simulation request to the server.
   *
   * @param {string} blackProgram the program of black player.
   * @param {string} whiteProgram the program of white player.
   * @param {(report: string) => void} callback callback processor to process
   * when submission succeeds to fails (true or false).
   */
  startSimulation(blackProgram: string, whiteProgram: string,
                  callback: (report: boolean) => void) {
    this.http.post(PREFIX + 'start_simulation', {
      'black_program': blackProgram,
      'white_program': whiteProgram
    }, { responseType: 'text' }).subscribe((resp: string) => {
      if (resp === 'OK') {
        callback(true);
      } else if (resp === 'DOES_NOT_COMPILE') {
        callback(false);
      } else {
        throw new Error('BAD RESPONSE: ' + resp);
      }
    });
  }

  /**
   * Query the current state in the local server.
   *
   * @param {number} roundID the last seen round ID.
   * @param {(report: GameReport) => void} callback callback processor.
   */
  query(roundID: number, callback: (report: GameReport) => void): void {
    this.http.get<GameReport>(PREFIX + 'query?round_id' + roundID)
      .subscribe(callback);
  }

}
