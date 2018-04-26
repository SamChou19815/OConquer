import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from './material.module';
import { GameDisplayComponent } from '../game-display/game-display.component';
import { MapContentComponent } from '../map-content/map-content.component';

@NgModule({
  imports: [CommonModule, FormsModule, MaterialModule],
  exports: [CommonModule, FormsModule, MaterialModule,
    GameDisplayComponent, MapContentComponent],
  declarations: [GameDisplayComponent, MapContentComponent]
})
export class SharedModule {
}
