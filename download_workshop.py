# download_workshop.py
# Workshop Items Downloader for Necesse Server
import os
import re
import shutil
import subprocess
import zipfile

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

os.makedirs(destiny, exist_ok=True)


def read_mod_info(jar_path):
    """Return the content of mod.info inside a .jar, or None."""
    try:
        with zipfile.ZipFile(jar_path) as zf:
            if 'mod.info' in zf.namelist():
                return zf.read('mod.info').decode('utf-8')
    except (zipfile.BadZipFile, OSError):
        pass
    return None


def parse_field(info, field):
    """Extract a single 'field = value' entry from mod.info content."""
    if not info:
        return None
    match = re.search(r'^\s*' + field + r'\s*=\s*([^,\r\n]+)', info, re.MULTILINE)
    if not match:
        return None
    return match.group(1).strip().strip('"')


def version_tuple(version):
    """Convert a version string to a tuple of ints for comparison."""
    return tuple(int(p) for p in re.findall(r'\d+', version or ''))


def is_newer(new_version, old_version):
    """Return True if new is newer, False if equal/older, None if unknown."""
    if not new_version or not old_version:
        return None
    return version_tuple(new_version) > version_tuple(old_version)


def index_installed_mods(destiny):
    """Map installed mod id -> metadata {path, file, version}."""
    installed = {}
    if not os.path.isdir(destiny):
        return installed
    for file in os.listdir(destiny):
        if not file.endswith('.jar'):
            continue
        path = os.path.join(destiny, file)
        info = read_mod_info(path)
        mod_id = parse_field(info, 'id') or file
        installed[mod_id] = {
            'path': path,
            'file': file,
            'version': parse_field(info, 'version'),
        }
    return installed


installed = index_installed_mods(destiny)

for root, dirs, files in os.walk(origin):
    for file in files:
        if not file.endswith('.jar'):
            continue

        origin_file_path = os.path.join(root, file)
        destiny_file_path = os.path.join(destiny, file)

        info = read_mod_info(origin_file_path)
        mod_id = parse_field(info, 'id') or file
        new_version = parse_field(info, 'version')

        existing = installed.get(mod_id)

        # New mod, not installed yet
        if existing is None:
            shutil.move(origin_file_path, destiny_file_path)
            installed[mod_id] = {'path': destiny_file_path, 'file': file, 'version': new_version}
            print(f'Item: {file} successfully moved')
            continue

        newer = is_newer(new_version, existing['version'])

        # Recently downloaded mod is newer -> replace installed one
        if newer is True:
            old_path = existing['path']
            if os.path.exists(old_path):
                os.remove(old_path)
            shutil.move(origin_file_path, destiny_file_path)
            installed[mod_id] = {'path': destiny_file_path, 'file': file, 'version': new_version}
            print(f'Updated: {existing["file"]} -> {file} (v{existing["version"]} -> v{new_version})')
            continue

        # Same version (or unable to compare) -> keep installed mod, discard downloaded
        if newer is False:
            os.remove(origin_file_path)
            print(f'Skipped (same version): {file} (v{existing["version"]})')
            continue

        # Unknown version info: fall back to filename check
        if os.path.exists(destiny_file_path):
            os.remove(origin_file_path)
            print(f'Skipped (already exists): {file}')
        else:
            shutil.move(origin_file_path, destiny_file_path)
            installed[mod_id] = {'path': destiny_file_path, 'file': file, 'version': new_version}
            print(f'Item: {file} successfully moved')
