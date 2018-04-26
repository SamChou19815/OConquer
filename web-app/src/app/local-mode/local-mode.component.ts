import { Component, OnInit } from '@angular/core';
import { LocalModeNetworkService } from './local-mode-network.service';

@Component({
  selector: 'app-local-mode',
  templateUrl: './local-mode.component.html',
  styleUrls: ['./local-mode.component.css']
})
export class LocalModeComponent implements OnInit {

  /**
   * Construct itself from supporting services.
   *
   * @param {LocalModeNetworkService} networkService the network service.
   */
  constructor(private networkService: LocalModeNetworkService) {
  }

  ngOnInit() {
  }

  programSubmitted(programs: [string, string]): void {
    const blackProgram = programs[0], whiteProgram = programs[1];
    this.networkService.startSimulation(blackProgram, whiteProgram,
      isSuccessful => {
        if (isSuccessful) {
          alert(isSuccessful);
        } else {
          alert(isSuccessful);
        }
      });
  }

}
