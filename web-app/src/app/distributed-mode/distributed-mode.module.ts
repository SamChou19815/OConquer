import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DistributedModeComponent } from './distributed-mode.component';
import { SharedModule } from '../shared/shared.module';
import {
  DistributedModeRoutingModule
} from './distributed-mode-routing.module';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    DistributedModeRoutingModule
  ],
  declarations: [DistributedModeComponent],
  providers: []
})
export class DistributedModeModule {
}
