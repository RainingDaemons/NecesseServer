# Docker Necesse Server

## What is this?

This repository is intended to provide some useful scripts for setting up your own Necesse Server powered by Docker.

---

## Prerequisites

Some of the requirements needed to run the scripts are:
- Have Docker installed on your operating system
- It is recommended to install Docker Desktop to monitor if the containers are launched correctly.
- Use some Virtual LAN service such as Hamachi

In particular, the "start.bat" script is to automatically start the Docker container on a Windows operating system but can be transcribed to Linux systenms.

---

## How i can run it?

The following order is recommended for the container to be launched correctly:

1. Edit the file `run_server.sh` since this file will be the server launch config. Where:
- **world_name:** will be the name of the world to be created.
- **password:** is the password that will be used to connect to the server, it can be left empty if it is not required.
- **player_slots:** is the maximum amount of players that can enter the server.
- **server_owner:** any player that enters with this name will be the owner of the server, it can be left empty if not required.

2. Install the `Dockerfile`, if this file is in your desktop you can launch it from powershell with the command:
```bash
docker build -t necesse C:\Users\your-username\Desktop\docker\necesse
```

> NOTE: Replace `your-username` with your real username from Windows

3. Once installed, create a folder to save the world saves, for example you could create a folder called "necesse_server" and inside it create another folder called "saves" on your desktop, if your username is "user" then you have to edit `start.bat` like this:
```bash
docker run --rm -v "C:/Users/user/Desktop/necesse_server/saves:/home/steam/necesse_saves" -p 14159:14159/udp -it necesse
```

4. Done, you should now be able to launch the server automatically by running the script `start.bat`.
