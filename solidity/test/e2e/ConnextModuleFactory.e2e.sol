// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import {IERC20} from 'isolmate/interfaces/tokens/IERC20.sol';
import {ConnextModuleFactory} from 'contracts/ConnextModuleFactory.sol';
import {IConnextModuleFactory, ConnextModule} from 'interfaces/IConnextModuleFactory.sol';

import {GnosisSafe} from '@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol';
import {
  GnosisSafeProxy,
  GnosisSafeProxyFactory
} from '@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol';

import {Enum} from '@gnosis.pm/safe-contracts/contracts/common/Enum.sol';

import {CommonE2EBase} from 'test/e2e/Common.e2e.sol';

// import {console} from 'forge-std/console.sol';

contract E2EConnextModuleFactoryBase is CommonE2EBase {
  uint32 _origin = 6_648_936;

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
    _moduleData.connext = _connextInEth;
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

contract E2EConnextModuleFactory_Constructor is E2EConnextModuleFactoryBase {
  function test_checkConstructorArguments() public {
    assertEq(address(_connextModuleFactory.SAFE_FACTORY()), _safeFactory, 'Incorrect Safe Factory');
    assertEq(_connextModuleFactory.mock_FACTORY_ADDRESS(), address(_connextModuleFactory), 'Incorrect FACTORY_ADDRESS');
  }
}

contract E2EConnextModuleFactory_xReceive is E2EConnextModuleFactoryBase {
  function test_shouldNotRevert() public {
    (
      IConnextModuleFactory.SafeData memory _safeData,
      IConnextModuleFactory.ModuleData memory _moduleData,
      bytes memory _safeTransactionData
    ) = getCallData();

    bytes memory _callData = abi.encode(_safeData, _moduleData, _safeTransactionData);

    vm.prank(_user);
    (bytes memory _returnData) = _connextModuleFactory.xReceive(0, 0, address(0), address(0), 0, _callData);

    emit LogBytes(_returnData);
  }
}

contract E2EConnextModuleFactory_CreateSafeAndModule is E2EConnextModuleFactoryBase {
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
    assertEq(_connextModule.connext(), _connextInEth, 'Incorrect Connext set');

    assertTrue(_safe.isOwner(_user), 'Incorrect Owner set');
    assertTrue(_safe.isOwner(_randomUser), 'Incorrect second Owner set');
    assertEq(_safe.getOwners().length, 2, 'Incorrect number of Owners set');
    assertEq(_safe.getThreshold(), 1, 'Incorrect Threshold set');
  }

  function test_shouldHaveReturnDataAndApprove() public {
    (
      IConnextModuleFactory.SafeData memory _safeData,
      IConnextModuleFactory.ModuleData memory _moduleData,
      bytes memory _safeTransactionData
    ) = getCallData();

    address _spender = _label('spender');
    uint256 _amount = 10_000;

    bytes memory _expectedReturnData = abi.encode(true);

    bytes memory _txCallData = abi.encodeWithSelector(IERC20.approve.selector, _spender, _amount);
    _safeTransactionData = abi.encode(address(_daiToken), uint256(0), _txCallData, Enum.Operation.Call);

    vm.prank(_user);
    (, GnosisSafe _safe, bytes memory _returnData) =
      _connextModuleFactory.mock_createSafeAndModule(_safeData, _moduleData, _safeTransactionData);

    uint256 _allowance = IERC20(_daiToken).allowance(address(_safe), _spender);

    emit LogUint256(_allowance);
    assertEq(_returnData, _expectedReturnData, 'Incorrect returnData');
    assertEq(_allowance, _amount, 'Incorrect allowance');
  }
}
