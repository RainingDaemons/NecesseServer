# check.ps1
# Server setup checker for Necesse Server
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "..\config.toml"
$config = Get-Content $configPath -Raw
$winDir = ""
foreach ($line in ($config -split "`n")) {
    if ($line -match '^\s*win_dir\s*=\s*"([^"]*)"') {
        $winDir = $Matches[1].Trim()
        break
    }
}

if ([string]::IsNullOrWhiteSpace($winDir) -or $winDir -eq "...") {
    $winDir = "C:/Users/$([Environment]::UserName)/Desktop/NecesseServer"
    Write-Host "win_dir is not set in config.toml, using default dir: $winDir"
    $config = $config -replace 'win_dir\s*=\s*"[^"]*"', ('win_dir = "' + $winDir + '"')
    Set-Content -Path $configPath -Value $config
}
$necesseFolder = $winDir
$serverFolder = "$winDir\server"

$passed = 0
$total = 4

if (-not [string]::IsNullOrWhiteSpace($winDir)) {
    Write-Host "[$([char]0x2713)] win_dir configured"
    $passed++
} else {
    Write-Host "[x] win_dir configured"
}

if (Test-Path $necesseFolder) {
    Write-Host "[$([char]0x2713)] NecesseServer folder"
    $passed++

    if (-not (Test-Path $serverFolder)) {
        New-Item -ItemType Directory -Path $serverFolder -Force | Out-Null
        Write-Host "Created server folder: $serverFolder"
    }
    Write-Host "[$([char]0x2713)] server folder"
    $passed++
} else {
    Write-Host "[x] NecesseServer folder"
    Write-Host "[x] server folder"
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
