#!/usr/bin/env bash

current_dir=$(pwd)
yarn hardhat compile --force
mkdir -p build build/contracts build/contracts/build
cd artifacts/contracts
find . -name "*.json" -exec cp {} ${current_dir}/build/contracts/build \;
cd ${current_dir}/build/contracts/build
rm -f *.dbg.json
cd ${current_dir}
cp -r contracts/* build/contracts/
cp README.md build/contracts/
cp package.json build/contracts/