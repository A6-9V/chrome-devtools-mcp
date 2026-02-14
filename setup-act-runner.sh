#!/bin/bash
# Setup script
set -e
URL=""
TOKEN=""
RUNNER_NAME="chrome-devtools-mcp-runner"
RUNNER_VERSION="0.2.10"
LABELS="ubuntu-latest:docker://node:20,ubuntu-22.04:docker://node:20,ubuntu-20.04:docker://node:20"
ARCH=$(uname -m)
case $ARCH in
    x86_64) RUNNER_ARCH="linux-amd64" ;;
    aarch64) RUNNER_ARCH="linux-arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; false ;;
esac
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --url) URL="$2"; shift ;;
        --token) TOKEN="$2"; shift ;;
        --name) RUNNER_NAME="$2"; shift ;;
        --labels) LABELS="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; false ;;
    esac
    shift
done
if [ -z "$URL" ] || [ -z "$TOKEN" ]; then
    echo "Error: --url and --token are required."; false
fi
echo "Setting up act_runner for $URL..."
mkdir -p act-runner && cd act-runner
if [ ! -f "act_runner" ]; then
    curl -o act_runner -L "https://gitea.com/gitea/act_runner/releases/download/v${RUNNER_VERSION}/act_runner-${RUNNER_VERSION}-${RUNNER_ARCH}"
    chmod +x act_runner
fi
if [ ! -f "config.yaml" ]; then
    ./act_runner generate-config > config.yaml
fi
./act_runner register --instance "$URL" --token "$TOKEN" --name "$RUNNER_NAME" --labels "$LABELS" --no-interactive
echo "Runner registered successfully!"
