import { Component, EventEmitter, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-local-mode-programs-input',
  templateUrl: './programs-input.component.html',
  styleUrls: ['./programs-input.component.css']
})
export class ProgramsInputComponent implements OnInit {

  blackProgram: string;
  whiteProgram: string;
  @Output() submitted = new EventEmitter<[string, string]>();

  constructor() {
  }

  ngOnInit() {
  }

  get submitDisabled() {
    if (this.blackProgram === null || this.blackProgram === undefined
      || this.whiteProgram === null || this.whiteProgram === undefined) {
      return true;
    } else if (this.blackProgram.includes('System.in')
      || this.blackProgram.includes('System.out')
      || this.whiteProgram.includes('System.in')
      || this.whiteProgram.includes('System.out')) {
      return true;
    }
    return false;
  }

  submit(): void {
    if (this.submitDisabled) {
      return;
    }
    this.submitted.emit([this.blackProgram, this.whiteProgram]);
  }

}
