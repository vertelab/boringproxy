# BoringProxy Service Setup Guide

This guide explains how to use the automation scripts to install **BoringProxy** as a system service. These scripts handle user creation, security permissions, and automatic restarts.

---

## 🛠 Server Script: `setup-bp-server.sh`

Run this script on your **VPS** (the machine with the public IP) to host the BoringProxy manager and dashboard.

### Usage
```bash sudo ./setup-bp-server.sh -d <admin-domain> [-g]``

## Flag Breakdown
| Flag | Name | Required | Description |
| :--- | :---: | :---: | ---: |
| -d | Admin | Domain | Yes | The domain (e.g., proxy.yourdomain.com)where the BoringProxy dashboard will live. The script uses this to automate SSL certificates. |
| -g | GatewayPorts | No | Highly Recommended. This flag modifies /etc/ssh/sshd_config to allow your tunnels to be reached from the public internet. Without this, tunnels may only be accessible via localhost. |

## 💻 Client Script: setup-bp-client.sh

Run this script on your Local Machine 
sudo ./setup-bp-client.sh -s <server-domain> -t <token> [-n <client-name>]
| Flag | Name | Required | Description | 
| :--- | :---: | :---: | ---: |
| -s | Server Domain | Yes | The domain of your BoringProxy server. This must match the -d value you used during the server setup.-tAccess TokenYesThe security token generated in the BoringProxy Admin Web UI after you create a new client. |
| -n | Client Name | No | A custom identifier for this client in the dashboard. If omitted, the script defaults to your machine's hostname. |
