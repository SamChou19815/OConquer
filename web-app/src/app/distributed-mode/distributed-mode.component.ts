import { Component, OnInit } from '@angular/core';
import {
  DistributedModeNetworkService
} from './distributed-mode-network.service';

@Component({
  selector: 'app-distributed-mode',
  templateUrl: './distributed-mode.component.html',
  styleUrls: ['./distributed-mode.component.css']
})
export class DistributedModeComponent implements OnInit {

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
   * Handle the register/login request.
   *
   * @param {[boolean , string]} request the request tuple.
   */
  registerOrLogin(request: [boolean, string, string]) {
    const isRegister = request[0];
    const username = request[1];
    const password = request[2];
    console.log(isRegister);
    console.log(username + ' ' + password);
  }

}
