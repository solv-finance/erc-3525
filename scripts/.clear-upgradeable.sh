#!/usr/bin/env bash

cd contracts
rm -f *Upgradeable.sol
find . -name *Upgradeable.sol | xargs rm -f 
rm -f Initializable.sol
rm -f mocks/WithInit.sol
cd ..
