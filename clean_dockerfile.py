# clean_dockerfile.py
# Automatic OS Script Selector to clean old Dockerfiles
import subprocess
import sys

def main():
    if sys.platform == "win32":
        proc = subprocess.run(["powershell", "-NoProfile", "-File", "./scripts/clean_dockerfile.ps1"])
    else:
        proc = subprocess.run(["bash", "./scripts/clean_dockerfile.sh"])
    sys.exit(proc.returncode)

if __name__ == "__main__":
    main()
