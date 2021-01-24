alias help='cat ~/.aliases.zsh'
alias aliases='vim ~/.aliases.zsh'

if [[ $OSTYPE == darwin* ]]; then
  alias browse="open -a /Applications/Google\ Chrome.app"
  alias wp='cd ~/Documents/Github'
elif [[ $OSTYPE == linux-gnu* ]]; then
  alias wp='cd /mnt/c/Users/Andrea/Documents/Github/'
fi

alias my='sudo chown -R `id -u`'

# SHORTCUTS
alias c='clear'
alias h='history'
alias reload='exec zsh -l'

# APT GET Stuff
alias u='sudo apt-get update && sudo apt-get upgrade -y'
alias up='sudo apt-get update'
alias ug='sudo apt-get upgrade -y'
alias i='sudo apt-get install -y'
alias rem='sudo apt-get remove'
alias purge='sudo apt-get purge'
alias ar='sudo apt-get autoremove -y'
alias aar='sudo add-apt-repository -y'
alias dug='sudo apt-get dist-upgrade -y' ../..

# EXTRACTING Stuff
alias tgz='tar -cvvzf'
alias tbz2='tar -cvvjf'
alias utgz='tar -xvvzf'
alias utbz2='tar -xvvjf'
alias mktar='tar -cvvf'
alias untar='tar -xvvf'

# PROCESS Stuff
alias pid='ps -A -e -l | grep'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# LS Stuff
alias ls='ls -F --color=always --group-directories-first'
alias ll='ls -la'
alias ld='ls -F | grep "/$"'
alias la='ls -CA'
alias l='ls'

# GIT Stuff
alias gs='git status'
alias gc='git commit -m'
alias gca='git commit -am'
alias ga='git add'
alias gaa='git add .'
alias -s git="git clone"

# CD Stuff
alias .='cd . && ld'
alias ..='cd .. && ld'
alias ...='cd ... && ld'