# check.py
# Automatic OS Script Selector to check NecesseServer installation
import subprocess
import sys

def main():
    if sys.platform == "win32":
        proc = subprocess.run(["powershell", "-NoProfile", "-File", "./scripts/check.ps1"])
    else:
        proc = subprocess.run(["bash", "./scripts/check.sh"])
    sys.exit(proc.returncode)

if __name__ == "__main__":
    main()
