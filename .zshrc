# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/paschalis/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias install="sudo pacman -S"
alias search="sudo pacman -Ss"
alias update="sudo pacman -Sy"
alias upgrade="sudo pacman -Syu"
alias remove="sudo pacman -R"
alias orphans="pacman -Qqt"
alias ls='ls -hN --color=auto --group-directories-first'
alias progs="(pacman -Qet && pacman -Qm) | sort -u"
alias config="nano ~/.config/i3/config"

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)        tar xjf $1        ;;
            *.tar.gz)         tar xzf $1        ;;
            *.bz2)            bunzip2 $1        ;;
            *.rar)            unrar x $1        ;;
            *.gz)             gunzip $1         ;;
            *.tar)            tar xf $1         ;;
            *.tbz2)           tar xjf $1        ;;
            *.tgz)            tar xzf $1        ;;
            *.zip)            unzip $1          ;;
            *.Z)              uncompress $1     ;;
            *.7z)             7zr e $1          ;;
            *)                echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
