# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# See bash(1)
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export TERM=xterm-color

# Check if terminal has color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429). (Lack of such support is extremely rare, and such a case would tend to support setf rather than setaf.)
	color_prompt=yes
else
	color_prompt=
fi

export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[1;34m"
export off="\033[00m"
export default_text="\033[39m\033[22m" # default text color, default text intensity

source ~/.bash_functions

if [ "$color_prompt" = yes ]; then
		function pCmd {
			local exitStatus="$?"

			local red="\[\033[31m\]"
			local green="\[\033[32m\]"
			local yellow="\[\033[33m\]"
			local blue="\[\033[1;34m\]"
			local bgColor="\[\033[48;5;234m\]"
			local off="\[\033[00m\]"
			local default_text="\[\033[39m\]\[\033[22m\]" # default text color, default text intensity

			# If I am SSHing on one of my other machines, need to see it clearly
			if [ -n "$SSH_CLIENT" ]; then
				local userAndHost="$green$USER@$HOSTNAME$default_text:"
			fi
			local workingDir="$blue$(echo $PWD | sed 's,'$HOME',~,')$default_text"
			local exitStatusColor="$([[ $exitStatus == 0 ]] && echo -e '' || echo -e $red)"
			local gitInfo="$(gitInfo)"
			local svnInfo="$(svnInfos)"
			local prompt_1="$bgColor╭─ $userAndHost$workingDir$gitInfo$svnInfo"
			local promptSize="$(echo -n $prompt_1 | sed 's/\\\[\\033\[[0-9;]*m\\\]//g' | wc -m)"
			local time="$(date +'%F %T')"
			local timeSize="$(echo -n $time | wc -m)"
			local promptFill="$(for ((i=1;i<=$(($COLUMNS-$promptSize-$timeSize));++i)); do echo -n ' '; done)"
			PS1="$prompt_1$promptFill$time$off
╰─$exitStatusColor➤$off "
		}
		
		PROMPT_COMMAND=pCmd
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

#Allow to omit cd before file names
shopt -s autocd

# append to the history file, don't overwrite it
shopt -s histappend

export PATH=$PATH:~/software:~/software/sbt/bin

# Colored man
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
# 1=bright(=bold);38=text color;5;0-255[;48=background color;5;0-255];m=end of color sequence
export LESS_TERMCAP_so=$'\E[1;38;5;202m' # begin standout-mode - info box
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_us=$'\E[04;38;5;200m' # begin underline
export LESS_TERMCAP_ue=$'\E[0m' # end underline
