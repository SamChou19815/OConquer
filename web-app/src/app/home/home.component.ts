import { Component, OnInit } from '@angular/core';
import {
  Direction,
  Position,
  MilUnit,
  PlayerIdentity,
  MapContent, TileType
} from '../definitions';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  /**
   * The commonly used position.
   */
  private readonly position: Position = {
    x: 1,
    y: 2
  };
  /**
   * The commonly used black military unit.
   */
  private readonly blackMilUnit: MilUnit = {
    identity: PlayerIdentity.BLACK,
    id: 2,
    direction: Direction.WEST,
    numberOfSoldiers: 10000,
    morale: 2,
    leadership: 3
  };
  /**
   * The commonly used black military unit.
   */
  private readonly whiteMilUnit: MilUnit = {
    identity: PlayerIdentity.WHITE,
    id: 2,
    direction: Direction.NORTH,
    numberOfSoldiers: 10000,
    morale: 2,
    leadership: 3
  };
  readonly emptyTile: MapContent = {
    position: this.position,
    tileType: TileType.EMPTY
  };
  readonly mountainTile: MapContent = {
    position: this.position,
    tileType: TileType.MOUNTAIN,
  };
  readonly fortTile: MapContent = {
    position: this.position,
    tileType: TileType.FORT
  };
  readonly cityTile: MapContent = {
    position: this.position,
    tileType: TileType.CITY,
    cityLevel: 3
  };
  readonly emptyTileBlack: MapContent = {
    position: this.position,
    tileType: TileType.EMPTY,
    milUnit: this.blackMilUnit
  };
  readonly fortTileWhite: MapContent = {
    position: this.position,
    tileType: TileType.FORT,
    milUnit: this.whiteMilUnit
  };
  readonly cityTileBlack: MapContent = {
    position: this.position,
    tileType: TileType.CITY,
    cityLevel: 3,
    milUnit: this.blackMilUnit
  };
  readonly cityTileWhite: MapContent = {
    position: this.position,
    tileType: TileType.CITY,
    cityLevel: 3,
    milUnit: this.whiteMilUnit
  };

  constructor() {
  }

  ngOnInit() {
  }

}
