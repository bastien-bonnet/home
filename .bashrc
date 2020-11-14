function main {
	shell_is_interactive || return

	export PATH=$PATH:~/software:~/.scripts:~/.local/bin
	export CDPATH="~/dev"

	set_prompt

	source_other_bash_config_files
	set_bash_history_preferences
	set_terminal_visual_preferences
	set_application_preferences
}

function set_prompt {
	if $(has_color_support); then
		PROMPT_COMMAND=define_PS1_with_git_info
	else
		define_simple_PS1
	fi
	PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
}

function define_PS1_with_git_info {
	local last_command_exit_status="$?"
	
	local red="\[\033[31m\]"
	local green="\[\033[38;5;46m\]"
	local yellow="\[\033[33m\]"
	local bold="\[\033[1;38m\]"
	local base_bg="\[\033[48;5;53m\]"
	local error_bg="\[\033[48;5;88m\]"
	local bg_color="$([[ $last_command_exit_status == 0 ]] && echo $base_bg || echo $error_bg)"
	local exit_status_color="$([[ $last_command_exit_status == 0 ]] || echo $red)"
	local default_text_color="\[\033[39m\]"
	local normal_text_intensity="\[\033[22m\]"
	local fg_format_off="$default_text_color$normal_text_intensity"
	local format_off="\[\033[00m\]"

	local working_dir="$bold$(short_working_dir)$fg_format_off"
	local prompt_left="$bg_color  $(ssh_infos)$working_dir     $(gitInfo)$(svnInfos)"
	local time=" $(date +'%T')"
	local filler=$(prompt_gap_filler "$prompt_left" "$time")

	local prompt="$prompt_left$filler$time$format_off\n$exit_status_color➜$format_off "
	PS1=$(prepend_terminal_title "$prompt")
}

function gitInfo() {
	# If git is installed && current directory is inside a git repo
	if [[ $(command -v git) != "" && ("$(git rev-parse --is-inside-work-tree 2>&1)" == "true") ]]; then
		local gitStatus="$(git status)"

		local dirtyStatus="$(gitDirtyStatus)"
		[[ -n $dirtyStatus ]] && dirtyStatusColored="$red$dirtyStatus$fg_format_off"
		
		local branchDivergence="$(gitBranchDivergence)"
		[[ -n $branchDivergence ]] && branchStateColored="$yellow$bgColor$branchDivergence$fg_format_off"
		
		local localStatus="$branchStateColored$dirtyStatusColored"
		[[ -z "$branchStateColored" && -z "$dirtyStatusColored" ]] && localStatus="✓"
		[[ -n "$branchStateColored" && -n "$dirtyStatusColored" ]] && localStatus="$branchStateColored $dirtyStatusColored"
		
		echo -n "$(gitBranchColored) $localStatus"
	fi
}

function gitBranchColored {
	local gitBranch="$(git branch --no-color | sed -n 's/* \(.*\)/\1/p')"
	[[ "$gitBranch" != master && "$gitBranch" != next ]] && gitBranch="$yellow$gitBranch$fg_format_off"
	echo -n "$gitBranch"
}

function gitDirtyStatus {
	local unCommitedWork="$([[ $(echo $gitStatus | grep 'Changes to be committed:') != '' ]] && echo A)"
	local unMergedWork="$([[ $(echo $gitStatus | grep 'Unmerged paths:') != '' ]] && echo U)"
	local unStagedWork="$([[ $(echo $gitStatus | grep 'Changes not staged for commit:') != '' ]] && echo M)"
	local unTrackedFiles="$([[ $(echo $gitStatus | grep 'Untracked files:') != '' ]] && echo ?)"
	echo -n "$unCommitedWork$unMergedWork$unStagedWork$unTrackedFiles"
}

function gitBranchDivergence {
	if [[ -d .git/svn ]]; then
		if [[ -f .git/refs/remotes/git-svn && -f .git/refs/heads/master ]]; then
			local diverged="$([[ $(git diff master git-svn) != '' ]] && echo '↓↑(git-svn)')"
		elif [[ -f .git/refs/remotes/trunk && -f .git/refs/heads/master ]]; then
			local diverged="$([[ $(git diff master trunk) != '' ]] && echo '↓↑(trunk)')"
		else
			local diverged="?"
		fi
	else
		local behind="$(echo $gitStatus | sed -n 's/.*Your branch is behind.*by \([[:digit:]]\+\) commit.*/↓\1/p')"
		local ahead="$(echo $gitStatus | sed -n 's/.*Your branch is ahead.*by \([[:digit:]]\+\) commit.*/↑\1/p')"
		local diverged="$(echo $gitStatus | sed -n 's/.*and have \([[:digit:]]\+\) and \([[:digit:]]\+\) different commit.*/↓\2↑\1/p')"
	fi
	echo -n "$behind$ahead$diverged"
}

function svnInfos() {
	if [[ $(command -v svn != "") ]]; then
		local svnStatus="$(svn status --xml 2>&1)"
		if [ -z "$(echo $svnStatus | grep 'is not a working copy')" ]; then
			[ -n "$(echo $svnStatus | grep 'item="modified"')" ] && local modifiedFiles="*"
			[ -n "$(echo $svnStatus | grep 'item="unversioned"')" ] && local newFiles="…"
			local dirtyStatus="$modifiedFiles$newFiles"
			[ -n "$dirtyStatus" ] && dirtyStatusColored="$red$dirtyStatus$fg_format_off" || dirtyStatusColored="✔"
			echo -n " [svn: $dirtyStatusColored]"
		fi
	fi
}

function prompt_gap_filler {
	local prompt_left="$1"
	local prompt_right="$2"
	local color_pattern="\\\[\\033\[[0-9;]*m\\\]"
	local prompt_left_length=$(echo -n "$prompt_left" | sed "s/$color_pattern//g" | wc -m)
	local number_of_double_size_chars=0
	local prompt_right_length=${#prompt_right}
	local gap_size="$(($COLUMNS - $prompt_left_length - $prompt_right_length + $number_of_double_size_chars))"
	local prompt_gap_filler="$(for ((i=1;i<=$gap_size;++i)); do echo -n ' '; done)"
	echo "$prompt_gap_filler"
}

function short_working_dir {
	local working_dir="${PWD/$HOME/\~}"
	local working_dir_length="${#working_dir}"
	[[ $working_dir_length -gt 35 ]] && working_dir="…${working_dir:(($working_dir_length - 35))}"
	echo "$working_dir"
}

function ssh_infos {
	# If I am SSHing on one of my other machines, need to see it clearly
	if [ -n "$SSH_CLIENT" ]; then
		echo "$green$USER@$HOSTNAME$fg_format_off:"
	fi
}

function define_simple_PS1 {
	PS1="$(prepend_terminal_title '\u@\h:\w\$ ')"
}

function prepend_terminal_title {
	# If this is an xterm set the title to user@host:dir
	if [[ "$TERM" =~ rxvt*|xterm* ]]; then
		local term_title="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \wTEST\a\]"
	fi
	echo "$term_title$1"
}

function source_other_bash_config_files {
	[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
	[[ -f ~/.bashrc_machine_specific ]] && . ~/.bashrc_machine_specific
	[[ -f /etc/bash_completion ]] && ! shopt -oq posix && . /etc/bash_completion
}

function set_application_preferences {
	export SPARK_HOME="$HOME/software/spark"
	export PATH="$PATH:$SPARK_HOME/bin"
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

function has_color_support {
	# If 0, we have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429). (Lack of such support is extremely rare, and such a case would tend to support setf rather than setaf.)
	[ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null
}

function shell_is_interactive {
	[ -n "$PS1" ]
}

main
