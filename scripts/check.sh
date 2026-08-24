#!/bin/bash
# check.sh
# Server setup checker for Necesse Server
configPath="$(dirname "$0")/../config.toml"
linuxUsername=$(grep '^linux_username' "$configPath" | cut -d'=' -f2 | tr -d ' "')

if [ -z "$linuxUsername" ]; then
    linuxUsername=$(whoami)
fi

necesseFolder="/home/$linuxUsername/Documents/NecesseServer"
savesFolder="$necesseFolder/saves"

passed=0
total=3

if [ -d "$necesseFolder" ]; then
    echo "[✓] NecesseServer folder"
    passed=$((passed + 1))

    if [ ! -d "$savesFolder" ]; then
        mkdir -p "$savesFolder"
        echo "Created saves folder: $savesFolder"
    fi
    echo "[✓] saves folder"
    passed=$((passed + 1))
else
    echo "[x] NecesseServer folder"
    echo "[x] saves folder"
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
