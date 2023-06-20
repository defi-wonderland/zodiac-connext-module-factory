// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import {IERC20} from 'isolmate/interfaces/tokens/IERC20.sol';
import {ConnextModuleFactory} from 'contracts/ConnextModuleFactory.sol';
import {IConnextModuleFactory, ConnextModule} from 'interfaces/IConnextModuleFactory.sol';

import {GnosisSafe} from '@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol';
import {Enum} from '@gnosis.pm/safe-contracts/contracts/common/Enum.sol';

import {
  GnosisSafeProxy,
  GnosisSafeProxyFactory
} from '@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol';

import {CommonUnitBase} from 'test/unit/Common.t.sol';

contract UnitConnextModuleFactoryBase is CommonUnitBase {
  uint32 internal _origin = 6_648_936;
  address internal _connext = _label('connext');
  IERC20 internal _fakeWeth = IERC20(_mockContract('token'));

  function getCallData()
    public
    view
    returns (
      IConnextModuleFactory.SafeData memory _safeData,
      IConnextModuleFactory.ModuleData memory _moduleData,
      bytes memory _safeTransactionData
    )
  {
    _moduleData.originSender = _user;
    _moduleData.origin = _origin;
    _moduleData.connext = _connext;
    _moduleData.saltNonce = uint256(1);

    _safeData.singleton = _safeMastercopy;
    _safeData.owners = new address[](2);
    _safeData.owners[0] = _user;
    _safeData.owners[1] = _randomUser;
    _safeData.threshold = 1;
    _safeData.saltNonce = 1;

    _safeTransactionData = bytes('');
  }
}

contract UnitConnextModuleFactory_Constructor is UnitConnextModuleFactoryBase {
  function test_checkConstructorArguments() public {
    assertEq(address(_connextModuleFactory.SAFE_FACTORY()), address(_safeFactory), 'Incorrect Safe Factory');
    assertEq(_connextModuleFactory.mock_FACTORY_ADDRESS(), address(_connextModuleFactory), 'Incorrect FACTORY_ADDRESS');
  }
}

contract UnitConnextModuleFactory_CreateModule is UnitConnextModuleFactoryBase {
  function test_createModule() public {
    GnosisSafe _safe = new GnosisSafe();

    IConnextModuleFactory.ModuleData memory _moduleData;
    _moduleData.originSender = _user;
    _moduleData.origin = _origin;
    _moduleData.connext = address(0);
    _moduleData.saltNonce = uint256(1);

    vm.prank(_user);
    ConnextModule _connextModule = _connextModuleFactory.createModule(_moduleData, _safe);

    assertNotEq(address(_connextModule), address(0), 'Module address is 0x0');
  }
}

contract UnitConnextModuleFactory_xReceive is UnitConnextModuleFactoryBase {
  function test_shouldNotRevert() public {
    (
      IConnextModuleFactory.SafeData memory _safeData,
      IConnextModuleFactory.ModuleData memory _moduleData,
      bytes memory _safeTransactionData
    ) = getCallData();
    bytes memory _callData = abi.encode(_safeData, _moduleData, _safeTransactionData);

    vm.prank(_user);
    _connextModuleFactory.xReceive(0, 0, address(0), address(0), 0, _callData);
  }

  function test_shouldRevertWhenAmount0() public {
    vm.expectRevert(IConnextModuleFactory.xReceive_NotAmountAllowed.selector);
    vm.prank(_user);
    _connextModuleFactory.xReceive(bytes32(0), 1, address(0), address(0), uint32(0), bytes(''));
  }
}

contract UnitConnextModuleFactory_CreateSafeAndModule is UnitConnextModuleFactoryBase {
  function test_shouldNotRevert() public {
    (
      IConnextModuleFactory.SafeData memory _safeData,
      IConnextModuleFactory.ModuleData memory _moduleData,
      bytes memory _safeTransactionData
    ) = getCallData();

    vm.prank(_user);
    _connextModuleFactory.mock_createSafeAndModule(_safeData, _moduleData, _safeTransactionData);
  }

  function test_shouldSetCorrectParameters() public {
    (
      IConnextModuleFactory.SafeData memory _safeData,
      IConnextModuleFactory.ModuleData memory _moduleData,
      bytes memory _safeTransactionData
    ) = getCallData();

    vm.prank(_user);
    (ConnextModule _connextModule, GnosisSafe _safe,) =
      _connextModuleFactory.mock_createSafeAndModule(_safeData, _moduleData, _safeTransactionData);

    assertEq(_connextModule.owner(), address(_safe), 'Incorrect Owner set');
    assertEq(_connextModule.avatar(), address(_safe), 'Incorrect Avatar set');
    assertEq(_connextModule.target(), address(_safe), 'Incorrect Target set');
    assertEq(_connextModule.originSender(), _user, 'Incorrect Origin sender set');
    assertEq(_connextModule.origin(), _origin, 'Incorrect Origin set');
    assertEq(_connextModule.connext(), _connext, 'Incorrect Connext set');

    assertTrue(_safe.isOwner(_user), 'Incorrect Owner set');
    assertTrue(_safe.isOwner(_randomUser), 'Incorrect second Owner set');
    assertEq(_safe.getOwners().length, 2, 'Incorrect number of Owners set');
    assertEq(_safe.getThreshold(), 1, 'Incorrect Threshold set');
  }

  function test_shouldHaveReturnData() public {
    (
      IConnextModuleFactory.SafeData memory _safeData,
      IConnextModuleFactory.ModuleData memory _moduleData,
      bytes memory _safeTransactionData
    ) = getCallData();

    address _spender = _label('spender');
    uint256 _amount = 10_000;

    bytes memory _expectedReturnData = abi.encode('Expected Return Data');
    vm.mockCall(address(_fakeWeth), abi.encodeWithSelector(IERC20.approve.selector), _expectedReturnData);

    bytes memory _txCallData = abi.encodeWithSelector(IERC20.approve.selector, _spender, _amount);
    _safeTransactionData = abi.encode(address(_fakeWeth), uint256(0), _txCallData, Enum.Operation.Call);

    vm.prank(_user);
    (,, bytes memory _returnData) =
      _connextModuleFactory.mock_createSafeAndModule(_safeData, _moduleData, _safeTransactionData);
    assertEq(_returnData, _expectedReturnData, 'Incorrect returnData');
  }
}

contract UnitConnextModuleFactory_EnableModuleFromFactory is UnitConnextModuleFactoryBase {
  function test_shouldRevert() public {
    vm.prank(_user);
    vm.expectRevert();
    _connextModuleFactory.enableModuleFromFactory(address(1));
  }
}
