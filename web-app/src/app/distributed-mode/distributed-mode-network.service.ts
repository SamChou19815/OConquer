import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { GameReport, ScoreBoardRow } from '../definitions';

/**
 * Obtain the full URL for the request.
 *
 * @param {string} host the host of the request.
 * @param {string} path the path of the request.
 * @returns {string} the constructed full URL.
 */
function getUrl(host: string, path: string): string {
  return `http://${host}:8088/apis/remote/${path}`;
}

@Injectable()
export class DistributedModeNetworkService {

  /**
   * Construct a network service dedicated for the local mode.
   *
   * @param {HttpClient} http HTTP client from Angular.
   */
  constructor(private http: HttpClient) {
  }

  /**
   * Send an echo request to the server.
   *
   * @param {string} host host host of the service.
   * @param {(report: boolean) => void} callback handle the callback that tells
   * whether the host server exists.
   */
  echo(host: string, callback: (report: boolean) => void) {
    this.http.get(getUrl(host, 'echo'), { responseType: 'text' })
      .subscribe(resp => {
        if (resp === 'OK') {
          callback(true);
        } else {
          alert(resp);
          callback(false);
        }
      }, () => callback(false));
  }

  /**
   * Send a register request to the server.
   *
   * @param {string} host host of the service.
   * @param {string} username username given by user.
   * @param {string} password password given by user.
   * @param {(tokenOpt: (string | null)) => void} callback handle the callback
   * which may give null or the token.
   */
  register(host: string, username: string, password: string,
           callback: (tokenOpt: string | null) => void) {
    this.http.post(getUrl(host, 'register'), {
      'username': username,
      'password': password
    }, { responseType: 'text' }).subscribe(resp => {
      if (resp === 'USERNAME_USED') {
        callback(null);
      } else {
        callback(resp);
      }
    });
  }

  /**
   * Send a login request to the server.
   *
   * @param {string} host host of the service.
   * @param {string} username username given by user.
   * @param {string} password password given by user.
   * @param {(tokenOpt: (string | null)) => void} callback handle the callback
   * which may give null or the token.
   */
  login(host: string, username: string, password: string,
        callback: (tokenOpt: string | null) => void) {
    this.http.post(getUrl(host, 'sign_in'), {
      'username': username,
      'password': password
    }, { responseType: 'text' }).subscribe(resp => {
      if (resp === 'BAD_CREDENTIAL') {
        callback(null);
      } else {
        callback(resp);
      }
    });
  }

  /**
   * Send a submit programs request to the server.
   *
   * @param {string} host host of the service.
   * @param {string} token token of the user.
   * @param {string} blackProgram the program of black player.
   * @param {string} whiteProgram the program of white player.
   * @param {(report: boolean) => void} callback callback processor to process
   * when submission succeeds to fails (true or false).
   */
  submitPrograms(host: string, token: string,
                 blackProgram: string, whiteProgram: string,
                 callback: (report: boolean) => void) {
    this.http.post(getUrl(host, `submit_programs?token=${token}`), {
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
   * Send a query request to the server.
   *
   * @param {string} host host of the service.
   * @param {string} token token of the user.
   * @param {number} roundID the last seen round ID.
   * @param {(report: GameReport) => void} callback callback processor.
   */
  query(host: string, token: string, roundID: number,
        callback: (report: GameReport) => void): void {
    const url = getUrl(host, `query?token=${token}&round_id=${roundID}`);
    this.http.get<GameReport>(url).subscribe(callback);
  }

  /**
   * Send a request to fetch the score board.
   *
   * @param {string} host host of the service.
   * @param {(scoreBord: ScoreBoardRow[]) => void} callback callback processor
   * for the scoreboard.
   */
  scoreBoard(host: string, callback: (scoreBord: ScoreBoardRow[]) => void) {
    this.http.get<ScoreBoardRow[]>(getUrl(host, 'score_board'))
      .subscribe(callback);
  }

}
