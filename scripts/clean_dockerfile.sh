#!/bin/bash
# clean_dockerfile.sh
# Completely remove the Necesse docker image, build cache, and local folder
config="$(dirname "$0")/../config.toml"
linux_dir=$(grep '^linux_dir' "$config" | cut -d'=' -f2 | tr -d ' "\r')
necesse_folder="$linux_dir"

echo "Removing running Necesse containers..."
docker ps -aq --filter "ancestor=necesse" | xargs -r docker rm -f

echo "Removing Necesse image..."
docker rmi -f necesse

echo "Pruning docker build cache..."
docker builder prune -af

echo "Pruning dangling images..."
docker image prune -f

if [ -d "$necesse_folder" ]; then
    echo "Removing local NecesseServer folder: $necesse_folder"
    rm -rf "$necesse_folder"
else
    echo "Local NecesseServer folder not found: $necesse_folder"
fi

echo "Cleanup done"
