import {Component, Input, OnInit} from '@angular/core';
import { TileType } from '../definitions';

@Component({
  selector: 'app-map-content',
  templateUrl: './map-content.component.html',
  styleUrls: ['./map-content.component.css']
})
export class MapContentComponent implements OnInit {

  @Input() mapContent: MapContent;

  constructor() {
  }

  ngOnInit() {
  }

  get tileString(): string {
    switch (this.mapContent.tileType) {
      case TileType.EMPTY:
        return 'Empty Tile';
      case TileType.MOUNTAIN:
        return 'Mountain Tile';
      case TileType.FORT:
        return 'Fort Tile';
      case TileType.CITY:
        return 'City Tile of level ' + this.mapContent.cityLevel;
    }
  }

}
