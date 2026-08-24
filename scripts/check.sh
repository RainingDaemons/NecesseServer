#!/bin/bash
# check.sh
# Server setup checker for Necesse Server
configPath="$(dirname "$0")/../config.toml"
linux_dir=$(grep '^linux_dir' "$configPath" | cut -d'=' -f2 | tr -d ' "')

if [ -z "$linux_dir" ] || [ "$linux_dir" = "..." ]; then
    linux_dir="/home/$(whoami)/Desktop/NecesseServer"
    echo "linux_dir is not set in config.toml, using default dir: $linux_dir"
    sed -i "s|^linux_dir[[:space:]]*=.*|linux_dir = \"$linux_dir\"|" "$configPath"
fi

necesseFolder="$linux_dir"
serverFolder="$necesseFolder/server"

passed=0
total=4

if [ -n "$linux_dir" ]; then
    echo "[✓] linux_dir configured"
    passed=$((passed + 1))
else
    echo "[x] linux_dir configured"
fi

if [ -d "$necesseFolder" ]; then
    echo "[✓] NecesseServer folder"
    passed=$((passed + 1))

    if [ ! -d "$serverFolder" ]; then
        mkdir -p "$serverFolder"
        echo "Created server folder: $serverFolder"
    fi
    echo "[✓] server folder"
    passed=$((passed + 1))
else
    echo "[x] NecesseServer folder"
    echo "[x] server folder"
fi

if docker image inspect necesse >/dev/null 2>&1; then
    echo "[✓] Necesse docker image"
    passed=$((passed + 1))
else
    echo "[x] Necesse docker image"
fi

if [ "$passed" -eq "$total" ]; then
    echo "[$passed/$total] passed - Server setup is done"
else
    echo "[$passed/$total] passed - Server needs some fixes"
fi
