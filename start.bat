:: start.bat
:: Necesse - Automatic Necesse Server Starter
::
:: author RainingDaemons
:: date 15-07-2024
:: website https://github.com/RainingDaemons
@echo off
cls
title Automatic Necesse Server Starter
:a
timeout 10
echo Starting the server
docker run --rm -v "C:/Users/your-username/Desktop/necesse_server/saves:/home/steam/necesse_saves" -p 14159:14159/udp -it necesse