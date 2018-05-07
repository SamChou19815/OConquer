import { NgModule } from '@angular/core';
import { LocalModeComponent } from './local-mode.component';
import { LocalModeRoutingModule } from './local-mode-routing.module';
import { SharedModule } from '../shared/shared.module';
import { LocalModeNetworkService } from './local-mode-network.service';

@NgModule({
  imports: [
    SharedModule,
    LocalModeRoutingModule
  ],
  declarations: [LocalModeComponent],
  providers: [LocalModeNetworkService]
})
export class LocalModeModule {
}
