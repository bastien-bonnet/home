# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# See bash(1)
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export TERM=xterm-color

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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
		function pCmd {
			local exitStatus="$?"
			local green="\[\033[1;32m\]"
			local blue="\[\033[1;34m\]"
			local red="\[\033[1;31m\]"
			local off="\[\033[00m\]"
			local chroot="${debian_chroot:+($debian_chroot)}"
			if [ -n "$SSH_CLIENT" ]; then
				local userAndHost="$green\u@\h$off"
			fi
			local workingDir="$blue\w$off"
			local exitStatusColored="$([[ $exitStatus == 0 ]] && echo -e $green$exitStatus$off || echo -e $red$exitStatus$off)"
			# If git is installed && current directory is inside a git repo
			if [[ $(which git) != "" && ("$(git rev-parse --is-inside-work-tree 2>&1)" == "true") ]]; then
				local gitBranch="$(git branch --no-color | sed -n 's/* \(.*\)/\1/p')"
				local unStagedWork="$([[ $(git status | grep '# Changes not staged for commit:') != '' ]] && echo s)"
				local unCommitedWork="$([[ $(git status | grep '# Changes to be committed:') != '' ]] && echo c)"
				local unTrackedFiles="$([[ $(git status | grep '# Untracked files:') != '' ]] && echo t)"
				local behind="$(git status | sed -n 's/# Your branch is behind.*\([0-9]\+\).*/↓\1/p')"
				local ahead="$(git status | sed -n 's/# Your branch is ahead.*\([0-9]\+\).*/↑\1/p')"
				local diverged="$(git status | sed -n 's/# and have \([0-9]\+\) and \([0-9]\+\) different commit.*/↓\2↑\1/p')"
				local gitInfo="[$gitBranch$behind$ahead$diverged|$unStagedWork$unCommitedWork$unTrackedFiles]"
			fi
			PS1="$chroot$userAndHost[$workingDir] $gitInfo $exitStatusColored \$"
		}
		
		PROMPT_COMMAND=pCmd
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
