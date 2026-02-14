#!/bin/bash
# Organization-wide MCP Rollout Script
# Uses GitHub API to add MCP configurations and workflows to repositories.

set -e

ORG=""
REPOS=""
TOKEN=${GITHUB_TOKEN}

# Detect if we are in a subshell or sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    IS_SCRIPT=true
else
    IS_SCRIPT=false
fi

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --org) ORG="$2"; shift ;;
        --repos) REPOS="$2"; shift ;;
        *) echo "Unknown parameter: $1"; if $IS_SCRIPT; then exit 1; else return 1; fi ;;
    esac
    shift
done

if [ -z "$ORG" ] || [ -z "$TOKEN" ]; then
    echo "Usage: $0 --org <ORG_NAME> [--repos <REPO1,REPO2>]"
    echo "Environment variable GITHUB_TOKEN must be set."
    if $IS_SCRIPT; then exit 1; else return 1; fi
fi

if [ -z "$REPOS" ]; then
    echo "Fetching repositories for $ORG..."
    REPOS=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/orgs/$ORG/repos?per_page=100" | grep -oP '"name": "\K[^"]+')
fi

WORKFLOW_CONTENT="name: MCP Check
on: [push]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install MCP Server
        run: npm install -g chrome-devtools-mcp
      - name: Verify
        run: chrome-devtools-mcp --help"

for REPO in $REPOS; do
    echo "Processing $ORG/$REPO..."
    FILE_PATH=".github/workflows/mcp-check.yml"
    CONTENT_BASE64=$(echo "$WORKFLOW_CONTENT" | base64 -w 0)

    # Get SHA if file exists
    SHA=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/repos/$ORG/$REPO/contents/$FILE_PATH" | grep -oP '"sha": "\K[^"]+' || echo "")

    if [ -z "$SHA" ]; then
        PAYLOAD=$(jq -n --arg msg "ci: add MCP check" --arg content "$CONTENT_BASE64" '{message: $msg, content: $content}')
    else
        PAYLOAD=$(jq -n --arg msg "ci: update MCP check" --arg content "$CONTENT_BASE64" --arg sha "$SHA" '{message: $msg, content: $content, sha: $sha}')
    fi

    curl -s -X PUT -H "Authorization: token $TOKEN" \
        -H "Content-Type: application/json" \
        -d "$PAYLOAD" \
        "https://api.github.com/repos/$ORG/$REPO/contents/$FILE_PATH" > /dev/null

    echo "Done with $REPO"
done
