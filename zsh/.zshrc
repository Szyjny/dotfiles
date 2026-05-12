if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# ————————————————————————
# Uzupełnianie
# ————————————————————————
autoload -U compinit && compinit
autoload -U colors && colors

# ————————————————————————
# Historia — konfiguracja
# ————————————————————————

# plik historii
export HISTFILE="${HOME}/.zsh_history"
# ile linii w pamięci (sesja)
export HISTSIZE=100000
# ile linii zapisywać do pliku
export SAVEHIST=100000

# Opcje historii
setopt APPEND_HISTORY       # dołączaj historię, nie nadpisuj
setopt SHARE_HISTORY        # importuj nowe wpisy z pliku oraz zapisuj od razu :contentReference[oaicite:1]{index=1}

setopt HIST_IGNORE_DUPS      # nie zapisuj jeśli identyczne jak poprzednia linia
setopt HIST_IGNORE_ALL_DUPS  # usuń stare duplikaty jeśli pojawi się nowy
setopt HIST_IGNORE_SPACE     # nie zapisuj komend rozpoczynających się spacją
setopt HIST_REDUCE_BLANKS    # usuń zbędne spacje
setopt HIST_FIND_NO_DUPS     # przy wyszukiwaniu nie pokazuj duplikatów

# ————————————————————————
# Ustawienia (inne powłokowe)
# ————————————————————————
setopt EXTENDED_GLOB
setopt PROMPT_SUBST
export EDITOR="nvim"

# ————————————————————————
# Aliasy
# ————————————————————————
alias n='nvim'
alias cd='z'
alias cls='clear'

alias ff='fastfetch'
alias ":q"='exit'

alias ld='lazydocker'
alias lg='lazygit'
alias tt='taskwarrior-tui'

alias ls='eza -lh --group-directories-first --icons=auto'
alias l='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias ltree='lt -a'

alias b='cd ..'
alias b2='cd ../..'
alias b3='cd ../../..'
alias b4='cd ../../../..'

alias core="ulimit -c unlimited"
function tldr() {
    command tldr -s $@
    printf "\033[?25h"
}

alias am="$HOME/.local/bin/unpack_music.sh"
alias rd="$HOME/.local/bin/required_deps.sh"
alias mi="$HOME/.local/bin/manual_installed_packages.sh"
alias update="$HOME/.local/bin/update.sh"
alias sc="$HOME/.local/bin/szkopul-cli"

# ————————————————————————
# Funkcje
# ————————————————————————
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  local cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function cpp() {
    local main_file="${1}"
    shift

    g++ "$main_file" -o "output"
    ./"output" "$@"
    rm ./"output"
}

function ccpp() {
  #!/usr/bin/env bash
  set -e

  command -v tmux >/dev/null 2>&1 || { echo "tmux is not installed. Exiting."; return 1; }

  local SESH="Code"
  local WINDOW="Nvim"
  local FILENAME="index.cpp"
  local LOCAL_COPY="$HOME/.local/bin/$FILENAME"

  if tmux has-session -t "$SESH" 2>/dev/null; then
    tmux kill-session -t "$SESH"
  fi

  if [ ! -f "$FILENAME" ]; then
    if [ -f "$LOCAL_COPY" ]; then
      cp "$LOCAL_COPY" "./$FILENAME"
    else
      echo "No local copy of $FILENAME found in $LOCAL_COPY. Aborting."
      return 1
    fi
  fi

  tmux new-session -d -s "$SESH" -n "$WINDOW"
  tmux split-window -h -t "$SESH:$WINDOW"

  tmux select-pane -t "$SESH:$WINDOW.0"
  tmux send-keys -t "$SESH:$WINDOW.0" "nvim $FILENAME" C-m

  tmux select-window -t "$SESH:$WINDOW"

  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESH"
  else
    tmux attach-session -t "$SESH"
  fi
}

function ns() {
    local FILENAME="$1"
    local LOCAL_COPY="$HOME/.local/bin/index.cpp"

    if [[ -z "$FILENAME" ]]; then
        echo "Usage: ns <filename>"
        return 1
    fi

    if [[ -f "$FILENAME" ]]; then
        echo "Error: $FILENAME already exists."
        return 1
    fi

    cp "$LOCAL_COPY" "$FILENAME"
    nvim "$FILENAME" +24
}

function tmux-new() {
  local session_name="$1"
  if [ -z "$session_name" ]; then
    return 1
  fi

  tmux has-session -t "$session_name" 2>/dev/null
  if [ $? -eq 0 ]; then
  else
    tmux new-session -d -s "$session_name" || return 1
  fi

  tmux switch-client -t "$session_name"
}

# ————————————————————————
# Source
# ————————————————————————
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/nvm/init-nvm.sh

# ————————————————————————
# Export
# ————————————————————————
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/mise/installs/go/1.25.4/bin:$PATH"

export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

export ANDROID_NDK_ROOT="$ANDROID_SDK_ROOT/ndk/29.0.14206865"
export PATH="$PATH:$ANDROID_NDK_ROOT"

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH

export PATH="$HOME/.config/emacs/bin:$PATH"

# ————————————————————————
# Edit command via nvim
# ————————————————————————
setopt ignore_eof
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^D' edit-command-line

export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# bun completions
[ -s "/home/matt/.bun/_bun" ] && source "/home/matt/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
