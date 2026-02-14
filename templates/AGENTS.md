# MCP Integration Guide for AI Agents

This repository supports the Model Context Protocol (MCP) via the Chrome DevTools MCP server.

## How to use

1. Install the MCP server: `npm install -g chrome-devtools-mcp`
2. Configure your AI agent to use the server.
3. Example configuration:
   ```json
   {
     "mcpServers": {
       "chrome-devtools": {
         "command": "chrome-devtools-mcp",
         "args": ["--headless=true"]
       }
     }
   }
   ```

## Available Tools

- Browser navigation
- Input automation (click, fill, etc.)
- Performance tracing
- Network inspection
- Console log access
- Screenshots and snapshots
