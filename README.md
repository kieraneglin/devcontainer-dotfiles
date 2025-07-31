# devcontainer-dotfiles

Personal dotfiles configuration for use in devcontainers and GitHub Codespaces.

## Features

- **Zsh Shell**: Automatically installs and sets Zsh as the default shell
- **Oh My Zsh**: Installs Oh My Zsh with auto-update enabled
- **Pure Prompt**: Beautiful, minimal prompt theme
- **Custom Aliases**: Pre-configured aliases for git, docker, and common commands
- **Flexible Plugin System**: Default plugins with support for project-specific additions

## Installation

### Basic Installation

Add this to your devcontainer configuration:

```json
{
  "postCreateCommand": "bash -c \"$(curl -fsSL https://raw.githubusercontent.com/kieraneglin/devcontainer-dotfiles/master/install.sh)\""
}
```

### With Additional Plugins

To add project-specific Zsh plugins, set the `ADDITIONAL_ZSH_PLUGINS` environment variable:

```json
{
  "containerEnv": {
    "ADDITIONAL_ZSH_PLUGINS": "rails\npython\nnpm"
  },
  "postCreateCommand": "bash -c \"$(curl -fsSL https://raw.githubusercontent.com/kieraneglin/devcontainer-dotfiles/master/install.sh)\""
}
```

### Manual Installation

1. Clone this repository
2. Run the install script:
   ```bash
   ./install.sh
   ```

## Default Plugins

The following Zsh plugins are installed by default:

- `git` - Git aliases and functions
- `sudo` - ESC twice to add sudo to command
- `history` - History aliases
- `colored-man-pages` - Colorize man pages
- `command-not-found` - Suggest packages for unknown commands
- `z` - Jump to frequently used directories

## Customization

### Adding Aliases

Edit the `aliases` file to add your personal aliases. The file is well-commented with examples.

### Adding Plugins

You can add additional plugins in two ways:

1. **Per-project**: Set the `ADDITIONAL_ZSH_PLUGINS` environment variable (see installation examples above)
2. **Globally**: Edit the `zshrc` file and add plugins to the `DEFAULT_PLUGINS` array

### Modifying Configuration

All configuration files can be customized:

- `zshrc` - Main Zsh configuration
- `aliases` - Custom command aliases
- `install.sh` - Installation script

## File Structure

```
.
├── README.md       # This file
├── install.sh      # Installation script
├── zshrc          # Zsh configuration
└── aliases        # Custom aliases
```

## Requirements

- Linux-based container (Ubuntu, Debian, Alpine, etc.)
- Internet connection for downloading dependencies
- Sudo access (for installing packages)