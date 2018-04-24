import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', loadChildren: 'app/home/home.module#HomeModule' },
  {
    path: 'local',
    loadChildren: 'app/local-mode/local-mode.module#LocalModeModule'
  },
  {
    path: 'distributed',
    loadChildren:
      'app/distributed-mode/distributed-mode.module#DistributedModeModule'
  }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes)
  ],
  exports: [RouterModule],
  declarations: []
})
export class AppRoutingModule {
}
