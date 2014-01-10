# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


#export LESS_TERMCAP_mb=$'\E[01;31m'
#export LESS_TERMCAP_md=$'\E[01;31m'
#export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
#export LESS_TERMCAP_ue=$'\E[0m'
#export LESS_TERMCAP_us=$'\E[01;32m'

export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;32m'
export LESS_TERMCAP_me=$'\E[01;0m'
export LESS_TERMCAP_se=$'\E[01;0m'
export LESS_TERMCAP_so=$'\e[01;31m'
export LESS_TERMCAP_ue=$'\E[01;0m'
export LESS_TERMCAP_us=$'\E[01;35m'

if [ "$COLORTERM" == "gnome-terminal" ]; then
    export TERM=xterm-256color
fi 

alias c="ccze -A"


# приглашение (adam2) 
function prompt_adam2(){ 
local WHOAMI=$(whoami); 
local HOSTNAME=$(hostname); 
local USER_AT_HOST_LEN=$((${#WHOAMI}+${#HOSTNAME}+3));
local WIDTH=$(tput cols); 
local MYPWD="$PWD";
if [ "$mc" == "mc" ]; then
   local MC_LEN=4
else
   local MC_LEN=0
fi
if [[ "$HOME" == ${MYPWD:0:${#HOME}} ]]; then 
   local PWD_LEN=$((${#MYPWD}-${#HOME}+3)); 
   local MYNEWPWD="~${MYPWD:${#HOME}}"; 
else 
   local PWD_LEN=$((${#MYPWD}+2)); 
   local MYNEWPWD="$MYPWD"; 
fi 
local DASHES=$((${WIDTH}-${USER_AT_HOST_LEN}-${PWD_LEN}-${MC_LEN}-3)); 
local PWD_LIM=$((${WIDTH}-${USER_AT_HOST_LEN}-${MC_LEN}-10));
if (( ${#MYNEWPWD} > ${PWD_LIM} )); then 
   local TRUNC_SEQ="..."; 
   PWD_LEN=${#MYNEWPWD}; 
   if [[ "$HOME" == ${MYPWD:0:${#HOME}} ]]; then 
   MYNEWPWD="~"$TRUNC_SEQ"${MYNEWPWD:${PWD_LEN}-${PWD_LIM}:999}"; 
   DASHES=1; 
   else 
   MYNEWPWD=""$TRUNC_SEQ"${MYNEWPWD:${PWD_LEN}-${PWD_LIM}:999}"; 
   DASHES=1;
   fi 
fi 
if [ "$1" == "dashes" ]; then 
for (( i=1; i<=${DASHES}; i++)); do 
#   echo -ne '\033(0q\033(B'; 
    echo -ne '-'
done 
elif [ "$1" == "mypwd" ]; then 
   echo -n ${MYNEWPWD}; 
elif [ "$1" == "mc" ]; then
    if [ "$mc" == "mc" ]; then
     echo -ne "\e[30;1m(\e[34mmc\e[30;1m)\e[0m";
    fi;
fi 
} 

if [ "x$recursion" = "x" ]; then
    recursion="0";
    export recursion;
else
    recursion=$(($recursion+1));
fi;

if [ "`ps hp $PPID o command`" = "mc" ]; then
    export mc="mc";
fi;
. ~/.bash_it/themes/base.theme.bash

if [ "`id -u`" -eq 0 ]; then
    export PS1='\[\e[36;1m\]$recursion\[\e[0m\]\[\e[36m\]:\[\e[30;1m\](\[\e[0m\]\
\[\e[32;1m\]$(prompt_adam2 mypwd)\[\e[0m\]\[\e[30;1m\])\[\e[0m\]\
$(prompt_adam2 mc)\[\e[36m\]\
$(prompt_adam2 dashes)\[\e[30;1m\](\[\e[0m\]\[\e[31;1m\]\u\[\e[0m\]\[\e[36;1m\]@\[\e[0m\]\[\e[36m\]\h\
\[\e[30;1m\])\[\e[0m\]\[\e[36m\]:\[\e[0m\]\n\
\[\e[36;1m\]\`\[\e[0m\]\[\e[36;1m\]-\[\e[0m\]\[\e[31;1m\]#\[\e[0m\]\
$(scm_prompt_info)\[\e[37;1m\]>\[\e[0m\] '
else
    export PS1='\[\e[36;1m\]$recursion\[\e[0m\]\[\e[36m\]:\[\e[30;1m\](\[\e[0m\]\
\[\e[32;1m\]$(prompt_adam2 mypwd)\[\e[0m\]\[\e[30;1m\])\[\e[0m\]\
$(prompt_adam2 mc)\[\e[36m\]\
$(prompt_adam2 dashes)\[\e[30;1m\](\[\e[0m\]\[\e[36m\]\u\[\e[0m\]\[\e[36;1m\]@\[\e[0m\]\[\e[36m\]\h\
\[\e[30;1m\])\[\e[0m\]\[\e[36m\]:\[\e[0m\]\n\
\[\e[36;1m\]\`\[\e[0m\]\[\e[36;1m\]-\[\e[0m\]\[\e[36m\]$\[\e[0m\]\
$(scm_prompt_info)\[\e[37;1m\]>\[\e[0m\] '
fi

export PS2='\[\e[37;1m\]> \[\e[0m\]'

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

ping() {
 /bin/ping $*|/usr/bin/ccze -A
}

tracepath(){
/usr/bin/tracepath $*|/usr/bin/ccze -A
}

traceroute(){
/usr/bin/traceoute $*|/usr/bin/ccze -A
}

host(){
/usr/bin/host $*|/usr/bin/ccze -A
}

dig(){
/usr/bin/dig $*|/usr/bin/ccze -A
}

df(){
/bin/df $*|/usr/bin/ccze -A
}

# Generate a random password
#  $1 = number of characters; defaults to 32
#  $2 = include special characters; 1 = yes, 0 = no; defaults to 1
function randpass() {
  [ "$2" == "0" ] && CHAR="23456789qQwWeErRtTyYuUpPaAsSdDfFgGhHjJkKLzZxXcCvVbBnNmM" || CHAR="[:graph:]"
    cat /dev/urandom | tr -cd "$CHAR" | head -c ${1:-32}
    echo
}

export PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/~}\007"'

export DEBFULLNAME="Anton Grudko"
export DEBEMAIL="grudko@netrika.ru"

export ANDROIDSDK=/home/anton/android/adt-bundle-linux-x86_64-20130514/sdk
export ANDROIDNDK=/home/anton/android/android-ndk-r8e
export ANDROIDNDKVER=r8e
export ANDROIDAPI=14

export PATH=$ANDROIDNDK:$ANDROIDSDK/tools:$PATH
export PIP_INDEX_URL=http://develop.netrika.ru:2002/simple
export MSF_DATABASE_CONFIG=/opt/metasploit-framework/database.yml


