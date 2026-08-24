#!/bin/bash
# run_server.sh
# Necesse Server Run Config for Docker
world_name=$(grep '^world_name' config.toml | cut -d'=' -f2 | tr -d ' "\r')
password=$(grep '^password' config.toml | cut -d'=' -f2 | tr -d ' "\r')
server_port=$(grep '^server_port' config.toml | cut -d'=' -f2 | tr -d ' "\r')
player_slots=$(grep '^player_slots' config.toml | cut -d'=' -f2 | tr -d ' "\r')
server_ip=$(grep '^server_ip' config.toml | cut -d'=' -f2 | tr -d ' "\r')
server_owner=$(grep '^server_owner' config.toml | cut -d'=' -f2 | tr -d ' "\r')
necesse_dir=$(grep '^necesse_dir' config.toml | cut -d'=' -f2 | tr -d ' "\r')
modded_server=$(grep '^modded_server' config.toml | cut -d'=' -f2 | cut -d'#' -f1 | tr -d ' "\r')

# Make sure download dir exists
mkdir -p "$necesse_dir"
mkdir -p "$necesse_dir/mods"

# Download workshop items
if [ "$modded_server" -eq 1 ]; then
    python3 /home/steam/necesse/download_workshop.py
fi

# Move to server directory
cd /home/steam/Steam/steamapps/common/Necesse\ Dedicated\ Server || {
    echo "Error: Can't move to server directory"
    exit 1
}

# Run script
java -jar Server.jar \
    -nogui \
    -world "$world_name" \
    -password "$password" \
    -port "$server_port" \
    -slots "$player_slots" \
    -owner "$server_owner" \
    -ip "$server_ip" \
    -datadir "$necesse_dir"