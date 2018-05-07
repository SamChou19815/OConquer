import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from './material.module';
import { GameDisplayComponent } from '../game-display/game-display.component';
import { MapContentComponent } from '../map-content/map-content.component';
import {
  ProgramsInputComponent
} from '../programs-input/programs-input.component';

@NgModule({
  imports: [CommonModule, FormsModule, MaterialModule],
  exports: [CommonModule, FormsModule, MaterialModule,
    GameDisplayComponent, MapContentComponent, ProgramsInputComponent],
  declarations: [GameDisplayComponent, MapContentComponent,
    ProgramsInputComponent]
})
export class SharedModule {
}
