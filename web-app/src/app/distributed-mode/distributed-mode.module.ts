import { NgModule } from '@angular/core';
import { DistributedModeComponent } from './distributed-mode.component';
import { SharedModule } from '../shared/shared.module';
import {
  DistributedModeRoutingModule
} from './distributed-mode-routing.module';

@NgModule({
  imports: [
    SharedModule,
    DistributedModeRoutingModule
  ],
  declarations: [DistributedModeComponent],
  providers: []
})
export class DistributedModeModule {
}
