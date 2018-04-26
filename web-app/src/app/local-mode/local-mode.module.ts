import { NgModule } from '@angular/core';
import { LocalModeComponent } from './local-mode.component';
import { LocalModeRoutingModule } from './local-mode-routing.module';
import { SharedModule } from '../shared/shared.module';
import {
  LocalModeProgramsInputComponent
} from './local-mode-programs-input/local-mode-programs-input.component';
import { LocalModeNetworkService } from './local-mode-network.service';

@NgModule({
  imports: [
    SharedModule,
    LocalModeRoutingModule
  ],
  declarations: [LocalModeComponent, LocalModeProgramsInputComponent],
  providers: [LocalModeNetworkService]
})
export class LocalModeModule {
}
