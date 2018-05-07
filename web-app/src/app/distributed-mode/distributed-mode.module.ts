import { NgModule } from '@angular/core';
import { DistributedModeComponent } from './distributed-mode.component';
import { SharedModule } from '../shared/shared.module';
import {
  DistributedModeRoutingModule
} from './distributed-mode-routing.module';
import {
  RegisterLoginComponent
} from './register-login/register-login.component';
import {
  DistributedModeNetworkService
} from './distributed-mode-network.service';

@NgModule({
  imports: [
    SharedModule,
    DistributedModeRoutingModule
  ],
  declarations: [DistributedModeComponent, RegisterLoginComponent],
  providers: [DistributedModeNetworkService]
})
export class DistributedModeModule {
}
