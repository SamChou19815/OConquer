import { Component, Input, OnInit } from '@angular/core';
import { ScoreBoardRow } from '../../definitions';

@Component({
  selector: 'app-score-board',
  templateUrl: './score-board.component.html',
  styleUrls: ['./score-board.component.css']
})
export class ScoreBoardComponent implements OnInit {

  /**
   * A list of scores.
   */
  @Input() scoreBoard: ScoreBoardRow[];

  constructor() {
  }

  ngOnInit() {
  }

}
