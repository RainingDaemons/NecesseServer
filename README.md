# Docker Necesse Server

## What is this?

This repository is intended to provide some useful scripts for setting up your own Necesse Server powered by Docker.

---

## Prerequisites

Some of the requirements needed to run the scripts are:
- [Docker](https://www.docker.com/) available in your system
- [Python](https://www.python.org/) 3.11+
- It is recommended to install [Docker Desktop](https://www.docker.com/products/docker-desktop/) to monitor if the containers are launched correctly.
- Use some Virtual LAN service such as Hamachi

---

## How i can run it?

The following order is recommended for the container to be launched correctly:

1. Edit the server configuration file named `config.toml` and fill this required variables:
- **world_name:** will be the name of the world to be created.
- **password:** is the password that will be used to connect to the server, it can be left empty if it is not required.
- **player_slots:** is the maximum amount of players that can enter the server.
- **server_owner:** any player that enters with this name will be the owner of the server, it can be left empty if not required.
- **win_username:** put your windows username (only windows machines)
- **linux_username:** put your linux username (only linux machines)

2. Execute the following script to automatically create the Necesse image in your Docker:
```bash
python create_dockerfile.py
```

3. Once installed, create a folder named "saves" inside "NecesseServer" in your desktop. Check if the server is setup correctly running the script:
```bash
python check.py
```

4. Now you should be able to launch the server automatically by running the script:
```bash
python start.py
```

## Clean installation

In case you need to clean old Necesse Docker images run the script:
```bash
python clean_dockerfile.py
```

And then reinstall with `create_dockerfile.py` script
