# If not running interactively, don't do anything
[ -z "$PS1" ] && return

function main {
	color_export
	source ~/.bash_functions

	color_prompt=$(check_color_support)
	if [ "$color_prompt" = yes ]; then
			function pCmd {
				local last_command_exit_status="$?"
				
				local red="\[\033[31m\]"
				local green="\[\033[32m\]"
				local yellow="\[\033[33m\]"
				local bold_blue="\[\033[1;34m\]"
				local bg_color="\[\033[48;5;238m\]"
				local off="\[\033[00m\]"
				local default_text_color_and_intensity="\[\033[39m\]\[\033[22m\]"

				# If I am SSHing on one of my other machines, need to see it clearly
				if [ -n "$SSH_CLIENT" ]; then
					local userAndHost="$green$USER@$HOSTNAME$default_text_color_and_intensity:"
				fi
				local working_dir="$bold_blue$(echo $PWD | sed 's,'$HOME',~,')$default_text_color_and_intensity"
				local git_info="$(gitInfo)"
				local svn_info="$(svnInfos)"

				local exit_status_color="$([[ $last_command_exit_status == 0 ]] && echo '' || echo $red)"

				local prompt_left="$bg_color$exit_status_color╭─$off$bg_color $userAndHost$working_dir$git_info$svn_info"
				local date_and_time="$(date +'%F %T')"

				local prompt_left_size="$(echo -n $prompt_left | sed 's/\\\[\\033\[[0-9;]*m\\\]//g' | wc -m)"
				local date_and_time_size="$(echo -n $date_and_time | wc -m)"
				local prompt_gap_filler="$(for ((i=1;i<=$(($COLUMNS-$prompt_left_size-$date_and_time_size));++i)); do echo -n ' '; done)"

				PS1="$prompt_left$prompt_gap_filler$date_and_time$off\n$exit_status_color╰─➤$off "
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

	if [ -f ~/.bashrc_machine_specific ]; then
			. ~/.bashrc_machine_specific
	fi

	# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
	if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
			. /etc/bash_completion
	fi

	# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
	shopt -s checkwinsize

	#Allow to omit cd before file names
	shopt -s autocd

	HISTCONTROL=ignoredups:ignorespace
	HISTSIZE=10000
	HISTFILESIZE=10000
	# append to the history file, don't overwrite it
	shopt -s histappend

	export PATH=$PATH:~/software:~/software/sbt/bin
	export TEXMFHOME="$HOME/.texmf"

	color_man_pages

	# make less more friendly for non-text input files, see lesspipe(1)
	[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
}

function color_man_pages() {
	export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
	export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
	export LESS_TERMCAP_me=$'\E[0m' # end mode
	# 1=bright(=bold);38=text color;5;0-255[;48=background color;5;0-255];m=end of color sequence
	export LESS_TERMCAP_so=$'\E[1;38;5;202m' # begin standout-mode - info box
	export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
	export LESS_TERMCAP_us=$'\E[04;38;5;200m' # begin underline
	export LESS_TERMCAP_ue=$'\E[0m' # end underline
}

function color_export() {
	export red="\033[31m"
	export green="\033[32m"
	export yellow="\033[33m"
	export blue="\033[1;34m"
	export off="\033[00m"
	#export default_text_color_and_intensity="\[\033[39m\]\[\033[22m\]"
	export default_text_color_and_intensity="\033[39m\033[22m"
}

function check_color_support() {
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429). (Lack of such support is extremely rare, and such a case would tend to support setf rather than setaf.)
		echo yes
	else
		echo no
	fi
}

main
