# L6-N9 Organization Runner Configuration

## Configuration Details

- **Forgejo/Gitea Organization URL:** `https://forge.mql5.io/L6-N9`
- **GitHub Organization URL:** `https://github.com/L6-N9`
- **Runner Settings URL (Forgejo):** `https://forge.mql5.io/orgs/L6-N9/settings/actions/runners`

## Setup Instructions

### Gitea/Forgejo Actions (act_runner)

Use the `setup-act-runner.sh` script in the root of the repository.

```bash
chmod +x setup-act-runner.sh
# Run with your organization registration token
./setup-act-runner.sh --url "https://forge.mql5.io/L6-N9" --token "<L6-N9_FORGEJO_TOKEN>" --name "L6-N9-Runner"
```

### GitHub Actions

For GitHub organization runners, follow the official GitHub documentation to register self-hosted runners at the organization level.

## GitHub API Access

A GitHub Personal Access Token (PAT) has been provided for automation tasks within this organization.

**Note:** Ensure the PAT has the necessary scopes (`repo`, `workflow`, `admin:org`) for the tasks you intend to perform.

### Using the PAT for Repository Setup

You can use the `scripts/rollout-mcp.sh` script with this PAT to automatically configure multiple repositories.

```bash
export GITHUB_TOKEN="<YOUR_PROVIDED_PAT>"
./scripts/rollout-mcp.sh --org L6-N9 --repos "repo1,repo2"
```
