#!/bin/bash
# Setup script for Gitea/Forgejo Runner (act_runner)
# Usage: ./setup-act-runner.sh --url <REPO_URL> --token <TOKEN> [--name <RUNNER_NAME>]

set -e

REPO_URL=""
TOKEN=""
RUNNER_NAME="my-act-runner"
RUNNER_VERSION="0.2.10" # Check for latest version
RUNNER_ARCH="linux-amd64"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --url) REPO_URL="$2"; shift ;;
        --token) TOKEN="$2"; shift ;;
        --name) RUNNER_NAME="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$REPO_URL" ] || [ -z "$TOKEN" ]; then
    echo "Error: --url and --token are required."
    echo "Usage: ./setup-act-runner.sh --url <REPO_URL> --token <TOKEN>"
    exit 1
fi

echo "Setting up act_runner for $REPO_URL..."

# Create a folder for the runner
mkdir -p act-runner && cd act-runner

# Download act_runner
echo "Downloading act_runner (v$RUNNER_VERSION)..."
if [ ! -f "act_runner" ]; then
    curl -o act_runner -L https://gitea.com/gitea/act_runner/releases/download/v${RUNNER_VERSION}/act_runner-${RUNNER_VERSION}-${RUNNER_ARCH}
    chmod +x act_runner
fi

# Generate config if not exists
if [ ! -f "config.yaml" ]; then
    ./act_runner generate-config > config.yaml
fi

# Register the runner
echo "Registering runner..."
./act_runner register \
  --instance "$REPO_URL" \
  --token "$TOKEN" \
  --name "$RUNNER_NAME" \
  --no-interactive

echo "Runner registered successfully!"
echo "To start the runner, run: cd act-runner && ./act_runner daemon"
