# create_dockerfile.ps1
# Dockerfile creator for Necesse Server
$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "..\config.toml"
$config = Get-Content $configPath -Raw
$winDir = ""
foreach ($line in ($config -split "`n")) {
    if ($line -match '^\s*win_dir\s*=\s*"([^"]*)"') {
        $winDir = $Matches[1].Trim()
        break
    }
}
docker build -t necesse "$winDir"