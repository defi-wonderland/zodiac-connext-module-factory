// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Sphinx} from '@sphinx-labs/plugins/Sphinx.sol';
import {Test} from 'forge-std/Test.sol';
import {ConnextModuleFactory} from 'contracts/ConnextModuleFactory.sol';
import {ConnextModule} from '@gnosis.pm/zodiac-module-connext/contracts/ConnextModule.sol';

contract UnitDeploy is Sphinx, Test {
  function testCanDeploy() public {
    _testDeployment('sphinx/deploy.config.ts');
  }

  function testCanDeployInOptimism() public {
    _testDeployment('sphinx/deploy-optimism.config.ts');
  }

  function _testDeployment(string memory _configPath) internal {
    // deploys the contracts in the project
    deploy(_configPath, vm.rpcUrl('anvil'));

    // assert that the ConnextModuleFactory was deployed correctly
    ConnextModuleFactory _deployedFactory = ConnextModuleFactory(getAddress(_configPath, 'ConnextModuleFactory'));
    assertNotEq(address(_deployedFactory.SAFE_FACTORY()), address(0), 'ConnextModuleFactory deployment failed');

    // assert that the ConnextModule was deployed correctly
    ConnextModule _deployedModule = ConnextModule(getAddress(_configPath, 'ConnextModule'));
    assertNotEq(address(_deployedModule.connext()), address(0), 'ConnextModule deployment failed');
  }
}
