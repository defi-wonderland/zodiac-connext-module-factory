// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import {Script} from 'forge-std/Script.sol';

import {ConnextModule} from '@gnosis.pm/zodiac-module-connext/contracts/ConnextModule.sol';
import {ConnextModuleFactory} from 'contracts/ConnextModuleFactory.sol';

// This is used to just verify the ConnextModule contract on etherscan for
// different chains, needed by the Zodiac Safe App to recognise the contract

contract DeployModule is Script {
  function run() external {
    vm.startBroadcast();
    new ConnextModule(address(1), address(1), address(1), address(1), uint32(1), address(1));
    vm.stopBroadcast();
  }
}
