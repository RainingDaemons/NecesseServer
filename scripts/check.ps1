# check.ps1
# Server setup checker for Necesse Server
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
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
$savesFolder = "$necesseFolder\saves"

$passed = 0
$total = 3

if (Test-Path $necesseFolder) {
    Write-Host "[$([char]0x2713)] NecesseServer folder"
    $passed++

    if (-not (Test-Path $savesFolder)) {
        New-Item -ItemType Directory -Path $savesFolder -Force | Out-Null
        Write-Host "Created saves folder: $savesFolder"
    }
    Write-Host "[$([char]0x2713)] saves folder"
    $passed++
} else {
    Write-Host "[x] NecesseServer folder"
    Write-Host "[x] saves folder"
}

docker image inspect necesse *> $null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[$([char]0x2713)] Necesse docker image"
    $passed++
} else {
    Write-Host "[x] Necesse docker image"
}

if ($passed -eq $total) {
    Write-Host "[$passed/$total] passed - Server setup is done"
} else {
    Write-Host "[$passed/$total] passed - Server needs some fixes"
}
