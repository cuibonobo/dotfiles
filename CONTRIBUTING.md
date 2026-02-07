# Contributing to Your Dotfiles

This guide helps you maintain and update your dotfiles repository.

## Making Changes

### 1. Edit Configuration Files

Edit files in their respective directories:
- `git/` - Git configurations
- `ssh/` - SSH configurations
- `shell/` - Shell configurations (bash, zsh)

### 2. Test Locally

Before committing changes, test the install script:

```bash
bash install.sh
```

### 3. Commit and Push

```bash
git add .
git commit -m "Description of changes"
git push
```

### 4. Test in Dev Container

After pushing:
1. Open a dev container
2. Delete the existing dotfiles: `rm -rf ~/dotfiles`
3. Rebuild the container: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"
4. Verify your changes work

## Best Practices

### Security
- **NEVER** commit private SSH keys or API tokens
- Review `.gitignore` before adding new files
- Use environment variables for secrets
- Check commits before pushing: `git diff --cached`

### Organization
- Keep configurations modular (one file per tool/service)
- Document any non-obvious settings
- Remove obsolete configurations

### Compatibility
- Test on different container images (Debian, Ubuntu, Alpine)
- Use POSIX-compatible shell syntax when possible
- Check if commands exist before using them in scripts

## Adding New Tools

To add configuration for a new tool:

1. Create a directory for the tool (e.g., `vim/`, `tmux/`)
2. Add configuration files
3. Update `install.sh` to copy/link the files
4. Document in README.md
5. Test the installation

Example for vim:

```bash
# In install.sh
echo ""
echo "📝 Installing Vim configuration..."
safe_copy "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc" 644
```

## Common Tasks

### Update Git User Info

Edit `git/.gitconfig`:
```bash
vim git/.gitconfig
```

### Add New SSH Host

Edit `ssh/config`:
```bash
vim ssh/config
```

### Add Shell Alias

Edit `shell/.bashrc` or `shell/.zshrc`:
```bash
vim shell/.bashrc
```

### Sync with Host System

To pull updated configs from your host:

```bash
# Copy from host (READ ONLY - do not run from repo directory)
cp ~/.gitconfig git/.gitconfig
cp ~/.ssh/config ssh/config
cp ~/.bashrc shell/.bashrc
# etc.
```

## Troubleshooting

### Install script fails
- Check file permissions
- Verify all paths in `install.sh`
- Run with bash explicitly: `bash -x install.sh` (debug mode)

### Git conflicts
- Pull before making changes: `git pull`
- Resolve conflicts carefully
- Test after resolving

### Changes not appearing in containers
- Verify files were committed and pushed
- Check VS Code settings for dotfiles repository URL
- Rebuild container completely
