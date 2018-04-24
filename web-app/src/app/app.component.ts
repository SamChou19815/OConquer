import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  /**
   * All supported nav link.
   */
  navLinks = [
    { path: 'home', label: 'Home' },
    { path: 'local', label: 'Local Mode' },
    { path: 'distributed', label: 'Distributed Mode' }
  ];

}
