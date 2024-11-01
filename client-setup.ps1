#!/bin/bash

# Check for parameters
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 SERVER_IP KEY_PATH"
    exit 1
fi

SERVER_IP=$1
KEY_PATH=$2

# Setup SSH key permissions
chmod 600 "$KEY_PATH"

# Create SSH config
mkdir -p ~/.ssh
cat > ~/.ssh/config << EOL
Host tunnel-vpn
    HostName $SERVER_IP
    User vpnuser
    IdentityFile $KEY_PATH
EOL

chmod 600 ~/.ssh/config

# Function to setup MacOS proxy
setup_macos_proxy() {
    networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 8080
    networksetup -setsocksfirewallproxystate Wi-Fi on
    echo "MacOS SOCKS proxy configured"
}

# Setup proxy based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    setup_macos_proxy
fi

# Start SSH tunnel
echo "Starting SSH tunnel..."
ssh -D 8080 -C -q -N -i "$KEY_PATH" "vpnuser@$SERVER_IP"
