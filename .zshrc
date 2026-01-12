# --- Fastfetch (once per session) ---
if command -v fastfetch >/dev/null 2>&1 && [ -z "$FASTFETCH_SHOWN" ]; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi

# --- Powerlevel10k instant prompt (must stay near top) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Homebrew prefix (macOS / Linux portable) ---
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
fi

# --- Zinit bootstrap ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


# Add site-functions from brew (macOS) if present
if [[ -n "$BREW_PREFIX" && -d "$BREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath+="$BREW_PREFIX/share/zsh/site-functions"
fi
# Your custom completions
[[ -d "$HOME/.zfunc" ]] && fpath+="$HOME/.zfunc"

# --- Secure $fpath before initializing completion (prevents "insecure" warnings) ---
# Remove group/other write perms silently where possible
for d in $fpath; do chmod go-w "$d" 2>/dev/null || true; done

# --- Initialize completion ONCE (Ubuntu-like behavior) ---
autoload -Uz compinit
compinit -i

# --- Plugins that add completions (these affect $fpath) ---
zinit light zsh-users/zsh-completions
zinit snippet OMZP::git
# Docker completion script:
zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker

# --- Completion UI tuning ---
zmodload zsh/complist
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# --- fzf-tab integrates with completion but doesn't hijack Tab ---
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-min-height 10

# --- Other plugins (order no longer affects completion) ---
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search

# --- Keep Tab as normal completion (Ubuntu-like) ---
bindkey -e
bindkey -M emacs '^I' expand-or-complete
bindkey -M viins  '^I' expand-or-complete

# --- Keep fzf keybindings but REMOVE its Tab override ---
# (On macOS, brew's fzf install often binds Tab; strip that line.)
if command -v fzf >/dev/null 2>&1; then
  eval "$(
    fzf --zsh | sed '/bindkey .* "\\^I"/d'
  )"
fi

# --- zoxide (your custom "cd" command) ---
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# --- Prompt theme ---
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- History ---
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_dups hist_save_no_dups hist_ignore_all_dups hist_find_no_dups
setopt INTERACTIVE_COMMENTS

# --- PATH & editors ---
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
export EDITOR=vim

# --- NVM (optional; bash_completion is for bash, so leave it commented) ---
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
# [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# --- Cross-platform 'ls' and 'll' ---
if command -v gls >/dev/null 2>&1; then
  # GNU ls installed as gls (macOS via coreutils)
  alias ls='gls --color=auto -Fh'
  alias ll='gls -lah --color=auto'
else
  # BSD ls (macOS default) or Linux without coreutils alias
  export CLICOLOR=1
  alias ll='ls -lah'
fi

# --- Aliases ---
alias ~='cd ~'
alias md='mkdir -p'
alias vi='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
