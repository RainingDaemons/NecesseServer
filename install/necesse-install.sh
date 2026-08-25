#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts.org
# Author: RainingDaemons
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://necessegame.com/ | Github: https://github.com/RainingDaemons/NecesseServer

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD dpkg --add-architecture i386
$STD apt-get update
$STD apt-get install -y ca-certificates wget default-jre python3 python3-pip lib32gcc-s1 lib32stdc++6 lib32z1 ufw
msg_ok "Installed Dependencies"

msg_info "Setting up Firewall"
$STD ufw enable
$STD ufw allow 14159/tcp
$STD ufw allow 14159/udp
msg_ok "Set up Firewall"

msg_info "Creating steam user"
useradd -m -s /bin/bash steam
msg_ok "Created steam user"

msg_info "Installing SteamCMD"
$STD wget -q -O /home/steam/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
$STD tar -xzf /home/steam/steamcmd_linux.tar.gz -C /home/steam
$STD rm /home/steam/steamcmd_linux.tar.gz
chown -R steam:steam /home/steam
msg_ok "Installed SteamCMD"

msg_info "Installing Necesse Dedicated Server"
su - steam -c "cd /home/steam && ./steamcmd.sh +login anonymous +app_update 1169370 +quit"
msg_ok "Installed Necesse Dedicated Server"

msg_info "Setting up Necesse Server"
mkdir -p /home/steam/necesse
curl -fsSL -o /home/steam/necesse/config.toml https://raw.githubusercontent.com/RainingDaemons/NecesseServer/refs/heads/lxc/config.toml
curl -fsSL -o /home/steam/necesse/run_server.sh https://raw.githubusercontent.com/RainingDaemons/NecesseServer/refs/heads/lxc/run_server.sh
curl -fsSL -o /home/steam/necesse/update_server.sh https://raw.githubusercontent.com/RainingDaemons/NecesseServer/refs/heads/lxc/update_server.sh
curl -fsSL -o /home/steam/necesse/check.sh https://raw.githubusercontent.com/RainingDaemons/NecesseServer/refs/heads/lxc/check.sh
curl -fsSL -o /home/steam/necesse/download_workshop.py https://raw.githubusercontent.com/RainingDaemons/NecesseServer/refs/heads/lxc/download_workshop.py
chmod +x /home/steam/necesse/run_server.sh
chmod +x /home/steam/necesse/update_server.sh
chmod +x /home/steam/necesse/check.sh
mkdir -p /home/steam/necesse_saves
chown -R steam:steam /home/steam/necesse /home/steam/necesse_saves
msg_ok "Set up Necesse Server"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/necesse.service
[Unit]
Description=Necesse Dedicated Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/home/steam/necesse
ExecStart=/bin/bash /home/steam/necesse/run_server.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now necesse
msg_ok "Created Service"

motd_ssh

# Point the in-container "update" command at this repository
eval "$(declare -f customize | sed 's#https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct#https://raw.githubusercontent.com/RainingDaemons/NecesseServer/lxc#g')"
customize
cleanup_lxc
