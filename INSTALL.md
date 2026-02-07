# Installation Instructions

## For Dev Containers (Automatic)

### Step 1: Configure VS Code

Add these settings to your VS Code User Settings (`settings.json`):

```json
{
  "dotfiles.repository": "https://github.com/cuibonobo/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

To open settings in VS Code:
- Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
- Type "Preferences: Open User Settings (JSON)"
- Add the configuration above

### Step 2: Test in a dev container

1. Open any project with a dev container configuration
2. Reopen in container: `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"
3. VS Code will automatically clone your dotfiles and run `install.sh`
4. Check the terminal output to verify installation

## Manual Installation (for testing)

To test the install script locally before using it in dev containers:

```bash
bash install.sh
```

**Note:** Make the script executable first:
```bash
chmod +x install.sh
```

## SSH Configuration & Keys

This dotfiles repo does NOT contain SSH configuration or keys for security reasons.

**Why?** SSH config files reveal internal network topology, IP addresses, custom ports, and infrastructure details that shouldn't be public.

### Option 1: SSH Agent Forwarding (Recommended)

VS Code automatically forwards your SSH agent into dev containers. No additional configuration needed!

Your existing SSH keys on the host machine will work inside containers.

### Option 2: Mount SSH Directory

If you prefer to mount your SSH keys directly, add to your `devcontainer.json`:

```json
{
  "mounts": [
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached"
  ],
  "remoteUser": "vscode"
}
```

**Warning:** Only do this if you understand the security implications.

## Verification

After installation, verify everything works:

```bash
# Check Git configuration
git config --list | grep user

# Check SSH agent forwarding
ssh-add -l

# Check shell configuration
cat ~/.bashrc
```

## Troubleshooting

### Git config not applying
- Check if `~/.gitconfig` exists
- Run: `cat ~/.gitconfig`
- Verify user name and email are correct

### SSH issues
- Verify SSH agent forwarding: `ssh-add -l` (should show your keys from host)
- Test GitHub connection: `ssh -T git@github.com`
- If needed, mount your SSH directory (see Option 2 above)

### Permission errors
- SSH directory should be 700: `chmod 700 ~/.ssh` (created automatically by install script)
