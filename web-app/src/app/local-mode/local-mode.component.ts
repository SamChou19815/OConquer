import { Component, OnInit } from '@angular/core';
import { LocalModeNetworkService } from './local-mode-network.service';
import { GameBoard } from '../game-state';
import { GameStatus } from '../definitions';

@Component({
  selector: 'app-local-mode',
  templateUrl: './local-mode.component.html',
  styleUrls: ['./local-mode.component.css']
})
export class LocalModeComponent implements OnInit {

  /**
   * Report whether the server is running the program.
   */
  private _running: boolean;
  /**
   * The current game board.
   */
  private readonly _gameBoard: GameBoard;

  /**
   * Construct itself from supporting services.
   *
   * @param {LocalModeNetworkService} networkService the network service.
   */
  constructor(private networkService: LocalModeNetworkService) {
    this._running = false;
    this._gameBoard = new GameBoard();
  }

  ngOnInit() {
  }

  /**
   * Report whether the game is running.
   *
   * @returns {boolean} whether the game is running.
   */
  get isRunning(): boolean {
    return this._running;
  }

  /**
   * Obtain the current game board.
   *
   * @returns {GameBoard} the current game board.
   */
  get gameBoard(): GameBoard {
    return this._gameBoard;
  }

  /**
   * Sleep for a while.
   */
  private async sleep(): void {
    await new Promise(resolve => setTimeout(resolve, 200));
  }

  /**
   * Start to make query to the server.
   */
  private makeQuery(): void {
    this.networkService.query(this._gameBoard.board.length - 1,
      report => {
        this._gameBoard.applyChanges(report);
        if (report.status === GameStatus.IN_PROGRESS) {
          this._running = true;
          this.sleep();
          this.makeQuery();
        } else {
          this._running = false;
        }
      });
  }

  /**
   * Handle when the program gets submitted.
   *
   * @param {[string]} programs a tuple of black and white programs.
   */
  programSubmitted(programs: [string, string]): void {
    const blackProgram = programs[0], whiteProgram = programs[1];
    this.networkService.startSimulation(blackProgram, whiteProgram,
      isSuccessful => {
        if (isSuccessful) {
          this._running = true;
          this.makeQuery();
        } else {
          this._running = false;
          alert('Your code does not compile!');
        }
      });
  }

}
