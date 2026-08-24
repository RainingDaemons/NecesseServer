#!/bin/bash
# start.sh
# Automatic Necesse Server Starter
script_dir="$(cd "$(dirname "$0")/.." && pwd)"
config="$script_dir/config.toml"
linux_dir=$(grep '^linux_dir' "$config" | cut -d'=' -f2 | tr -d ' "\r' | head -1)
necesse_dir=$(grep '^necesse_dir' "$config" | cut -d'=' -f2 | tr -d ' "\r' | head -1)

docker run --rm \
    -v "$linux_dir/server:$necesse_dir" \
    -v "$config:/home/steam/necesse/config.toml" \
    -p 14159:14159/udp -it necesse
