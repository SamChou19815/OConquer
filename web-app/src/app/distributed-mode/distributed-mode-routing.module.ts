import { NgModule } from '@angular/core';
import { DistributedModeComponent } from './distributed-mode.component';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  { path: '', component: DistributedModeComponent }
];

@NgModule({
  imports: [
    RouterModule.forChild(routes)
  ],
  exports: [RouterModule],
  declarations: []
})
export class DistributedModeRoutingModule {
}
