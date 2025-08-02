#!/bin/bash
set -e

# === CONFIG ===
COIN_DIR="$HOME/ohnero"   # Change to your fork name
LITECOIN_REPO="https://github.com/litecoin-project/litecoin.git"
GENESIS_REPO="https://github.com/lhartikk/GenesisH0.git"

echo "=== Cloning Litecoin source ==="
git clone $LITECOIN_REPO $COIN_DIR
cd $COIN_DIR

echo "=== Bootstrapping build system ==="
./autogen.sh

echo "=== Configuring build ==="
./configure --with-incompatible-bdb

echo "=== Building Litecoin (may take a while) ==="
make -j$(nproc)

echo "=== Litecoin build complete ==="
echo "Binaries will be in $COIN_DIR/src"

# === Clone GenesisH0 for Genesis Block Generation ===
echo "=== Cloning GenesisH0 ==="
cd $HOME
git clone $GENESIS_REPO
cd GenesisH0

echo "=== Setting up Python environment for GenesisH0 ==="
# Install pip for Python 2 if missing
if ! command -v pip2 &>/dev/null; then
    echo "Installing pip for Python 2..."
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
    sudo python2 get-pip.py
fi

# Install scrypt compatible with Python 2
pip2 install scrypt==0.8.13 construct==2.5.2

echo "=== GenesisH0 ready ==="
echo "To generate your genesis block, run:"
echo "cd $HOME/GenesisH0"
echo "python2 genesis.py -a scrypt -z \"Your news headline\" 2>&1 | tee main.txt"
