# Proxmox LXC - Necesse Server

## What is this?

This repository is intended to provide some useful scripts for setting up your own Necesse Server using LXC (Linux Containers) from Proxmox.

---

## How it works?

Run the command below in the Proxmox VE Shell to create a Necesse Server:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RainingDaemons/NecesseServer/refs/heads/lxc/necesse.sh)"
```

## Server configuration

Edit the server configuration file named `config.toml` and fill this required variables:
- **world_name:** will be the name of the world to be created.
- **password:** is the password that will be used to connect to the server, it can be left empty if it is not required.
- **player_slots:** is the maximum amount of players that can enter the server.
- **server_owner:** any player that enters with this name will be the owner of the server, it can be left empty if not required.
- **linux_username:** put your proxmox LXC username

## Restart server service

If changes were made in server config or server version was update, execute the following commands:
```bash
systemctl daemon-reload
systemctl restart necesse.service
```

## Playing with Mods

Inside `/home/steam/necesse_saves` folder create a file named `workshop.txt` with the IDs of the mods you want to download, for example:
```text
# Specify 1 workshop item id per line
2824816332
3137996356
```

Then run the following script to autodownload your mods:
```bash
./download_mods.sh
```

Restart the server, now your mods will be automatically loaded
