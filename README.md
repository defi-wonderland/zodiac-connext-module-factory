# Connext Module Factory

The `ConnextModuleFactory` is designed to streamline the process of creating a [GnosisSafe 1.3.0](https://github.com/safe-global/safe-contracts/tree/v1.3.0) contract, deploying a [ConnextModule](https://github.com/gnosis/zodiac-module-connext), adding it into the safe, and executing transactions after that, all in one [XCall](https://docs.connext.network). By using this Factory, users can conveniently execute transactions with ease and efficiency.

It serves as a crucial component in the [Cross-chain Governance Widget](https://github.com/defi-wonderland/crosschain-widget), facilitating the creation of new Safes.

## Key Features

- Create a 1.3.0 `GnosisSafe` contract
- Deploy a Connext Module
- Add the module to the `GnosisSafe`
- Execute transactions seamlessly within the safe

By leveraging the Connext Module Factory, users can conveniently perform atomic operations, the Factory encapsulates all the complex steps involved eliminating the need for multiple transactions and reducing complexity.

---

## Setup

1. Install Foundry by following the instructions from [their repository](https://github.com/foundry-rs/foundry#installation).
2. Copy the `.env.example` file to `.env` and fill in the variables
3. Install the dependencies by running : `yarn install`

## Build

The default way to build the code is suboptimal but fast, you can run it via:

```bash
yarn build
```

In order to build a more optimized code ([via IR](https://docs.soliditylang.org/en/v0.8.15/ir-breaking-changes.html#solidity-ir-based-codegen-changes)), run:

```bash
yarn build:optimized
```

## Running tests

In order to run both unit and E2E tests, run:

```bash
yarn test
```

In order to just run unit tests, run:

```bash
yarn test:unit
```

In order to run unit tests and run way more fuzzing than usual (5x), run:

```bash
yarn test:unit:deep
```

In order to just run e2e tests, run:

```bash
yarn test:e2e
```

In order to check your current code coverage, run:

```bash
yarn coverage
```

In order to create a coverage report, run:

```bash
yarn report
```

## Deploy & verify

### Setup

Configure the `.env` variables.

### Deploy

To deploy the Factory on different networks, use the following command, replacing `<script name>` with the desired network:

```bash
yarn deploy:<script name>
```

List of networks:

| Network      | Script Name |
| ------------ | ----------- |
| Mainnet      | mainnet     |
| Goerli       | goerli      |
| Optimism     | optimism    |
| Polygon      | polygon     |
| Arbitrum     | arbitrum    |
| BNB Chain    | bnb         |
| Gnosis Chain | gnosis      |

The local deployments are stored in ./broadcast

## Deployments

| Network      | Address                                    |
| ------------ | ------------------------------------------ |
| Mainnet      | 0x614F9Ffe9C7EaA5F5BE877F47217Cf77C3D142d3 |
| Goerli       | 0x614F9Ffe9C7EaA5F5BE877F47217Cf77C3D142d3 |
| Optimism     | 0x614F9Ffe9C7EaA5F5BE877F47217Cf77C3D142d3 |
| Polygon      | 0x614F9Ffe9C7EaA5F5BE877F47217Cf77C3D142d3 |
| Arbitrum     | 0x614F9Ffe9C7EaA5F5BE877F47217Cf77C3D142d3 |
| BNB Chain    | 0x614F9Ffe9C7EaA5F5BE877F47217Cf77C3D142d3 |
| Gnosis Chain | 0x614F9Ffe9C7EaA5F5BE877F47217Cf77C3D142d3 |

## Repository

```
~~ Structure ~~
├── solidity: All our contracts and interfaces are here
│   ├─── contracts/: All the contracts
│   │    ├─── ConnextModuleFactory.sol : Can setup a new Safe, module and execute transactions from Connext
│   ├─── interfaces/: The interfaces of all the contracts (SAME STRUCTURE WITH CONTRACTS)
│   ├─── scripts/: All our scripts to deploy the factory and ConnextModule
│   ├─── tests/: All our tests for the contracts
│   │    ├─── e2e/: ...
│   │    ├─── unit/: ...
│   │    ├─── mocks/: Mock contracts
├── README.md
```
