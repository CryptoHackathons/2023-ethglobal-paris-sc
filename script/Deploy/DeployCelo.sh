#!/bin/bash

# export CHAIN_ID=44787
export RPC_URL="https://alfajores-forno.celo-testnet.org"
# export VERIFIER_URL=""
# export ETHERSCAN_API_KEY=
# export PRIVATE_KEY=

forge script script/Lottery2.s.sol \
  --rpc-url=$RPC_URL \
  --broadcast \
  --sender=0xF16Aa7E201651e7eAd5fDd010a5a14589E220826 \
  --private-key=$PRIVATE_KEY \
  --verify