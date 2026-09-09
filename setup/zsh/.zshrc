# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# ── Auto-update ──────────────────────────────────────────────
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 13

# ── Plugins ──────────────────────────────────────────────────
plugins=(
  git
  colored-man-pages
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  sudo
  autojump
  web-search
  jsontools
  dirhistory
)

source $ZSH/oh-my-zsh.sh

# ── User configuration ──────────────────────────────────────

# ── Histórico ────────────────────────────────────────────────
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# ── Completions ──────────────────────────────────────────────
CASE_SENSITIVE=false
HYPHEN_INSENSITIVE=true
COMPLETION_WAITING_DOTS="true"
zstyle ':omz:*' completion-menu-select-scroll 0

# ── Zsh Autosuggestions ─────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ── Syntax Highlighting Colors ───────────────────────────────
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=green,underline'

# ── FZF ──────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline --bind "ctrl-/:toggle-preview"'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :200 {}' 2>/dev/null"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f 2>/dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git 2>/dev/null || find . -type d 2>/dev/null'

# ── PATH ─────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.local/share/npm/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"
export EDITOR='vim'
export VISUAL='vim'

# ── Aliases Gerais ───────────────────────────────────────────
# eza (modern ls) ou ls tradicional
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --group-directories-first --git'
  alias la='eza -a --icons --group-directories-first'
  alias lt='eza -la --icons --sort=modified'
  alias l='eza -l --icons --group-directories-first'
  alias tree='eza --tree --level=2 --icons'
else
  alias ll='ls -lah --color=auto'
  alias la='ls -A --color=auto'
  alias lt='ls -lhtr --color=auto'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cls='clear'
alias j='autojump'
alias md='mkdir -p'
alias hist='history -i'

# Guia de comandos (com glow para formatação bonita)
GLOW=~/.local/bin/glow
alias comandos='$GLOW ~/tech-hub--dev.gabriellucas/setup/terminal/README.md'
alias cyberseg='$GLOW ~/tech-hub--dev.gabriellucas/setup/terminal/CYBERSEG.md'
alias guia='$GLOW ~/tech-hub--dev.gabriellucas/setup/terminal/README.md'
alias pentest='$GLOW ~/tech-hub--dev.gabriellucas/setup/terminal/CYBERSEG.md'

# zoxide (modern cd) ou cd tradicional
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# bat (modern cat) ou cat tradicional
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never --style=plain'
  alias catn='batcat --style=numbers'
  alias catp='batcat --style=numbers --color=always'
  alias batman='batcat --man'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never --style=plain'
  alias catn='bat --style=numbers'
  alias catp='bat --style=numbers --color=always'
  alias batman='bat --man'
fi

# fd (se disponível)
if command -v fdfind &>/dev/null; then
  alias fd='fdfind'
fi

# grep com cores
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Segurança
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias ln='ln -iv'

# ── Aliases Git ──────────────────────────────────────────────
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -20 --graph'
alias glog='git log --oneline --graph --decorate'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull --rebase'
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gb='git branch -v'
alias gco='git checkout'
alias gsw='git switch'
alias gst='git stash'
alias gstp='git stash pop'
alias gcp='git cherry-pick'
alias grb='git rebase'
alias gamend='git commit --amend --no-edit'
alias gunstage='git reset HEAD'
alias gclean='git clean -fd'
alias glast='git log -1 HEAD --stat'
alias gcount='git shortlog -sn'

# Git workflows
alias wip='git add -A && git commit -m "wip: work in progress"'
alias fixup='git commit --amend --no-edit'
alias squash='git rebase -i HEAD~2'

# ── Aliases Rede ─────────────────────────────────────────────
alias myip='curl -s ifconfig.me && echo'
alias localip='hostname -I | awk "{print \$1}"'
alias ports='netstat -tulanp 2>/dev/null || ss -tulanp'
alias ping3='ping -c 3'
alias pingf='ping -c 100 -i 0.2'
alias listen='ss -tlnp'
alias ipinfo='curl -s ipinfo.io'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# ── Aliases Docker ───────────────────────────────────────────
alias dk='docker'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dkimg='docker images'
alias dkrm='docker rm $(docker ps -aq) 2>/dev/null'
alias dkrmimg='docker rmi $(docker images -q) 2>/dev/null'
alias dkc='docker compose'
alias dkcup='docker compose up -d'
alias dkcd='docker compose down'
alias dkclogs='docker compose logs -f'
alias dkexec='docker compose exec'

# ── Aliases System ───────────────────────────────────────────
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install -y'
alias search='apt search'
alias disk='df -h'
alias mem='free -h'
alias top='htop 2>/dev/null || top'
alias jobs='jobs -l'
alias path='echo $PATH | tr ":" "\n"'

# ── Aliases Dev ──────────────────────────────────────────────
alias tldrf='tldr --list 2>/dev/null | fzf'
alias jup='jupyter notebook 2>/dev/null &'
alias python='python3'
alias pip='pip3'
alias serve='python3 -m http.server'

# ── Functions ────────────────────────────────────────────────
# Criar pasta e entrar nela
mkcd() { mkdir -p "$1" && cd "$1"; }

# Backup rápido de arquivo
bak() { cp "$1"{,.bak.$(date +%Y%m%d-%H%M%S)}; }

# Extrair qualquer arquivo
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.tar.xz) tar xJf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *.xz) unxz "$1" ;;
      *) echo "'$1' não pode ser extraído via extract()" ;;
    esac
  else
    echo "'$1' não é um arquivo válido"
  fi
}

# Buscar no histórico
h() {
  if [ -z "$1" ]; then
    history 30
  else
    history | grep "$1"
  fi
}

# Git: criar repo e commit inicial
ginit() {
  git init && git add -A && git commit -m "feat: initial commit"
}

# Git: sync com remote
gsync() {
  git fetch origin && git reset --hard origin/$(git branch --show-current)
}

# ── Git Delta (diff bonito) ──────────────────────────────────
if command -v delta &>/dev/null; then
  export GIT_PAGER="delta"
  export DELTA_FEATURES="side-by-side line-numbers syntax-highlighting navigate"
fi

# ── WSL-specific optimizations ───────────────────────────────
if grep -qi microsoft /proc/version 2>/dev/null; then
  # WSL2 optimizations
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
  export LIBGL_ALWAYS_INDIRECT=1
  # Clipboard integration with Windows
  alias pbcopy='clip.exe'
  alias pbpaste='powershell.exe -command "Get-Clipboard"'
fi

# ── Key bindings ─────────────────────────────────────────────
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[C' forward-word
bindkey '^[[D' backward-word
bindkey '^H' backward-kill-word
bindkey '^[[3~' delete-char

# ── Prompt ───────────────────────────────────────────────────
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
