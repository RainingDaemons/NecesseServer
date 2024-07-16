# download_workshop.py
# Necesse - Workshop Items Downloader
#
# author RainingDaemons
# date 16-07-2024
# website https://github.com/RainingDaemons
import os
import shutil
import subprocess

# Define workshop.txt, steamcmd & necesse_server directories
necesse_dir = "/home/steam/necesse_saves"
workshop_dir = necesse_dir + "/workshop.txt"
steamcmd_dir = "/home/steam"

with open(workshop_dir, 'r') as archivo:
    lineas = archivo.readlines()

# Save workshop IDs
workshopID = [linea.strip() for linea in lineas if not linea.strip().startswith('#')]
print(f"IDs: {workshopID}")
print(f"Total items: {len(workshopID)}")

# Download workshop maps
steamcmd_exe = os.path.join(steamcmd_dir, 'steamcmd.sh')

for i in range(len(workshopID)):
    print(f"\nDownloading item {workshopID[i]} from Steam... ({i+1}/{len(workshopID)})\n")
    subprocess.run([steamcmd_exe, '+login anonymous', '+workshop_download_item 1169040 ' + workshopID[i], '+quit'])

# Move workshop files from steamcmd to Necesse Server folder
origin = steamcmd_dir + "/Steam/steamapps/workshop/content/1169040/"
destiny = necesse_dir + "/mods/"
print("\n")
for root, dirs, files in os.walk(origin):
    for file in files:
        if file.endswith('.jar'):
            origin_file_path = os.path.join(root, file)
            destiny_file_path = os.path.join(destiny, file)
            # Check if file already exists in the destiny directory
            if not os.path.exists(destiny_file_path):
                shutil.move(origin_file_path, destiny_file_path)
                print(f'Item: {file} successfully moved')
            else:
                print(f'Skipped (already exists): {file}')
