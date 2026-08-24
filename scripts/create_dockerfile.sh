#!/bin/bash
# create_dockerfile.sh
# Dockerfile creator for Necesse Server
config="$(dirname "$0")/../config.toml"
linux_dir=$(grep '^linux_dir' "$config" | cut -d'=' -f2 | tr -d ' "\r')
docker build -t necesse "$linux_dir"