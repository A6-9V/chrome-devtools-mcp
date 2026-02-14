param (
    [string]$Url,
    [string]$Token,
    [string]$Name = "chrome-devtools-mcp-runner",
    [string]$Labels = "windows-latest:act_runner,windows-2022:act_runner"
)

if (-not $Url -or -not $Token) {
    Write-Error "Parameters -Url and -Token are required."
    return
}

$RunnerVersion = "0.2.10"
$Arch = "windows-amd64"
$RunnerDir = "act-runner"

if (-not (Test-Path $RunnerDir)) {
    New-Item -ItemType Directory -Path $RunnerDir
}

Set-Location $RunnerDir

if (-not (Test-Path "act_runner.exe")) {
    Write-Host "Downloading act_runner (v$RunnerVersion)..."
    $DownloadUrl = "https://gitea.com/gitea/act_runner/releases/download/v$RunnerVersion/act_runner-$RunnerVersion-$Arch.exe"
    Invoke-WebRequest -Uri $DownloadUrl -OutFile "act_runner.exe"
}

if (-not (Test-Path "config.yaml")) {
    Write-Host "Generating default config..."
    .\act_runner.exe generate-config | Out-File -FilePath "config.yaml" -Encoding utf8
}

Write-Host "Registering runner..."
.\act_runner.exe register --instance $Url --token $Token --name $Name --labels $Labels --no-interactive

Write-Host "Runner registered successfully!"
Write-Host "To start the runner: .\act_runner.exe daemon"
