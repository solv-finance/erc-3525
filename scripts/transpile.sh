#!/usr/bin/env bash

cd contracts
rm -f *Upgradeable.sol
find . -name *Upgradeable.sol|xargs rm -f
rm -f Initializable.sol
rm -f mocks/WithInit.sol
cd ..

set -euo pipefail -x

npm run compile

build_info=($(jq -r '.input.sources | keys | if any(test("^contracts/mocks/.*\\bunreachable\\b")) then empty else input_filename end' artifacts/build-info/*))
build_info_num=${#build_info[@]}

if [ $build_info_num -ne 1 ]; then
  echo "found $build_info_num relevant build info files but expected just 1"
  exit 1
fi

# -D: delete original and excluded files
# -b: use this build info file
# -i: use included Initializable
# -x: exclude all proxy contracts except Clones library
# -p: emit public initializer
#  -i contracts/openzeppelin/proxy/utils/Initializable.sol \
npx @solvprotocol/upgrade-safe-transpiler@latest \
  -b "$build_info" \
  -x 'contracts/proxy/**/*' \
  -x '!contracts/proxy/Clones.sol' \
  -x '!contracts/proxy/ERC1967/ERC1967Storage.sol' \
  -x '!contracts/proxy/ERC1967/ERC1967Upgrade.sol' \
  -x '!contracts/proxy/utils/UUPSUpgradeable.sol' \
  -x '!contracts/proxy/beacon/IBeacon.sol' \
  -p 'contracts/**/presets/**/*'

rm -rf @openzeppelin
rm -f contracts/Initializable.sol
rm -f contracts/mocks/WithInit.sol

node ./scripts/migrate-imports.js
