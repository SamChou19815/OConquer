import { Component, Input, OnInit } from '@angular/core';
import { GameStatus } from '../definitions';
import { GameBoard } from '../game-board';

@Component({
  selector: 'app-game-display',
  templateUrl: './game-display.component.html',
  styleUrls: ['./game-display.component.css']
})
export class GameDisplayComponent implements OnInit {

  /**
   * The current game board to be displayed.
   */
  @Input() game: GameBoard;
  /**
   * Report whether the game data is available.
   */
  @Input() gameDataAvailable: boolean;

  constructor() {
  }

  ngOnInit() {
  }

  /**
   * Report the game status.
   *
   * @returns {string} the game status.
   */
  get gameStatus(): string {
    switch (this.game.status) {
      case GameStatus.IN_PROGRESS:
        return 'In Progress';
      case GameStatus.BLACK_WINS:
        return 'Black Wins';
      case GameStatus.WHITE_WINS:
        return 'White Wins';
      case GameStatus.DRAW:
        return 'Draw';
    }
  }

}
