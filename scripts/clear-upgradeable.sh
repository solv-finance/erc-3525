#!/usr/bin/env bash

npx hardhat clean

cd contracts
rm -f *Upgradeable.sol
find . -name *Upgradeable.sol | xargs rm -f 
rm -f Initializable.sol
rm -f mocks/ERC3525BaseMockUpgradeableWithInit.sol
cd ..