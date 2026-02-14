# Global Setup for All Repositories

This guide explains how to enable Chrome DevTools MCP across all repositories for users and contributors.

## 🚀 For Users and Contributors

To use the Chrome DevTools MCP server with your local AI agent (like Claude Desktop or VS Code):

1. **Prerequisites**: Ensure you have [Node.js](https://nodejs.org/) installed (version 20 or higher).
2. **Configuration**: Use the [mcp-config.template.json](mcp-config.template.json) as a starting point for your MCP client configuration.
3. **Usage**:
   - The server is automatically installed/run via `npx` when your agent calls it.
   - You can also install it globally: `npm install -g chrome-devtools-mcp`.

## 🏢 For Organizations (A6-9V, L6-N9)

### 1. Automation with GitHub PAT
If you have a GitHub Personal Access Token, you can use the rollout script to add MCP workflows to all your repositories:

```bash
export GITHUB_TOKEN="your_token_here"
./scripts/rollout-mcp.sh --org A6-9V
```

### 2. CI/CD Runner Setup
To run browser-based tests or performance checks in your CI/CD pipelines (Forgejo/Gitea), set up a dedicated runner:

- See [A6-9V Runner Config](orgs/A6-9V/runner-config.md)
- See [L6-N9 Runner Config](orgs/L6-N9/runner-config.md)

### 3. Repository Templates
We recommend adding the following files to your repositories:
- `.github/workflows/mcp-check.yml`: [Template here](templates/mcp-workflow.yml)
- `AGENTS.md`: [Template here](templates/AGENTS.md)

## 🛠 Available Tools

The Chrome DevTools MCP server provides a wide range of tools for interacting with the browser, including navigation, input automation, performance tracing, and debugging. See the [Tool Reference](docs/tool-reference.md) for more details.
