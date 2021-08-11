#!/usr/bin/env bash
set -e

while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
    esac
done

echo $version

./build.sh -c ./config/prod.json

rm -rf ./package
mkdir -p package

echo "{
  \"name\": \"@maplelabs/liquidity-locker\",
  \"version\": \"${version}\",
  \"description\": \"Liquidity Locker Artifacts and ABIs\",
  \"author\": \"Maple Labs\",
  \"license\": \"AGPLv3\",
  \"repository\": {
    \"type\": \"git\",
    \"url\": \"https://github.com/maple-labs/liquidity-locker.git\"
  },
  \"bugs\": {
    \"url\": \"https://github.com/maple-labs/liquidity-locker/issues\"
  },
  \"homepage\": \"https://github.com/maple-labs/liquidity-locker\"
}" > package/package.json

mkdir -p package/artifacts
mkdir -p package/abis

cat ./out/dapp.sol.json | jq '.contracts | ."contracts/LiquidityLockerFactory.sol" | .LiquidityLockerFactory' > package/artifacts/LiquidityLockerFactory.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/LiquidityLockerFactory.sol" | .LiquidityLockerFactory | .abi' > package/abis/LiquidityLockerFactory.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/LiquidityLocker.sol" | .LiquidityLocker' > package/artifacts/LiquidityLocker.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/LiquidityLocker.sol" | .LiquidityLocker | .abi' > package/abis/LiquidityLocker.json

npm publish ./package --access public

rm -rf ./package
