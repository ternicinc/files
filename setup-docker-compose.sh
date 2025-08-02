#!/bin/bash
set -e

cat > docker-compose.yml <<EOF
version: '3.8'

services:
  yourcoin-node:
    image: yourcoin-node:latest
    container_name: yourcoin-node
    ports:
      - "9333:9333"  # P2P port
      - "9332:9332"  # RPC port
    volumes:
      - ./data:/root/.yourcoin  # persist blockchain data
    restart: unless-stopped
    command: ["./yourcoind", "-printtoconsole", "-rpcallowip=::/0"]

# Add other services here if needed (e.g., explorer, wallet)
EOF

echo "docker-compose.yml created!"

echo "You can start your node with:"
echo "docker-compose up -d"
