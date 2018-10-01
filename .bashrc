# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# To temporarily bypass an alias, we preceed the command with a \
# EG:  the ls command is aliased, but to use the normal ls command you would
# type \ls
#---------------------------------------------------------------------------

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;35m\]\h:\[\033[37;1m\]\$\[\033[01;34m\]\w/\[\033[00m\]'
PS1="\[\033[1;34m\]┌─[\[\033[0m\033[1;32m\]\u\[\033[0m\]@\[\033[1;35m\]\h\[\033[0m\033[1;34m\]]-[\[\033[0m\]\#\[\033[1;34m\]]-[\[\033[0m\]\t\[\033[1;34m\]]\n\[\033[1;34m\]└─[\[\033[0m\]\w\[\033[1;34m\]]-[\[\033[0m\033[1;35m\]\$\[\033[0m\033[1;34m\]]>\[\033[0m\]"

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi

# sudo hint
if [ ! -e $HOME/.sudo_as_admin_successful ]; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ]; then
	function command_not_found_handle {
                /usr/bin/python /usr/lib/command-not-found -- $1
                return $?
	}
fi

# asks for confirmation everytime 'rm' is used
alias rm='rm -iv'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#netinfo - shows network information for your system
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=( `lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | grep "Current IP Address" | cut -d":" -f2 | cut -d" " -f2` )
echo "${myip}"
echo "---------------------------------------------------"
}

miso()#mount iso file
{
_mountpoint=~/Documents/iso
if [ -z $1 ]; then
  echo -e "usage:\tmiso file.iso\n\tmiso -u"
elif [ $1 = "-u" ]; then
  sudo umount $_mountpoint && echo "$_mountpoint unmounted."
elif [ -r $1 ] && [ ! -z `echo $1 | grep -i .iso$` ]; then
  if [ `ls $_mountpoint | wc -w` -ne 0 ]; then
    echo "error: $_mountpoint is not empty."
  else
    sudo mount -o loop $1 $_mountpoint && echo "'$1' mounted to $_mountpoint."
  fi
else
  echo "error: '$1' is not a readable iso file."
fi
}

#system roundup
sys(){
uname -a
echo "runlevel" `runlevel`
uptime
last|head -n 5;
who;
echo "============= CPUs ============="
grep "model name" /proc/cpuinfo #show CPU(s) info
cat /proc/cpuinfo | grep 'cpu MHz'
echo ">>>>>current process"
pstree
echo "============= MEM ============="
#KiB=`grep MemTotal /proc/meminfo | tr -s ' ' | cut -d' ' -f2`
#MiB=`expr $KiB / 1024`
#note various mem not accounted for, so round to appropriate sizeround=32
#echo "`expr \( \( $MiB / $round \) + 1 \) \* $round` MiB"
free -otm;
echo "============ NETWORK ============"
ip link show
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
echo "============= DISKS =============";
df -h;
echo "============= MISC =============="
echo "==<kernel modules>=="
lsmod|column -t|awk '{print $1}';
echo "=======<pci>========"
lspci -tv;
echo "=======<usb>======="
lsusb;
}

# go to google for a definition
define() {
  local LNG=$(echo $LANG | cut -d '_' -f 1)
  local CHARSET=$(echo $LANG | cut -d '.' -f 2)
  lynx -accept_all_cookies -dump -hiddenlinks=ignore -nonumbers -assume_charset="$CHARSET" -display_charset="$CHARSET" "http://www.google.com/search?hl=${LNG}&q=define%3A+${1}&btnG=Google+Search" | grep -m 5 -C 2 -A 5 -w "*" > /tmp/deleteme
  if [ ! -s /tmp/deleteme ]; then
    echo "Sorry, google doesn't know this one..."
  else
    cat /tmp/deleteme | grep -v Search
    echo ""
  fi
  rm -f /tmp/deleteme
}

function google () {
    url=$(echo http://google.com/search?q=$(echo "$@" | sed s/\ /+/g))
    if [[ "$DISPLAY" = "" ]]; then
        $BROWSER "$url"
    else
        firefox "$url"
    fi
}


#Use human-readable filesizes
alias du="du -h"
alias df="df -h"

#Pacman & other
alias install="sudo pacman -S"
alias search="sudo pacman -Ss"
alias update="sudo pacman -Sy"
alias upgrade="sudo pacman -Syu"
alias remove="sudo pacman -R"
alias orphans="pacman -Qqt"
alias ls='ls -hN --color=auto --group-directories-first'
alias progs="(pacman -Qet && pacman -Qm) | sort -u"
alias config="nano ~/.config/i3/config"

# Other Aliases
#navigation
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
#root
alias root='sudo su'
#bashrc
alias bashrc='(nano ~/.bashrc &)'

# Define a few Colours
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m' # No Color

#------------------------------
# WELCOME SCREEN

clear

echo -ne "${WHITE}""Άντε πάλι. Τι "${BROWN}"σκατά "${WHITE}"θές;\n"
echo -ne "\n";
#------------------------------
