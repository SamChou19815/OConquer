import {Component, Input, OnInit} from '@angular/core';
import {MapContent, PlayerIdentity, Direction, TileType} from '../definitions';

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

  get playerIdentityString(): string {
    switch (this.mapContent.milUnit.playerIdentity) {
      case (PlayerIdentity.BLACK):
        return 'Black Player';
      case (PlayerIdentity.WHITE):
        return 'White Player';
    }
  }

  get directionString(): string {
    switch (this.mapContent.milUnit.direction) {
      case Direction.NORTH:
        return 'Direction North';
      case Direction.SOUTH:
        return 'Direction South';
      case Direction.EAST:
        return 'Direction East';
      case Direction.WEST:
        return 'Direction West';
    }
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
