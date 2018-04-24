import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LocalModeComponent } from './local-mode.component';
import { LocalModeRoutingModule } from './local-mode-routing.module';
import { SharedModule } from '../shared/shared.module';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    LocalModeRoutingModule
  ],
  declarations: [LocalModeComponent],
  providers: []
})
export class LocalModeModule { }
