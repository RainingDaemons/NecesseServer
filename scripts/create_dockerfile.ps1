# create_dockerfile.ps1
# Dockerfile creator for Necesse Server
$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "..\config.toml"
$config = Get-Content $configPath -Raw
$winUsername = ""
foreach ($line in ($config -split "`n")) {
    if ($line -match '^\s*win_username\s*=\s*"([^"]*)"') {
        $winUsername = $Matches[1].Trim()
        break
    }
}
$username = if ($winUsername) { $winUsername } else { [Environment]::UserName }
docker build -t necesse "C:\Users\$username\Desktop\NecesseServer"