# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# auto cd if dir is typed
shopt -s autocd

#disable ^s and ^q
stty -ixon
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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
    alias ls='ls --color=auto -hN --group-directories-first'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

termbin() { cat "$1" | nc termbin.com 9999; }
nameappend() { for file in *."$1"; do echo "$file"$'\n'"$(cat -- "$file")" > "$file".upload; done; }
b() { xrandr --output eDP1 --brightness "$1"; }

add_alias() { echo alias \'$1\'=\'$2\' >> ~/.bash_aliases; }
brt() { nohup ~/yoga_brightness.sh ; }
#Start the brightness script and daemonize it in a subshell
brt </dev/null >/dev/null 2>&1 &
disown
export LD_LIBRARY_PATH=:/usr/local/lib:/usr/loc
#source /opt/ros/kinetic/setup.bash


g() { 
args=$(echo "$*" | tr -dc '[:alnum:]\n\r ' | tr '[:upper:]' '[:lower:]');
nohup xdg-open "https://www.google.com/search?q=$(echo ${args// /+})" >/dev/null 2>&1  
sleep 0.8
xdotool windowactivate $(xdotool search --class Chromium | tail -1) && xdotool key control+l && xdotool windowactivate $(xdotool getactivewindow) ;
}

glynx() { 
args=$(echo "$*" | tr -dc '[:alnum:]\n\r ' | tr '[:upper:]' '[:lower:]');
lynx "https://www.google.com/search?q=$(echo ${args// /+})"
#sleep 0.8
#xdotool windowactivate $(xdotool search --class Chromium | tail -1) && xdotool key control+l && xdotool windowactivate $(xdotool getactivewindow) ;
}

gg(){

    g $(tail -1 log.txt)

}


c() {
    clear
    temp=
    rcnt=0
    url='https://www.google.com/complete/search?client=hp&hl=en&xhr=t'
    local re='^[0-9]+$'
    # NB: user-agent must be specified to get back UTF-8 data!
    echo "Search: $1"
    if ! [[ "$1" == '' ]] ; then
        temp="$1"
        curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$1" "$url" | jq -r .[1][][0] | sed 's,</\?b>,,g' | nl -v 0
    fi
    while true; do
        while read -d '' -N 1 -s -r -t 0.1; do
            clear 
#            echo $REPLY
            temp+="$REPLY"
            rcnt=0
            if [[ "$REPLY" == $'\177' ]] ; then
                temp="${temp%??}"
            
            elif [[ "$REPLY" == $'\n' ]] ; then
                temp="${temp%?}"
                g $temp


            elif [[ $REPLY =~ $re ]] ; then
                temp="${temp%?}"
                g $( curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$temp" "$url" | jq -r .[1][][0] | sed 's,</\?b>,,g' | sed -n "$(($REPLY+1))"p )
            
            elif [[ "$REPLY" == $'\e' ]] ; then
                temp="${temp%?}"
                if [[ $temp == '' ]] ; then
                    return
                else
                    temp=
                fi
            fi

            echo "Search: $temp"
            printf "\n"
#            if [[ "$REPLY" == " " ]] ; then
#            fi
            printf "\n"

        done
        rcnt=$(($rcnt+1))
        if [ $rcnt -lt 2 ]  ; then 
            curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$temp" "$url" | jq -r .[1][][0] | sed 's,</\?b>,,g' | nl -v 0
        fi
    done
}

#same as above but uses lynx. Will probbaly alias this and add a browser argument
clynx() { 
    clear
    temp=
    rcnt=0
    url='https://www.google.com/complete/search?client=hp&hl=en&xhr=t'
    local re='^[0-9]+$'
    # NB: user-agent must be specified to get back UTF-8 data!
    echo "Search: $1"
    if ! [[ "$1" == '' ]] ; then
        temp="$1"
        curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$1" "$url" | jq -r .[1][][0] | sed 's,</\?b>,,g' | nl -v 0
    fi
    while true; do
        while read -d '' -N 1 -s -r -t 0.1; do
            clear 
#            echo $REPLY
            temp+="$REPLY"
            rcnt=0
            if [[ "$REPLY" == $'\177' ]] ; then
                temp="${temp%??}"
            
            elif [[ "$REPLY" == $'\n' ]] ; then
                temp="${temp%?}"
                glynx $temp


            elif [[ $REPLY =~ $re ]] ; then
                temp="${temp%?}"
                glynx $( curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$temp" "$url" | jq -r .[1][][0] | sed 's,</\?b>,,g' | sed -n "$(($REPLY+1))"p )
            
            elif [[ "$REPLY" == $'\e' ]] ; then
                temp="${temp%?}"
                if [[ $temp == '' ]] ; then
                    return
                else
                    temp=
                fi
            fi

            echo "Search: $temp"
            printf "\n"
#            if [[ "$REPLY" == " " ]] ; then
#            fi
            printf "\n"

        done
        rcnt=$(($rcnt+1))
        if [ $rcnt -lt 2 ]  ; then 
            curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$temp" "$url" | jq -r .[1][][0] | sed 's,</\?b>,,g' | nl -v 0
        fi
    done
}


power_saving() {
    # Disable the NMI watchdog
    echo '0' > '/proc/sys/kernel/nmi_watchdog';

    # Runtime power management for I2C devices
    for i in /sys/bus/i2c/devices/*/device/power/control ; do
      echo auto > ${i}
      done

      # Runtime power-management for PCI devices
    for i in /sys/bus/pci/devices/*/power/control ; do
        echo auto > ${i}
        done

    # Runtime power-management for USB devices
    for i in /sys/bus/usb/devices/*/power/control ; do
        echo auto > ${i}
        done

    # Low power SATA
    for i in /sys/class/scsi_host/*/link_power_management_policy ; do
        echo min_power > ${i}
        done

    # Disable Wake-on-LAN on ethernet port
    #ethtool -s wlan0 wol d;
    #ethtool -s eth0 wol d

    #Enable Audio codec power management
    echo '1' > '/sys/module/snd_hda_intel/parameters/power_save';

    # Low power wireless
    iw dev wlan0 set power_save on
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
cdls() { cd "$@" && ls; }
complete -d cdls

export PYTHONSTARTUP=~/.pythonrc


#source ~/.autoenv/activate.sh

sshgpr() {
gpr_ip=`curl -s "https://s3.amazonaws.com/lakewood-gpr/ip"` ;
local s="Host $gpr_ip"
sed -i "1s/.*/$s/" ~/.ssh/config
}
    
source /home/raghav/.venvburrito/startup.sh

#Put all functions in separate file, for readability 
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [ -f ~/.bash_ps1 ]; then
    . ~/.bash_ps1
fi

export PATH+=:/home/raghav/.scripts
export PATH+=:/home/raghav/sandbox/crosscompile/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin

export WINEPREFIX=~/.adewine
set -o noclobber
set bind-tty-special-chars off
set -o vi
