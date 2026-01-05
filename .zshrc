# Enable colors
autoload -U colors && colors

# Prompt customization with git branch
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{cyan}%n@%m%f %F{yellow}%1~%f%F{green}${vcs_info_msg_0_}%f %# '

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY           # Share history across sessions
setopt HIST_IGNORE_DUPS        # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS    # Delete old duplicates
setopt HIST_FIND_NO_DUPS       # Don't display duplicates in search
setopt HIST_IGNORE_SPACE       # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS      # Remove extra blanks

# Directory navigation
setopt AUTO_CD                 # Type directory name to cd
setopt AUTO_PUSHD              # Make cd push to directory stack
setopt PUSHD_IGNORE_DUPS       # Don't push duplicates
setopt PUSHD_SILENT            # Don't print stack after pushd/popd

# Completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                          # Visual menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'        # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion
zstyle ':completion:*' group-name ''                        # Group results
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
setopt COMPLETE_IN_WORD        # Complete from both ends
setopt ALWAYS_TO_END           # Move cursor after completion

# Correction
#setopt CORRECT                 # Spelling correction for commands
#setopt CORRECT_ALL             # Spelling correction for arguments

# Enable advanced globbing
setopt EXTENDED_GLOB           # Use advanced wildcards

#
alias config='/opt/homebrew/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

eval "$(direnv hook zsh)"

alias icat="kitten icat"


# Emacs aliases
alias e='emacs -nw'
alias ec='emacsclient -nw'
alias ecg='emacsclient -c'  # GUI emacs
alias ek='emacsclient -e "(kill-emacs)"'  # Kill emacs daemon

# Start emacs daemon if not running
emacs-daemon() {
  if ! pgrep -f "emacs --daemon" > /dev/null; then
    emacs --daemon
    echo "Emacs daemon started"
  else
    echo "Emacs daemon already running"
  fi
}

# Quick edit functions with emacs
ef() {
  emacs -nw $(find . -type f | grep -v ".git" | head -100 | fzf-tmux -d 15)
}

# Open file at specific line (useful for compiler errors)
# Usage: el filename:linenumber
el() {
  local file_line="$1"
  local file="${file_line%%:*}"
  local line="${file_line##*:}"
  if [[ "$line" =~ ^[0-9]+$ ]]; then
    emacs -nw "+$line" "$file"
  else
    emacs -nw "$file"
  fi
}

# Open magit in current directory
magit() {
  emacsclient -nw -e "(magit-status)"
}


# Neovim configuration
export VISUAL='nvim'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Neovim aliases and functions
alias nv='nvim'
alias nvim-clean='nvim --clean'
alias nvim-config='nvim ~/.config/nvim/init.lua'

# Quick edit with nvim
vf() {
  nvim $(find . -type f | grep -v ".git" | head -100)
}

# Open file at specific line
vl() {
  local file_line="$1"
  local file="${file_line%%:*}"
  local line="${file_line##*:}"
  if [[ "$line" =~ ^[0-9]+$ ]]; then
    nvim "+$line" "$file"
  else
    nvim "$file"
  fi
}

# Quick edit common config files
alias vzsh='nvim ~/.zshrc'
alias vze='nvim ~/.zshenv'
alias vzp='nvim ~/.zprofile'
alias vtmux='nvim ~/.tmux.conf'
alias vgit='nvim ~/.gitconfig'

# Open nvim with git modified files
vgm() {
  nvim $(git status --short | awk '{print $2}')
}

# Open nvim with git conflict files
vgc() {
  nvim $(git diff --name-only --diff-filter=U)
}

# Diff two files in nvim
vdiff() {
  nvim -d "$1" "$2"
}


# Tmux aliases
alias t='tmux'
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias tka='tmux kill-session -a'  # Kill all but current


# Smart tmux session management
tn() {
  if [ -n "$1" ]; then
    tmux new-session -s "$1"
  else
    tmux new-session -s "$(basename $(pwd))"
  fi
}

# Attach or create session
tac() {
  local session="$1"
  if [ -z "$session" ]; then
    session="$(basename $(pwd))"
  fi
  
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux attach -t "$session"
  else
    tmux new-session -s "$session"
  fi
}

# Kill all detached sessions
tkd() {
  tmux list-sessions | grep -v attached | cut -d: -f1 | xargs -t -n1 tmux kill-session -t
}

# Tmux session picker
tsp() {
  local sessions
  sessions=(${(f)"$(tmux list-sessions -F '#S')"})
  if [ ${#sessions[@]} -eq 0 ]; then
    echo "No tmux sessions found"
    return
  fi
  echo "Select session:"
  select session in $sessions; do
    if [[ -n "$session" ]]; then
      tmux attach -t "$session"
      break
    fi
  done
}

# Auto-attach to tmux on terminal start (optional)
# Uncomment if you want this behavior
#if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#  tmux attach -t default || tmux new -s default
#fi

# Better tmux window/pane names
tmux-title() {
  printf "\033]2;%s\033\\" "$1"
}


# Create and cd into directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar x $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find file by name
ff() {
  find . -type f -iname "*$1*"
}

# Find directory by name
fd() {
  find . -type d -iname "*$1*"
}

# Quick backup of a file
backup() {
  cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}

# Show PATH in readable format
path() {
  echo $PATH | tr ':' '\n'
}

p() {
  local project_dir="${HOME}/Projects"
  if [ -d "$project_dir/$1" ]; then
    cd "$project_dir/$1"
  else
    echo "Project not found: $1"
    echo "Available projects:"
    ls -1 "$project_dir"
  fi
}



# bun completions
[ -s "/Users/mohamedabdellahi/.bun/_bun" ] && source "/Users/mohamedabdellahi/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
