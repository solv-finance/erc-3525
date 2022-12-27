# ERC-3525 Reference Implementation

**This is reference implementation of [ERC-3525](https://eips.ethereum.org/EIPS/eip-3525).** 

>ERC-3525, proposed by Solv Protocol, is a standard for the Semi-Fungible Token (or SFT) approved by the Ethereum community.
>
>It defines a new type of digital asset characterized by the following key features:
>
>* Unique ID and expressivity of ERC-721 non-fungible tokens. Compatibility with the ERC-721 token standard.
>* It is fractionalizable, combinable, and computable.
>* It can work like an account and nest other digital assets, including ERC-20 fungible tokens and NFTs, with support for token-to-token transfer.
>* Programmable appearance, functionality, lockup, transfer, etc. Metadata is optimized to support dynamic inputs and more complex financial logic.


🧙**Not sure how to get started?** Check out [ERC-3525 Starter Kit: Developer Edition](https://medium.com/solv-blog/erc-3525-starter-kit-developer-edition-9d734ca62bd0) - a step-by-step guide to get you started with the ERC-3525 reference implementation.🚀

## Overview

### Installation

```bash
npm install @solvprotocol/erc-3525@latest
```

### Usage
Once installed, you can use the contracts in the library by importing them:

```solidity
pragma solidity ^0.8.9;

import "@solvprotocol/erc-3525/ERC3525.sol";

contract MyERC3525 is ERC3525 {

constructor()
    ERC3525("MyERC3525", "MY3525", 18) {
    }
}
```

To keep your system secure, you should always use the installed code as-is, and neither copy-paste it from online sources nor modify it yourself.

## Learn More

[ERC-3525 White Paper](https://whitepaper.sftlabs.io/SFT%20Whitepaper.pdf)

## Contribute

**Requirements**

- Solidity 0.8
- Hardhat
- Node.js >= 12.10

#### Setup

Run `npm install` in the root directory

#### Unit Tests

Run `npm test` to run the unit tests

#### Transpile
Run `npm run transpile` to transpile the non-upgradable contracts to upgradeable contracts

## License
ERC-3525 Reference Implementation is released under the [MIT License](https://github.com/solv-finance/erc-3525/blob/main/LICENSE).

## Credits
ERC-3525 Reference Implementation power by **[Solv Finance](https://solv.finance)**