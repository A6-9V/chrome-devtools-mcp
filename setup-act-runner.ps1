<#
.SYNOPSIS
    Setup script for Gitea/Forgejo Runner (act_runner) on Windows
.DESCRIPTION
    Downloads, installs, and registers act_runner.
.PARAMETER Url
    The repository or instance URL.
.PARAMETER Token
    The runner registration token.
.PARAMETER Name
    The name of the runner.
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$Url,

    [Parameter(Mandatory=$true)]
    [string]$Token,

    [string]$Name = "my-act-runner-windows"
)

$RunnerVersion = "0.2.10"
$RunnerArch = "windows-amd64"
$RunnerDir = "act-runner"
$ExeName = "act_runner.exe"
$DownloadUrl = "https://gitea.com/gitea/act_runner/releases/download/v$RunnerVersion/act_runner-$RunnerVersion-$RunnerArch.exe"

Write-Host "Setting up act_runner for $Url..." -ForegroundColor Cyan

# Create runner directory
if (-not (Test-Path -Path $RunnerDir)) {
    New-Item -ItemType Directory -Path $RunnerDir | Out-Null
}
Set-Location -Path $RunnerDir

# Download runner
if (-not (Test-Path -Path $ExeName)) {
    Write-Host "Downloading act_runner (v$RunnerVersion)..."
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ExeName
}

# Register the runner
Write-Host "Registering runner..."
# Note: act_runner register uses interactive prompts by default unless --no-interactive is used with config
# We might need to handle config generation
if (-not (Test-Path -Path "config.yaml")) {
    & .\$ExeName generate-config > config.yaml
}

& .\$ExeName register --instance $Url --token $Token --name $Name --no-interactive

Write-Host "Runner registered successfully!" -ForegroundColor Green
Write-Host "To start the runner, run: cd $RunnerDir; .\$ExeName daemon"
