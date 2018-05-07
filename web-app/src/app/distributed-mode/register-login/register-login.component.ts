import { Component, EventEmitter, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-register-login',
  templateUrl: './register-login.component.html',
  styleUrls: ['./register-login.component.css']
})
export class RegisterLoginComponent implements OnInit {

  username: string;
  password: string;
  @Output() submitted = new EventEmitter<[boolean, string, string]>();

  constructor() {
  }

  ngOnInit() {
  }

  get submitDisabled() {
    return this.username === null || this.username === undefined
      || this.password === null || this.password === undefined;
  }

  /**
   * Submit the register/login request.
   *
   * @param {boolean} isRegister whether the request is about register.
   */
  submit(isRegister: boolean): void {
    if (this.submitDisabled) {
      return;
    }
    this.submitted.emit([isRegister, this.username, this.password]);
  }

}
