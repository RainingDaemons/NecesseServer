# clean_docker.ps1
# Completely remove the Necesse docker image, build cache, and local folder
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
$necesseFolder = "C:\Users\$username\Desktop\NecesseServer"

Write-Host "Removing running Necesse containers..."
docker ps -aq --filter "ancestor=necesse" | ForEach-Object { docker rm -f $_ }

Write-Host "Removing Necesse image..."
docker rmi -f necesse

Write-Host "Pruning docker build cache..."
docker builder prune -af

Write-Host "Pruning dangling images..."
docker image prune -f

if (Test-Path $necesseFolder) {
    Write-Host "Removing local NecesseServer folder: $necesseFolder"
    Remove-Item -LiteralPath $necesseFolder -Recurse -Force
} else {
    Write-Host "Local NecesseServer folder not found: $necesseFolder"
}

Write-Host "Cleanup done"
