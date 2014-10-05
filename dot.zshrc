export LC_COLLATE=C
export LC_MESSAGES=C
export LC_TIME=C
export EDITOR=vim

typeset -U path
path=(${HOME}/.opam/system/bin(N-/) ${HOME}/.cabal/bin(N-/) ${HOME}/bin(N-/) ${path})

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
WORDCHARS=${WORDCHARS:s,/,,}

autoload -Uz promptinit
promptinit
PROMPT='%(?..%B%F{red}[%?]%f%b)%n@%m%# '
RPROMPT='%F{green}%~%f'

autoload -Uz compinit
compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

bindkey -e

alias ,.='source ~/.zshrc'
alias ,,='vim ~/.zshrc'
alias ls='ls -F --color=auto'
alias ll='ls -hl'
alias la='ls -A'
alias lr='ls -R'
alias j='jobs -l'
alias h='history'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias path='echo ${PATH//:/\\n}'

alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g V='| vim -R -'

function mkcd() { mkdir -p "$1" && cd "$1"; }
function passwd-gen() { cat /dev/urandom | tr -dc '[:alnum:]' | fold -b ${1:-8} | head -n10; }
function macaddr-gen() { printf '52:54:00:%02x:%02x:%02x\n' $((RANDOM & 0xff)) $((RANDOM & 0xff)) $((RANDOM & 0xff)); }
