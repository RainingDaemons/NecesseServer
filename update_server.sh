#!/bin/bash
# update_server.sh
# Necesse Server Update Script
su - steam -c "cd /home/steam && ./steamcmd.sh +login anonymous +app_update 1169370 +quit"