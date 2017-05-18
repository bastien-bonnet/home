function main {
	shell_is_interactive || return

	export PATH=$PATH:~/software:~/.scripts:~/.local/bin

	source ~/.bash_functions && set_prompt

	source_bash_config_files
	set_bash_history_preferences
	set_terminal_visual_preferences
	set_application_preferences
}

function set_prompt {
	if $(check_color_support); then
		PROMPT_COMMAND=define_PS1_with_git_info
	else
		PS1='\u@\h:\w\$ '
		set_terminal_title
	fi
	PROMPT_COMMAND="$PROMPT_COMMAND; history -a"
}

function define_PS1_with_git_info {
	local last_command_exit_status="$?"
	
	local red="\[\033[31m\]"
	local green="\[\033[32m\]"
	local yellow="\[\033[33m\]"
	local bold_blue="\[\033[1;34m\]"
	local grey_bg="\[\033[48;5;238m\]"
	local red_bg="\[\033[48;5;88m\]"
	local bg_color="$([[ $last_command_exit_status == 0 ]] && echo $grey_bg || echo $red_bg)"
	local off="\[\033[00m\]"
	local default_text_color_and_intensity="\[\033[39m\]\[\033[22m\]"

	# If I am SSHing on one of my other machines, need to see it clearly
	if [ -n "$SSH_CLIENT" ]; then
		local userAndHost="$green$USER@$HOSTNAME$default_text_color_and_intensity:"
	fi
	local working_dir="$(echo $PWD | sed 's,'$HOME',~,')"
	local working_dir_length="${#working_dir}"
	[[ $working_dir_length -gt 35 ]] && working_dir="…${working_dir:(($working_dir_length - 35))}"
	working_dir="$bold_blue$working_dir$default_text_color_and_intensity"
	local git_info="$(gitInfo)"
	local svn_info="$(svnInfos)"

	local exit_status_color="$([[ $last_command_exit_status == 0 ]] || echo $red)"

	local prompt_left="$bg_color$exit_status_color╭$off$bg_color $userAndHost$working_dir $git_info$svn_info"
	local time="$(date +'%T')"

	local prompt_left_size="$(echo -n $prompt_left | sed 's/\\\[\\033\[[0-9;]*m\\\]//g' | wc -m)"
	local time_size="$(echo -n $time | wc -m)"
	local gap_size="$(($COLUMNS-$prompt_left_size-$time_size))"
	local prompt_gap_filler="$(for ((i=1;i<=$gap_size;++i)); do echo -n ' '; done)"

	PS1="$prompt_left$prompt_gap_filler$time$off\n$exit_status_color╰➤$off "
	
	set_terminal_title
}

function set_terminal_title {
	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	xterm*|rxvt*)
			PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
			;;
	*)
			;;
	esac
}

function source_bash_config_files {
	[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
	[[ -f ~/.bashrc_machine_specific ]] && . ~/.bashrc_machine_specific
	[[ -f /etc/bash_completion ]] && ! shopt -oq posix && . /etc/bash_completion
}

function set_application_preferences {
	export TEXMFHOME="$HOME/.texmf"

	# make less more friendly for non-text input files, see lesspipe(1)
	[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
}

function set_terminal_visual_preferences {
	# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
	shopt -s checkwinsize

	color_man_pages
}	

function set_bash_history_preferences {
	export HISTCONTROL=ignoredups:ignorespace
	export HISTSIZE=10000
	export HISTFILESIZE=10000
	export HISTTIMEFORMAT="%F %T "
	# append to the history file, don't overwrite it
	shopt -s histappend
}

function color_man_pages {
	export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
	export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
	export LESS_TERMCAP_me=$'\E[0m' # end mode
	# 1=bright(=bold);38=text color;5;0-255[;48=background color;5;0-255];m=end of color sequence
	export LESS_TERMCAP_so=$'\E[1;38;5;202m' # begin standout-mode - info box
	export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
	export LESS_TERMCAP_us=$'\E[04;38;5;200m' # begin underline
	export LESS_TERMCAP_ue=$'\E[0m' # end underline
}

function check_color_support {
	# If 0, we have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429). (Lack of such support is extremely rare, and such a case would tend to support setf rather than setaf.)
	[ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null
}

function shell_is_interactive {
	[ -n "$PS1" ]
}

main
