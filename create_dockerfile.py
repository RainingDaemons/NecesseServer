# create_dockerfile.py
# Automatic OS Script Selector to create Dockerfile
import subprocess
import sys

def main():
    if sys.platform == "win32":
        proc = subprocess.run(["powershell", "-NoProfile", "-File", "./scripts/create_dockerfile.ps1"])
    else:
        proc = subprocess.run(["bash", "./scripts/create_dockerfile.sh"])
    sys.exit(proc.returncode)

if __name__ == "__main__":
    main()
