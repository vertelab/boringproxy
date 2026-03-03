#!/bin/bash

# --- Argument Parsing ---
GATEWAY_PORTS=false

while getopts "d:g" opt; do
  case $opt in
    d) ADMIN_DOMAIN="$OPTARG" ;;
    g) GATEWAY_PORTS=true ;;
    *) echo "Usage: $0 -d <admin-domain> [-g]"; exit 1 ;;
  esac
done

if [ -z "$ADMIN_DOMAIN" ]; then
    echo "Error: Admin domain (-d) is mandatory."
    echo "Usage: $0 -d your-domain.com [-g]"
    exit 1
fi

BP_BINARY="/usr/local/bin/boringproxy"

sudo curl -L https://github.com/boringproxy/boringproxy/releases/latest/download/boringproxy-linux-x86_64 -o "$BP_BINARY"
sudo chmod +x "$BP_BINARY"

# --- Optional: SSH GatewayPorts Config ---
if [ "$GATEWAY_PORTS" = true ]; then
    echo "Configuring SSH GatewayPorts..."
    # Check if GatewayPorts exists. If yes, change it. If no, append it.
    if grep -q "^#\?GatewayPorts" /etc/ssh/sshd_config; then
        sudo sed -i 's/^#\?GatewayPorts.*/GatewayPorts clientspecified/' /etc/ssh/sshd_config
    else
        echo "GatewayPorts clientspecified" | sudo tee -a /etc/ssh/sshd_config
    fi
    sudo systemctl restart ssh
    echo "SSH GatewayPorts set to 'clientspecified' and SSH restarted."
fi

# --- System Setup ---
if ! id "boringproxy" &>/dev/null; then
    sudo useradd -r -m -s /bin/false boringproxy
fi

sudo setcap cap_net_bind_service=+ep "$BP_BINARY"

# --- Write Service File ---
sudo bash -c "cat <<EOF > /etc/systemd/system/boringproxy-server.service
[Unit]
Description=BoringProxy Server
After=network.target

[Service]
User=boringproxy
Group=boringproxy
WorkingDirectory=/home/boringproxy
ExecStart=$BP_BINARY server -admin-domain $ADMIN_DOMAIN
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload
sudo systemctl enable boringproxy-server
sudo systemctl restart boringproxy-server

echo "SUCCESS: BoringProxy Server is running on $ADMIN_DOMAIN"