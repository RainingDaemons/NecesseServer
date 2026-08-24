# start.ps1
# Automatic Necesse Server Starter
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
$configFull = (Resolve-Path $configPath).Path -replace '\\', '/'
docker run --rm -v "C:/Users/$username/Desktop/NecesseServer/saves:/home/steam/necesse_saves" -v "${configFull}:/home/steam/necesse/config.toml" -p 14159:14159/udp -it necesse
