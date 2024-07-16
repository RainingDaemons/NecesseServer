#!/bin/bash
# run_server.sh
# Necesse - Server Run Config
#
# author RainingDaemons
# date 16-07-2024
# website https://github.com/RainingDaemons
world_name="servername"
password="123456"
server_port="14159"
player_slots="10"
server_ip="127.0.0.1"
server_owner="username"
necesse_dir="/home/steam/necesse_saves"
modded_server="0" # Set 1 if the server will use mods

# Download workshop items
if [ "$modded_server" -eq 1 ]; then
    python3 /home/steam/necesse/download_workshop.py
fi

# Run script
./jre/bin/java \
    -jar Server.jar \
    -nogui \
    -world "$world_name" \
    -password "$password" \
    -port "$server_port" \
    -slots "$player_slots" \
    -owner "$server_owner" \
    -ip "$server_ip" \
    -datadir "$necesse_dir"