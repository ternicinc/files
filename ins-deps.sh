#!/bin/bash
set -e

echo "=== Updating system ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing build essentials ==="
sudo apt install -y build-essential automake libtool pkg-config git curl

echo "=== Installing crypto libraries ==="
sudo apt install -y libssl-dev libevent-dev

echo "=== Installing Boost ==="
sudo apt install -y libboost-all-dev

echo "=== Adding Bitcoin PPA for Berkeley DB 4.8 ==="
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt update
sudo apt install -y libdb4.8-dev libdb4.8++-dev

echo "=== Installing Qt5 for GUI wallet (optional) ==="
sudo apt install -y qtbase5-dev qttools5-dev-tools libqt5gui5 libqt5core5a

echo "=== Installing extra dependencies ==="
sudo apt install -y libminiupnpc-dev libzmq3-dev

echo "=== Installing Python for Genesis script ==="
sudo apt install -y python2 python2-dev python3 python3-pip

echo "=== Done! ==="
echo "You can now clone your fork and build with:"
echo "./autogen.sh && ./configure --with-incompatible-bdb && make -j\$(nproc)"
