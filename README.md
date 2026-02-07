# Dotfiles for Dev Containers

This repository contains my personal dotfiles configuration, optimized for use with VS Code dev containers.

## What's Included

- **Git configuration** - User name, email, and default branch settings
- **Global gitignore** - Ignore common files across all repos (.claude files, editor configs, OS files, etc.)
- **Shell configurations** - Bash and Zsh settings with custom aliases

**Note:** SSH config is intentionally NOT included for security reasons (it would expose internal network topology, IPs, and ports).

## Setup for Dev Containers

### Automatic Setup (Recommended)

Configure VS Code to automatically install these dotfiles in all dev containers:

1. Open VS Code Settings (User level)
2. Add the following to your `settings.json`:

```json
{
  "dotfiles.repository": "https://github.com/cuibonobo/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

### Manual Installation

You can also manually install these dotfiles:

```bash
cd ~
git clone https://github.com/cuibonobo/dotfiles.git
cd dotfiles
./install.sh
```

## What Gets Installed

The `install.sh` script will:

1. Copy `.gitconfig` to your home directory
2. Install global gitignore to `~/.config/git/ignore` (ignores .claude files, editor configs, etc.)
3. Create `~/.ssh` directory with proper permissions
4. Copy shell configurations (`.bashrc`, `.zshrc`, etc.)
5. Set appropriate file permissions
6. Preserve any existing configurations via timestamped backups

## SSH Configuration & Keys

**SSH config and keys are NOT stored in this repository for security reasons.**

Why? Your SSH config reveals:
- Network topology and internal IP addresses
- Custom SSH ports
- Server hostnames and aliases
- Infrastructure details

This information shouldn't be in a public repository.

### How to handle SSH in dev containers:

**Option 1: SSH Agent Forwarding (Recommended)**
- VS Code automatically forwards your SSH agent to dev containers
- Your keys and config stay securely on your host machine
- Works seamlessly with GitHub, private servers, etc.
- No additional configuration needed!

**Option 2: Mount SSH Directory**
If you need your full SSH config in containers, add to your `devcontainer.json`:
```json
{
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached"
  ]
}
```
⚠️ **Warning:** Only use this if you understand the security implications.

**Option 3: Per-Project SSH Config**
Create project-specific minimal SSH configs in each dev container as needed.

## Structure

```
.
├── README.md           # This file
├── INSTALL.md          # Detailed instructions
├── CONTRIBUTING.md     # Maintenance guide
├── install.sh          # Installation script
├── .gitignore          # Prevent committing sensitive files to this repo
├── .editorconfig       # Editor configuration
├── git/
│   ├── .gitconfig      # Git user configuration
│   └── ignore          # Global gitignore (installed to ~/.config/git/ignore)
└── shell/
    ├── .bashrc         # Bash configuration
    ├── .bash_profile   # Bash profile
    ├── .zshrc          # Zsh configuration
    └── .zprofile       # Zsh profile
```

## Troubleshooting

### Git config not applying

Ensure the install script ran successfully. Check logs in the dev container terminal.

### SSH not working

1. Verify SSH agent forwarding is enabled in VS Code (it's automatic)
2. Test with: `ssh-add -l` (should show your keys from host)
3. Test GitHub: `ssh -T git@github.com`
4. If needed, mount your SSH directory (see SSH Configuration section above)

### Permission issues

The install script sets permissions automatically, but if you encounter issues:

```bash
chmod 700 ~/.ssh
chmod 644 ~/.gitconfig
```
