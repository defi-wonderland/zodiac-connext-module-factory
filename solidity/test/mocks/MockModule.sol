pragma solidity >=0.8.4 <0.9.0;

import {Module} from '@gnosis.pm/zodiac/contracts/core/Module.sol';

contract MockModule is Module {
  constructor(address _owner, address _avatar, address _target) {
    bytes memory _initializeParams = abi.encode(_owner, _avatar, _target);
    setUp(_initializeParams);
  }

  function setUp(bytes memory _initializeParams) public override initializer {
    __Ownable_init();
    (address _owner, address _avatar, address _target) = abi.decode(_initializeParams, (address, address, address));

    setAvatar(_avatar);
    setTarget(_target);
    transferOwnership(_owner);
  }
}
