#!/bin/bash
# start.sh
# Automatic Necesse Server Starter
script_dir="$(cd "$(dirname "$0")/.." && pwd)"
config="$script_dir/config.toml"
linux_username=$(grep '^linux_username' "$config" | cut -d'=' -f2 | tr -d ' "\r' | head -1)

if [ -z "$linux_username" ]; then
    linux_username=$(whoami)
fi

docker run --rm \
    -v "/home/$linux_username/Desktop/NecesseServer/saves:/home/steam/necesse_saves" \
    -v "$config:/home/steam/necesse/config.toml" \
    -p 14159:14159/udp -it necesse
