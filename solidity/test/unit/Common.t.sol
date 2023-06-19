// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import {DSTestFull} from 'test/utils/DSTestFull.sol';

import {GnosisSafe} from '@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol';
import {GnosisSafeProxyFactory} from '@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol';

import {MockConnextModuleFactory} from 'test/mocks/MockConnextModuleFactory.sol';

contract CommonUnitBase is DSTestFull {
  address internal _user = _label('user');
  address internal _randomUser = _label('randomUser');
  address internal _owner = _label('owner');

  address internal _safeMastercopy;
  GnosisSafeProxyFactory internal _safeFactory;
  MockConnextModuleFactory internal _connextModuleFactory;

  function setUp() public {
    _safeFactory = new GnosisSafeProxyFactory();
    _safeMastercopy = address(new GnosisSafe());

    vm.prank(_owner);
    _connextModuleFactory = new MockConnextModuleFactory(address(_safeFactory));
  }
}
