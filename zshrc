# Personal Zsh configuration for devcontainers
# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme to Pure
ZSH_THEME=""

# Enable auto-update for Oh My Zsh
zstyle ':omz:update' mode auto

# Default plugins (always loaded)
DEFAULT_PLUGINS=(
    git
    sudo
    history
    colored-man-pages
    command-not-found
    z
    zsh-syntax-highlighting
)

# Load additional plugins if specified
ADDITIONAL_PLUGINS=()
if [ -f "$HOME/.additional_zsh_plugins" ]; then
    while IFS= read -r plugin; do
        if [ ! -z "$plugin" ]; then
            ADDITIONAL_PLUGINS+=("$plugin")
        fi
    done < "$HOME/.additional_zsh_plugins"
fi

# Combine default and additional plugins
plugins=("${DEFAULT_PLUGINS[@]}" "${ADDITIONAL_PLUGINS[@]}")

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Initialize Pure Prompt
fpath+=("$ZSH/custom/themes/pure")
autoload -U promptinit; promptinit

# Pure prompt customization for better visuals
zstyle ':prompt:pure:prompt:success' color green
zstyle ':prompt:pure:prompt:error' color red
zstyle ':prompt:pure:prompt:continuation' color yellow
zstyle ':prompt:pure:path' color blue
zstyle ':prompt:pure:git:branch' color magenta
zstyle ':prompt:pure:git:action' color yellow
zstyle ':prompt:pure:git:dirty' color red
zstyle ':prompt:pure:host' color cyan
zstyle ':prompt:pure:user' color default
zstyle ':prompt:pure:user:root' color red
zstyle ':prompt:pure:virtualenv' color yellow
zstyle ':prompt:pure:execution_time' color yellow

# Show username@hostname when in SSH or container
zstyle ':prompt:pure:user' show yes
zstyle ':prompt:pure:host' show yes

# Show execution time for commands longer than 5 seconds
zstyle ':prompt:pure:execution_time' show yes
zstyle ':prompt:pure:execution_time:min' 5

prompt pure

# Load custom aliases
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi

# User configuration
export LANG=en_US.UTF-8
export EDITOR='code'

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Key bindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
