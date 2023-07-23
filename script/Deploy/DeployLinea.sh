#!/bin/bash

# export CHAIN_ID=59140
export RPC_URL="https://linea-goerli.infura.io/v3/ae3b481fe2c34ad9a2569ef2f28c29a6"
# export VERIFIER_URL=""
# export ETHERSCAN_API_KEY=
export PRIVATE_KEY=0xa93abd947bbc5c79f7c75dab6f0a3ef30478295d93fc4f5cbdfe3d4b56ac5066

forge script script/Lottery2.s.sol \
  --rpc-url=$RPC_URL \
  --broadcast \
  --sender=0xF16Aa7E201651e7eAd5fDd010a5a14589E220826 \
  --private-key=$PRIVATE_KEY \
  --verify