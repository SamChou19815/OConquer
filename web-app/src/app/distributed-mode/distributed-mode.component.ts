import { Component, OnInit } from '@angular/core';
import {
  DistributedModeNetworkService
} from './distributed-mode-network.service';
import { el } from '@angular/platform-browser/testing/src/browser_util';

@Component({
  selector: 'app-distributed-mode',
  templateUrl: './distributed-mode.component.html',
  styleUrls: ['./distributed-mode.component.css']
})
export class DistributedModeComponent implements OnInit {

  /**
   * Host for the remote server.
   */
  host: string;
  /**
   * Identity token of the user.
   */
  token: string;
  /**
   * A flag to record whether the user specified remote server host works.
   * @type {boolean}
   */
  remoteServerWorks = false;
  /**
   * A flag to record whether the user has logged in.
   * @type {boolean}
   */
  loggedIn = false;
  /**
   * A flag to record whether the user is in query mode.
   * @type {boolean}
   */
  inQueryMode = false;

  /**
   * Construct itself from supporting services.
   *
   * @param {LocalModeNetworkService} networkService the network service.
   */
  constructor(private networkService: DistributedModeNetworkService) {
  }

  ngOnInit() {
    this.networkService.echo('localhost', console.log);
  }

  /**
   * Handle when the user chooses his remote server.
   */
  chooseRemoteServer() {
    this.networkService.echo(this.host, doesWork => {
      if (doesWork) {
        this.remoteServerWorks = true;
      } else {
        alert('This remote server address does not work!');
      }
    });
  }

  /**
   * Handle the register/login request.
   *
   * @param {[boolean , string]} request the request tuple.
   */
  registerOrLogin(request: [boolean, string, string]) {
    const isRegister = request[0];
    const username = request[1];
    const password = request[2];
    if (isRegister) {
      this.networkService.register(this.host, username, password,
        tokenOpt => {
          if (tokenOpt === null) {
            alert('This username is already used.');
          }
          this.token = tokenOpt;
        });
    } else {
      this.networkService.login(this.host, username, password,
        tokenOpt => {
          if (tokenOpt === null) {
            alert('Wrong username-password combination!');
          }
          this.token = tokenOpt;
        });
    }
  }

  /**
   * Handle when the program gets submitted.
   *
   * @param {[string]} programs a tuple of black and white programs.
   */
  programSubmitted(programs: [string, string]): void {
    const blackProgram = programs[0], whiteProgram = programs[1];
    this.networkService.submitPrograms(this.host, this.token,
      blackProgram, whiteProgram, isSuccessful => {
        if (isSuccessful) {
          this.inQueryMode = true;
          // this.makeQuery();
        } else {
          this.inQueryMode = false;
          alert('Your code does not compile!');
        }
      });
  }

}
