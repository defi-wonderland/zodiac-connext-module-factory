// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import {ConnextModule} from '@gnosis.pm/zodiac-module-connext/contracts/ConnextModule.sol';
import {IXReceiver} from '@gnosis.pm/zodiac-module-connext/contracts/interfaces/IXReceiver.sol';
import {GnosisSafe} from '@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol';
import {GnosisSafeProxyFactory} from '@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol';

interface IConnextModuleFactory is IXReceiver {
  /*///////////////////////////////////////////////////////////////
                            STRUCTS
    //////////////////////////////////////////////////////////////*/

  struct ModuleData {
    address originSender;
    uint32 origin;
    address connext;
    uint256 saltNonce;
  }

  struct SafeData {
    address singleton;
    address[] owners;
    uint256 threshold;
    uint256 saltNonce;
  }

  /*///////////////////////////////////////////////////////////////
                            ERRORS
    //////////////////////////////////////////////////////////////*/

  // @notice Thrown when amount is sent to the XReceive function
  error xReceive_NotAmountAllowed();

  /*///////////////////////////////////////////////////////////////
                            VARIABLES
    //////////////////////////////////////////////////////////////*/

  /**
   * @notice Returns the Safe Factory
   * @return _safeFactory The Safe Factory
   */
  function SAFE_FACTORY() external view returns (GnosisSafeProxyFactory _safeFactory);

  /*///////////////////////////////////////////////////////////////
                              LOGIC
    //////////////////////////////////////////////////////////////*/

  /**
   * @notice Creates a Connext module
   * @return _connextModule The Connext module created
   */
  function createModule(
    ModuleData calldata _moduleData,
    GnosisSafe _safe
  ) external returns (ConnextModule _connextModule);

  /**
   * @dev Receives xCalls from Connext to create the factory and module.
   * @param _callData Encoded SafeData, ModuleData, bytes
   * @return _returnData Returns the transaction return data the call was successful.
   */
  function xReceive(
    bytes32,
    uint256,
    address,
    address,
    uint32,
    bytes memory _callData
  ) external override returns (bytes memory _returnData);
}
