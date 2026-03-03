# Install

### Server
```curl -sSL https://your-url.com/setup-bp-server.sh | sudo bash -s -- -d <bp.example.com> -g```

### Client 
```curl -sSL https://your-url.com/setup-bp-client.sh | sudo bash -s -- -d <bp.example.com> -t <YOUR_TOKEN> -n <my-laptop>```

# BoringProxy Scripts

Thes scripts setup **boringproxy** as a service.

## 🛠 Server Script: `setup-bp-server.sh`

Run this script on your **VPS** (the machine with the public IP) to host the BoringProxy manager and dashboard.

### Usage
```sudo ./setup-bp-server.sh -d <admin-domain> [-g]```

## Flag Breakdown
| Flag | Name | Required | Description |
| :--- | :---: | :---: | ---: |
| -d | Domain | Yes | The domain (e.g., proxy.yourdomain.com)where the BoringProxy dashboard will live. The script uses this to automate SSL certificates. |
| -g | GatewayPorts | No | Highly Recommended. This flag modifies /etc/ssh/sshd_config to allow your tunnels to be reached from the public internet. Without this, tunnels may only be accessible via localhost. |

## 💻 Client Script: setup-bp-client.sh

Run this script on the client machine

### Usage
```sudo ./setup-bp-client.sh -s <server-domain> -t <token> [-n <client-name>]```

## Flag Breakdown
| Flag | Name | Required | Description | 
| :--- | :---: | :---: | ---: |
| -d | Domain | Yes | The domain of your BoringProxy server. |
| -t | Access Token | Yes | The security token generated in the BoringProxy Admin Web UI after you create a new client. |
| -n | Client Name | No | A custom identifier for this client in the dashboard. If omitted, the script defaults to your machine's hostname. |
