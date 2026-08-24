# start.ps1
# Automatic Necesse Server Starter
$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "..\config.toml"
$config = Get-Content $configPath -Raw
$winDir = ""
foreach ($line in ($config -split "`n")) {
    if ($line -match '^\s*win_dir\s*=\s*"([^"]*)"') {
        $winDir = $Matches[1].Trim()
        break
    }
}
$necesseDir = ""
foreach ($line in ($config -split "`n")) {
    if ($line -match '^\s*necesse_dir\s*=\s*"([^"]*)"') {
        $necesseDir = $Matches[1].Trim()
        break
    }
}
$configFull = (Resolve-Path $configPath).Path -replace '\\', '/'
docker run --rm -v "$winDir/server:$necesseDir" -v "${configFull}:/home/steam/necesse/config.toml" -p 14159:14159/udp -it necesse
