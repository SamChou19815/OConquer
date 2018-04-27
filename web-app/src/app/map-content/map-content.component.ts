import { Component, Input, OnInit } from '@angular/core';
import {
  MapContent,
  PlayerIdentity,
  Direction,
  TileType
} from '../definitions';

@Component({
  selector: 'app-map-content',
  templateUrl: './map-content.component.html',
  styleUrls: ['./map-content.component.scss']
})
export class MapContentComponent implements OnInit {

  @Input() mapContent: MapContent;

  constructor() {
  }

  ngOnInit() {
  }

  get cellStyle(): string {
    let classes = 'cell';
    switch (this.mapContent.tileType) {
      case TileType.EMPTY:
        classes += ' empty';
        break;
      case TileType.MOUNTAIN:
        classes += ' mountain';
        break;
      case TileType.FORT:
        classes += ' fort';
        break;
      case TileType.CITY:
        classes += ' city';
        break;
    }
    if (this.mapContent.milUnit === null
      || this.mapContent.milUnit === undefined) {
      return classes + ' no-player';
    }
    switch (this.mapContent.milUnit.identity) {
      case PlayerIdentity.BLACK:
        classes += ' black-player';
        break;
      case PlayerIdentity.WHITE:
        classes += ' white-player';
        break;
    }
    return classes;
  }

  get playerIdentityString(): string {
    switch (this.mapContent.milUnit.identity) {
      case (PlayerIdentity.BLACK):
        return 'Black';
      case (PlayerIdentity.WHITE):
        return 'White';
    }
  }

  get directionString(): string {
    switch (this.mapContent.milUnit.direction) {
      case Direction.NORTH:
        return 'N';
      case Direction.SOUTH:
        return 'S';
      case Direction.EAST:
        return 'E';
      case Direction.WEST:
        return 'W';
    }
  }

}
