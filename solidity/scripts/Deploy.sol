// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import {Script} from 'forge-std/Script.sol';

import {ConnextModuleFactory} from 'contracts/ConnextModuleFactory.sol';

abstract contract Deploy is Script {
  function _deploy(address _safeFactory) internal {
    vm.startBroadcast();
    new ConnextModuleFactory(_safeFactory);
    vm.stopBroadcast();
  }
}

contract DeployGoerli is Deploy {
  address constant _GOERLI_SAFE_FACTORY = 0xa6B71E26C5e0845f74c812102Ca7114b6a896AB2;

  function run() external {
    _deploy(_GOERLI_SAFE_FACTORY);
  }
}

contract DeployOptimism is Deploy {
  address constant _OPTIMISM_SAFE_FACTORY = 0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC;

  function run() external {
    _deploy(_OPTIMISM_SAFE_FACTORY);
  }
}
