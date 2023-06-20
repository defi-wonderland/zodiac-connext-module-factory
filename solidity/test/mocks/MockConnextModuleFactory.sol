pragma solidity >=0.8.4 <0.9.0;

import {GnosisSafe} from '@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol';
import {ConnextModuleFactory} from 'contracts/ConnextModuleFactory.sol';
import {ConnextModule} from 'interfaces/IConnextModuleFactory.sol';

contract MockConnextModuleFactory is ConnextModuleFactory {
  constructor(address _safeFactory) ConnextModuleFactory(_safeFactory) {}

  function mock_FACTORY_ADDRESS() external view returns (address) {
    return _FACTORY_ADDRESS;
  }

  function mock_createSafeAndModule(
    SafeData memory _safeData,
    ModuleData memory _moduleData,
    bytes memory _safeTransactionData
  ) external returns (ConnextModule _connextModule, GnosisSafe _safe, bytes memory _returnData) {
    return _createSafeAndModule(_safeData, _moduleData, _safeTransactionData);
  }
}
