import { Component, Input, OnInit } from '@angular/core';
import { GameState } from '../definitions';

@Component({
  selector: 'app-game-display',
  templateUrl: './game-display.component.html',
  styleUrls: ['./game-display.component.css']
})
export class GameDisplayComponent implements OnInit {

  @Input() gameState: GameState;
  @Input() roundIDForDisplay: number;

  constructor() {
  }

  ngOnInit() {
  }

}
