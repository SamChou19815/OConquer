import { Component, OnInit } from '@angular/core';
import {
  DistributedModeNetworkService
} from './distributed-mode-network.service';
import { GameStatus, ScoreBoardRow } from '../definitions';
import { GameBoard } from '../game-state';

@Component({
  selector: 'app-distributed-mode',
  templateUrl: './distributed-mode.component.html',
  styleUrls: ['./distributed-mode.component.css']
})
export class DistributedModeComponent implements OnInit {

  /**
   * Host for the remote server.
   */
  host: string;
  /**
   * Identity token of the user.
   */
  private token: string;
  /**
   * The current game board.
   */
  private readonly _gameBoard: GameBoard;
  /**
   * The current displayed score board.
   */
  private _scoreBoard: ScoreBoardRow[];
  /**
   * A flag to record whether the user specified remote server host works.
   * @type {boolean}
   */
  private _remoteServerWorks = false;
  /**
   * A flag to record whether the user has logged in.
   * @type {boolean}
   */
  private _loggedIn = false;
  /**
   * A flag to record whether the user is in query mode.
   * @type {boolean}
   */
  private _inQueryMode = false;
  /**
   * A flag to record whether the game data is available.
   * @type {boolean}
   */
  private _gameDataAvailable = false;

  /**
   * Construct itself from supporting services.
   *
   * @param {LocalModeNetworkService} networkService the network service.
   */
  constructor(private networkService: DistributedModeNetworkService) {
    this._gameBoard = new GameBoard();
  }

  ngOnInit() {
  }

  /**
   * Report whether the user specified remote server host works.
   *
   * @returns {boolean} whether the user specified remote server host works.
   */
  get remoteServerWorks(): boolean {
    return this._remoteServerWorks;
  }

  /**
   * Report whether the user has logged in.
   *
   * @returns {boolean} whether the user has logged in.
   */
  get loggedIn(): boolean {
    return this._loggedIn;
  }

  /**
   * Report whether the user is in query mode.
   *
   * @returns {boolean} whether the user is in query mode.
   */
  get inQueryMode(): boolean {
    return this._inQueryMode;
  }

  /**
   * Report whether the game data is available.
   *
   * @returns {boolean} whether the game data is available.
   */
  get gameDataAvailable(): boolean {
    return this._gameDataAvailable;
  }

  /**
   * Obtain the current game board.
   *
   * @returns {GameBoard} the current game board.
   */
  get game(): GameBoard {
    return this._gameBoard;
  }

  /**
   * Obtain the current score board.
   *
   * @returns {ScoreBoardRow[]} the current score board.
   */
  get scoreBoard(): ScoreBoardRow[] {
    return this._scoreBoard;
  }

  /**
   * Handle when the user chooses his remote server.
   */
  chooseRemoteServer() {
    this.networkService.echo(this.host, doesWork => {
      if (doesWork) {
        this._remoteServerWorks = true;
        this.reloadScoreBoard();
      } else {
        alert('This remote server address does not work!');
      }
    });
  }

  /**
   * Handle the register/login request.
   *
   * @param {[boolean , string]} request the request tuple.
   */
  registerOrLogin(request: [boolean, string, string]) {
    const isRegister = request[0];
    const username = request[1];
    const password = request[2];
    if (isRegister) {
      this.networkService.register(this.host, username, password,
        tokenOpt => {
          if (tokenOpt === null) {
            alert('This username is already used.');
            return;
          }
          this.token = tokenOpt;
          this._loggedIn = true;
        });
    } else {
      this.networkService.login(this.host, username, password,
        tokenOpt => {
          if (tokenOpt === null) {
            alert('Wrong username-password combination!');
            return;
          }
          this.token = tokenOpt;
          this._loggedIn = true;
        });
    }
  }

  /**
   * Handle when the program gets submitted.
   *
   * @param {[string]} programs a tuple of black and white programs.
   */
  programSubmitted(programs: [string, string]): void {
    const blackProgram = programs[0], whiteProgram = programs[1];
    this.networkService.submitPrograms(this.host, this.token,
      blackProgram, whiteProgram, isSuccessful => {
        if (isSuccessful) {
          this._inQueryMode = true;
          this.makeQuery();
        } else {
          this._inQueryMode = false;
          alert('Your code does not compile!');
        }
      });
  }

  /**
   * Sleep for a while.
   *
   * @param {number} time number of MS to sleep.
   * @returns {Promise<void>} the promise after sleep.
   */
  private async sleep(time: number): Promise<void> {
    await new Promise<void>(resolve => setTimeout(resolve, time));
  }

  /**
   * Start to make query to the server.
   */
  private makeQuery(): void {
    if (!this._remoteServerWorks || !this._inQueryMode) {
      return;
    }
    this.networkService.query(this.host, this.token,
      this._gameBoard.numberOfTurns, report => {
        if (report === null) {
          this._gameDataAvailable = false;
          this._inQueryMode = true;
          this.sleep(2000).then(() => this.makeQuery());
          return;
        }
        this._gameDataAvailable = true;
        this._gameBoard.applyChanges(report);
        if (report.status === GameStatus.IN_PROGRESS) {
          this._inQueryMode = true;
          this.sleep(400).then(() => this.makeQuery());
        } else {
          this._inQueryMode = true;
        }
      });
  }

  /**
   * Start to reload score board infrequently.
   */
  private reloadScoreBoard(): void {
    if (!this._remoteServerWorks) {
      return;
    }
    this.networkService.scoreBoard(this.host, scoreBord => {
      this._scoreBoard = scoreBord;
      this.sleep(3000).then(() => this.reloadScoreBoard());
    });
  }

  /**
   * Reset so that the user can try another server.
   */
  tryAnotherServer(): void {
    this.host = undefined;
    this.token = undefined;
    this._gameBoard.reset();
    this._scoreBoard = undefined;
    this._remoteServerWorks = false;
    this._loggedIn = false;
    this._inQueryMode = false;
    this._gameDataAvailable = false;
  }

  /**
   * Reset to let user log out.
   */
  logout(): void {
    this.token = undefined;
    this._gameBoard.reset();
    this._loggedIn = false;
    this._inQueryMode = false;
    this._gameDataAvailable = false;
  }

  /**
   * Display the running game.
   */
  displayRunningGame() {
    this._inQueryMode = true;
    this.makeQuery();
  }

  /**
   * Hide the game display.
   */
  hideGameDisplay() {
    this._inQueryMode = false;
  }

}
