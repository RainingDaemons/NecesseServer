#!/bin/bash
# check.sh
# Server setup checker for Necesse Server
configPath="$(dirname "$0")/../config.toml"
linux_dir=$(grep '^linux_dir' "$configPath" | cut -d'=' -f2 | tr -d ' "')

if [ -z "$linux_dir" ] || [ "$linux_dir" = "..." ]; then
    linux_dir="/home/steam/necesse"
    echo "linux_dir is not set in config.toml, using default dir: $linux_dir"
    sed -i "s|^linux_dir[[:space:]]*=.*|linux_dir = \"$linux_dir\"|" "$configPath"
fi

necesseFolder="$linux_dir"
serverFolder="$necesseFolder/server"

passed=0
total=6

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

check_pkgs() {
    local label="$1"
    shift
    local missing=0
    for pkg in "$@"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            missing=1
        fi
    done
    if [ "$missing" -eq 0 ]; then
        echo "[✓] $label"
        passed=$((passed + 1))
    else
        echo "[x] $label"
    fi
}

check_pkgs "python installed" python3 python3-pip
check_pkgs "java installed" default-jre
check_pkgs "core deps installed" ca-certificates wget lib32gcc-s1 lib32stdc++6 lib32z1

if [ "$passed" -eq "$total" ]; then
    echo "[$passed/$total] passed - Server setup is done"
else
    echo "[$passed/$total] passed - Server needs some fixes"
fi
