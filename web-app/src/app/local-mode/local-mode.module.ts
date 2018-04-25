import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LocalModeComponent } from './local-mode.component';
import { LocalModeRoutingModule } from './local-mode-routing.module';
import { SharedModule } from '../shared/shared.module';
import { LocalModeProgramsInputComponent } from './local-mode-programs-input/local-mode-programs-input.component';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    LocalModeRoutingModule
  ],
  declarations: [LocalModeComponent, LocalModeProgramsInputComponent],
  providers: []
})
export class LocalModeModule { }
