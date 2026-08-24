# start.py
# Automatic OS Script Selector for a Necesse Server
import subprocess
import sys

def main():
    if sys.platform == "win32":
        proc = subprocess.run(["powershell", "-NoProfile", "-File", "./scripts/start.ps1"])
    else:
        proc = subprocess.run(["bash", "./scripts/start.sh"])
    sys.exit(proc.returncode)

if __name__ == "__main__":
    main()
