#!/bin/bash
# create_dockerfile.sh
# Dockerfile creator for Necesse Server
config="$(dirname "$0")/../config.toml"
linux_username=$(grep '^linux_username' "$config" | cut -d'=' -f2 | tr -d ' "\r')
username="${linux_username:-$(whoami)}"
docker build -t necesse "/home/$username/Desktop/NecesseServer"