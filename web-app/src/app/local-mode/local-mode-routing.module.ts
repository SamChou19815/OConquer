import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LocalModeComponent } from './local-mode.component';

const routes: Routes = [
  { path: '', component: LocalModeComponent }
];

@NgModule({
  imports: [
    RouterModule.forChild(routes)
  ],
  exports: [RouterModule],
  declarations: []
})
export class LocalModeRoutingModule {
}
