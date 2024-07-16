# Dockerfile
# Necesse - Necesse Server Container
#
# author RainingDaemons
# date 15-07-2024
# website https://github.com/RainingDaemons
FROM ubuntu:18.04

RUN echo "Installing Repositories..."
RUN apt-get update
RUN apt-get install -y lib32gcc1 lib32z1 lib32stdc++6 libc6 curl nano build-essential unzip wget sudo default-jre default-jdk software-properties-common
RUN useradd -m -s /bin/bash steam
RUN echo 'steam:steam' | chpasswd
# Give permissions for steam user to use sudo without password
RUN echo 'steam ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN sudo usermod -aG sudo steam
USER steam
WORKDIR /home/steam
RUN mkdir -p steamcmd
RUN mkdir -p necesse_saves
RUN cd steamcmd
RUN echo "Installing SteamCMD..."
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar -xvzf steamcmd_linux.tar.gz && rm steamcmd_linux.tar.gz
RUN echo "Installing Necesse Dedicated Server..."
RUN ./steamcmd.sh +login anonymous +force_install_dir /home/steam/necesse/ +app_update 1169370 +quit
RUN echo "Copying scripts..."
# Copy the script to the container
COPY run_server.sh /home/steam/necesse/
WORKDIR /home/steam/necesse/
# Defines the directory as a volume
VOLUME /c/Users/ra1n/Desktop/docker/necesse/saves:/necesse_saves
# Automatically launch the script that runs the server
CMD ["/home/steam/necesse/run_server.sh"]