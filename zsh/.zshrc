# ~/.zshrc - Zsh configuration

# ===== Oh My Zsh Configuration =====
# (Managed by NixOS, but we can add customizations here)

# Source zsh-autosuggestions (NixOS package)
if [ -f /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Source zsh-syntax-highlighting (NixOS package) - must be last
if [ -f /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ===== Autosuggestion Settings =====
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion

# ===== History Configuration =====
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # Write timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_VERIFY               # Show command before executing from history
setopt SHARE_HISTORY             # Share history between sessions

# ===== FZF Configuration =====
if command -v fzf &> /dev/null; then
  # Use fd for faster file finding if available
  if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  fi

  export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --preview 'head -100 {}'
    --bind 'ctrl-/:toggle-preview'
  "

  # Source fzf keybindings if available
  [ -f /run/current-system/sw/share/fzf/key-bindings.zsh ] && source /run/current-system/sw/share/fzf/key-bindings.zsh
  [ -f /run/current-system/sw/share/fzf/completion.zsh ] && source /run/current-system/sw/share/fzf/completion.zsh
fi

# ===== Useful Aliases =====
# Modern replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons --level=2'
alias cat='bat --style=auto 2>/dev/null || cat'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gpu='git push'
alias gpuo='git push -u origin'
alias gp='git pull'
alias gpl='git pull'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gl='git log --oneline --graph'
alias gla='git log --oneline --graph --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gcl='git clone'
alias grv='git remote -v'
alias grs='git reset'
alias grsh='git reset --hard'
alias gcp='git cherry-pick'
alias gch='git checkout'
# Docker & Docker Compose
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dcp='docker compose pull'
alias dcb='docker compose build'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dprune='docker system prune -af'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# NixOS specific
alias nrs='sudo nixos-rebuild switch'
alias nrt='sudo nixos-rebuild test'
alias nrb='sudo nixos-rebuild boot'
alias ncg='nix-collect-garbage -d'
alias nedit='sudo nano /etc/nixos/configuration.nix'

# Quick edit configs
alias zshrc='${EDITOR:-vim} ~/.zshrc && source ~/.zshrc'
alias hyprconf='${EDITOR:-vim} ~/.config/hypr/hyprland.conf'

# ===== Key Bindings =====
bindkey '^[[A' history-search-backward  # Up arrow: search history backward
bindkey '^[[B' history-search-forward   # Down arrow: search history forward
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End
bindkey '^[[3~' delete-char             # Delete
bindkey '^H' backward-kill-word         # Ctrl+Backspace: delete word

# ===== Completion System =====
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ===== Directory Options =====
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories to stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt CDABLE_VARS          # cd into variable values

# ===== Misc Options =====
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt NO_BEEP             # Disable beep
setopt CORRECT             # Suggest corrections

# ===== Custom Functions =====
# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find and open file with fzf
fopen() {
  local file
  file=$(fzf --preview 'head -100 {}')
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# Quick search in current directory
ff() {
  grep -r "$1" . 2>/dev/null
}

# ===== PATH additions =====
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# ===== Zoxide (smarter cd) =====
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'      # Replace cd with zoxide
  alias cdi='zi'    # Interactive directory selection
fi

# ===== Atuin (magical shell history) =====
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
  # Ctrl+R now opens atuin's fuzzy history search
fi

# ===== Welcome message =====
# Only run fastfetch in real interactive terminals (not inside TUI apps like OpenCode)
if command -v fastfetch &> /dev/null && [[ $TERM != "dumb" ]] && [[ -z "$OPENCODE" ]] && [[ -z "$INSIDE_EMACS" ]] && [[ -z "$VSCODE_INJECTION" ]]; then
  fastfetch --logo small
fi
