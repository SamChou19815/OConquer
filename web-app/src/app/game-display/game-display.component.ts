import { Component, Input, OnInit } from '@angular/core';
import { GameBoard } from '../game-state';

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

}
