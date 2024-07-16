#!/bin/bash
# run_server.sh
# Necesse - Server Run Config
#
# author RainingDaemons
# date 15-07-2024
# website https://github.com/RainingDaemons
world_name="servername"
password="123456"
server_port="14159"
player_slots="10"
server_ip="127.0.0.1"
server_owner="username"
necesse_dir="/home/steam/necesse_saves"

# Run script
exec ./jre/bin/java \
    -jar Server.jar \
    -nogui \
    -world "$world_name" \
    -password "$password" \
    -port "$server_port" \
    -slots "$player_slots" \
    -owner "$server_owner" \
    -ip "$server_ip" \
    -datadir "$necesse_dir"