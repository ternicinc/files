#!/bin/bash
set -e

cd ~/GenesisH0

echo "Running genesis block generation..."
python2 genesis.py -a scrypt -z "$1" 2>&1 | tee main.txt

echo "Parsing main.txt and updating chainparams.cpp..."

GENESIS_HASH=$(grep "genesis hash" main.txt | awk '{print $NF}')
MERKLE_HASH=$(grep "merkle hash" main.txt | awk '{print $NF}')
NONCE=$(grep "nonce" main.txt | awk '{print $NF}')
TIME=$(grep "time" main.txt | awk '{print $NF}')

cd ~/mycoin
sed -i "s/genesis.nTime = [0-9]*/genesis.nTime = $TIME/g" src/chainparams.cpp
sed -i "s/genesis.nNonce = [0-9]*/genesis.nNonce = $NONCE/g" src/chainparams.cpp
sed -i "s/genesis.hashMerkleRoot = uint256S(\"[a-f0-9]*\")/genesis.hashMerkleRoot = uint256S(\"$MERKLE_HASH\")/g" src/chainparams.cpp
sed -i "s/assert(genesis.GetHash() == uint256S(\"[a-f0-9]*\"))/assert(genesis.GetHash() == uint256S(\"$GENESIS_HASH\"))/g" src/chainparams.cpp

echo "Done! Please rebuild your project."
