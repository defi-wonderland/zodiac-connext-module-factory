import { UserSphinxConfig } from '@sphinx-labs/core';

const config: UserSphinxConfig = {
  projectName: 'Connext Module Factory',

  options: {
    orgId: 'cll3jere80001li08dkmk1sre',
    testnets: ['optimism-goerli'],
    mainnets: ['optimism'],
    owners: ['0xDBb4FfF430B4413F37F26024d7c63a4471c57878'],
    threshold: 1,
    proposers: ['0xDBb4FfF430B4413F37F26024d7c63a4471c57878'],
  },
  
  contracts: {
    ConnextModuleFactory: {
      contract: 'ConnextModuleFactory',
      kind: 'immutable',
      constructorArgs: {
        _safeFactory: '0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC',
      },
    },
    ConnextModule: {
      contract: 'ConnextModule',
      kind: 'immutable',
      constructorArgs: {
        _owner: '0x0000000000000000000000000000000000000001',
        _avatar: '0x0000000000000000000000000000000000000001',
        _target: '0x0000000000000000000000000000000000000001',
        _originSender: '0x0000000000000000000000000000000000000001',
        _origin: 1,
        _connext: '0x0000000000000000000000000000000000000001'
      },
    },
  },
}

export default config;
