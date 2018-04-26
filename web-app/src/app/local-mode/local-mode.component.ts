import {Component, OnInit} from '@angular/core';

@Component({
  selector: 'app-local-mode',
  templateUrl: './local-mode.component.html',
  styleUrls: ['./local-mode.component.css']
})
export class LocalModeComponent implements OnInit {

  constructor() {
  }

  ngOnInit() {
  }

  programSubmitted(programs: [string, string]): void {
    alert(`Submitted!
    Black: ${programs[0]}
    White: ${programs[1]}`);
  }

}
