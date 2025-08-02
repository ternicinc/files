#!/bin/bash
set -e

# === CONFIG ===
OLD_NAME="Litecoin"
OLD_TICKER="LTC"
NEW_NAME="OhNero"              # Change to your coin name
NEW_TICKER="OHN"               # Change to your ticker
COIN_DIR="$HOME/mycoin"        # Path to cloned Litecoin repo
GENESIS_FILE="$HOME/GenesisH0/main.txt"  # Genesis block output file
NEW_P2P_PORT="9333"            # Change this
NEW_RPC_PORT="9332"            # Change this
NEW_MAGIC_HEX="0xa0b1c2d3"     # Must be 4 random bytes

echo "=== Customizing Litecoin fork for $NEW_NAME ==="

cd "$COIN_DIR"

echo "=== Replacing coin name and ticker ==="
grep -rl "$OLD_NAME" . | xargs sed -i "s/$OLD_NAME/$NEW_NAME/g"
grep -rl "$OLD_TICKER" . | xargs sed -i "s/$OLD_TICKER/$NEW_TICKER/g"

echo "=== Updating default ports ==="
# Replace in all .h and .cpp files
grep -rl "9333" . | xargs sed -i "s/9333/$NEW_P2P_PORT/g"
grep -rl "9332" . | xargs sed -i "s/9332/$NEW_RPC_PORT/g"

echo "=== Updating magic bytes ==="
# Replace common magic values (look for pchMessageStart in chainparams.cpp)
sed -i "s/0xfb, 0xc0, 0xb6, 0xdb/$(echo $NEW_MAGIC_HEX | sed 's/0x//g' | sed 's/../0x&, /g')/g" src/chainparams.cpp

echo "=== Inserting Genesis Block values ==="
if [ ! -f "$GENESIS_FILE" ]; then
    echo "Error: Genesis file not found at $GENESIS_FILE"
    echo "Run GenesisH0 first to generate main.txt"
    exit 1
fi

GENESIS_HASH=$(grep "genesis hash" $GENESIS_FILE | awk '{print $NF}')
MERKLE_HASH=$(grep "merkle hash" $GENESIS_FILE | awk '{print $NF}')
NONCE=$(grep "nonce" $GENESIS_FILE | awk '{print $NF}')
TIME=$(grep "time" $GENESIS_FILE | awk '{print $NF}')

sed -i "s/genesis.nTime = [0-9]*/genesis.nTime = $TIME/g" src/chainparams.cpp
sed -i "s/genesis.nNonce = [0-9]*/genesis.nNonce = $NONCE/g" src/chainparams.cpp
sed -i "s/genesis.hashMerkleRoot = uint256S(\"[a-f0-9]*\")/genesis.hashMerkleRoot = uint256S(\"$MERKLE_HASH\")/g" src/chainparams.cpp
sed -i "s/assert\(genesis.GetHash() == uint256S(\"[a-f0-9]*\")\)/assert(genesis.GetHash() == uint256S(\"$GENESIS_HASH\"))/g" src/chainparams.cpp

echo "=== Customization complete ==="
echo "Now rebuild your coin with:"
echo "cd $COIN_DIR && make clean && ./autogen.sh && ./configure --with-incompatible-bdb && make -j\$(nproc)"
echo
echo "Your new coin is: $NEW_NAME ($NEW_TICKER)"
echo "P2P Port: $NEW_P2P_PORT | RPC Port: $NEW_RPC_PORT"
