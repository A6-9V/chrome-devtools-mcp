# CI/CD Runner Configuration

## Configuration Details

- **Local Config Path:** `C:\Users\USER\Dropbox\vps-config`
- **Runner Settings URL:** `https://forge.mql5.io/LengKundee/ZOLO-A6-9VxNUNA-/settings/actions/runners?sort=newest`
- **Repository URL:** `https://forge.mql5.io/LengKundee/ZOLO-A6-9VxNUNA-`

> **Note:** The registration token is sensitive and should not be committed. Please provide it when running the setup scripts.

## Setup Instructions

The repository appears to be hosted on a Gitea/Forgejo instance (`forge.mql5.io`). Therefore, we use `act_runner`.

### Linux / macOS

Use the `setup-act-runner.sh` script.

```bash
chmod +x setup-act-runner.sh
# Run with your token
./setup-act-runner.sh --url "https://forge.mql5.io/LengKundee/ZOLO-A6-9VxNUNA-" --token "<YOUR_TOKEN_HERE>"
```

### Windows

Use the `setup-act-runner.ps1` script in PowerShell.

```powershell
# Run with your token
.\setup-act-runner.ps1 -Url "https://forge.mql5.io/LengKundee/ZOLO-A6-9VxNUNA-" -Token "<YOUR_TOKEN_HERE>"
```
