// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import {DSTestFull} from 'test/utils/DSTestFull.sol';

import {MockConnextModuleFactory} from 'test/mocks/MockConnextModuleFactory.sol';

contract CommonE2EBase is DSTestFull {
  uint256 internal constant _FORK_BLOCK = 17_282_327;

  address internal _user = _label('user');
  address internal _randomUser = _label('randomUser');
  address internal _owner = _label('owner');

  address internal _safeFactory = 0xa6B71E26C5e0845f74c812102Ca7114b6a896AB2;
  address internal _safeMastercopy = 0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552;

  address internal _connextInEth = 0x8898B472C54c31894e3B9bb83cEA802a5d0e63C6;

  address internal _daiToken = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

  MockConnextModuleFactory internal _connextModuleFactory;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), _FORK_BLOCK);
    vm.prank(_owner);
    _connextModuleFactory = new MockConnextModuleFactory(_safeFactory);
  }
}
