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
    switch (this.mapContent.tileType) {
      case TileType.EMPTY:
        return 'cell empty';
      case TileType.MOUNTAIN:
        return 'cell mountain';
      case TileType.FORT:
        return 'cell fort';
      case TileType.CITY:
        return 'cell city';
    }
  }

  get playerIdentityString(): string {
    switch (this.mapContent.milUnit.playerIdentity) {
      case (PlayerIdentity.BLACK):
        return 'Black';
      case (PlayerIdentity.WHITE):
        return 'White';
    }
  }

  get directionString(): string {
    switch (this.mapContent.milUnit.direction) {
      case Direction.NORTH:
        return 'North';
      case Direction.SOUTH:
        return 'South';
      case Direction.EAST:
        return 'East';
      case Direction.WEST:
        return 'West';
    }
  }

}
