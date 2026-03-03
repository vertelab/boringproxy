#!/bin/bash

# --- Argument Parsing ---
CLIENT_NAME=$(hostname) # Default name is the machine's hostname

while getopts "d:t:n:" opt; do
  case $opt in
    d) SERVER_DOMAIN="$OPTARG" ;;
    t) TOKEN="$OPTARG" ;;
    n) CLIENT_NAME="$OPTARG" ;;
    *) echo "Usage: $0 -d <domain> -t <token> [-n <client-name>]"; exit 1 ;;
  esac
done

# Check mandatory fields
if [ -z "$SERVER_DOMAIN" ] || [ -z "$TOKEN" ]; then
    echo "Error: Server domain (-d) and Token (-t) are mandatory."
    echo "Usage: $0 -d your-domain.com -t your_token_here [-n custom-name]"
    exit 1
fi

BP_BINARY="/usr/local/bin/boringproxy"

sudo curl -L https://github.com/boringproxy/boringproxy/releases/latest/download/boringproxy-linux-x86_64 -o "$BP_BINARY"
sudo chmod +x "$BP_BINARY"

# --- System Setup ---
if ! id "boringproxy" &>/dev/null; then
    sudo useradd -r -m -s /bin/false boringproxy
fi

# --- Write Service File ---
# Note: Using double backslashes for the systemd multi-line command
sudo bash -c "cat <<EOF > /etc/systemd/system/boringproxy-client.service
[Unit]
Description=BoringProxy Client ($CLIENT_NAME)
After=network.target

[Service]
User=boringproxy
Group=boringproxy
WorkingDirectory=/home/boringproxy
ExecStart=$BP_BINARY client \\
  -server $SERVER_DOMAIN \\
  -token $TOKEN \\
  -client-name $CLIENT_NAME \\
  -user admin
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload
sudo systemctl enable boringproxy-client
sudo systemctl restart boringproxy-client

echo "SUCCESS: BoringProxy Client '$CLIENT_NAME' connected to $SERVER_DOMAIN"