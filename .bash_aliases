alias a="alias"


###################################################################################################
# FILE INFORMATION

	a ls="ls --color=auto -F -h"
	a l="ls -oh --time-style=long-iso --group-directories-first"
	a lt="l -t"
	a la="l -A"
	a ldo="l ~/Downloads"
	a ll="ls -l"
	a t="tree -D --du -h"

	cdAndLs () { cd "${1:-$HOME}" && l; }
	a cl="cdAndLs"

	a dl="cl ~/Downloads"
	a dev="cl ~/dev"
	a curr="cl ~/Current"
	a trash="cl ~/.local/share/Trash/files"
	firefox_profile="$(sed -En 's/Path=(.*)/\1/p' ~/snap/firefox/common/.mozilla/firefox/profiles.ini)"
	a ff="cl ~/snap/firefox/common/.mozilla/firefox/$firefox_profile"

	a rl="readlink -m"

	a wl="wc -l"
	a lessh='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less -MR '

	a f="find . -iname"
	a grep="grep --color=auto"

	a urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
	a urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'


###################################################################################################
# SYSTEM

	a u='sudo apt update && sudo apt upgrade -V'
	a pl="ps -eo pid,user,pcpu,pmem,start,comm,args"
	grepWithFirstLine () {
		head -n 1
		grep -i $1
	}
	a pg="pl | grepWithFirstLine"

	duh () { du -had 1 ${1:-.} | sort -h; }

	a lsb='lsblk -e 7 -o NAME,SIZE,MOUNTPOINT,FSTYPE,TYPE,LABEL,FSUSE%'
	a crypt='cryptsetup -vy luksFormat -i 5000'
	luksOpen () { (set -ux; sudo cryptsetup luksOpen /dev/"$1" "$1"_crypt && sudo mount /dev/mapper/"$1"_crypt "$2"); }
	luksClose () { (set -ux; sudo umount "$2" && sudo cryptsetup luksClose /dev/mapper/"$1"_crypt); }

	a rs='redshift -l 48.9:2.3 -t 5700:4000 -b 1 -m randr -v'

	a ks="qdbus org.kde.ksmserver /KSMServer logout 0 2 2"
	a kl="qdbus org.kde.ksmserver /KSMServer logout 0 3 3"

	a bootErrorLogs="journalctl -b -p err | less"

	a ez="teensy_loader_cli -vw -mmcu=atmega32u4"
	a amd="sudo modprobe -r kvm_amd kvm"

	npl () { sudo nvidia-smi -pl ${1:-95}; }


###################################################################################################
# CLEANING

	a rm="rm -i"
	a r="~/.scripts/remove"
	a et="~/.scripts/emptyTrash"
	a secure_erase="sudo shred -vzn1"
	a freemem='sudo sync && sudo echo 3 | sudo tee /proc/sys/vm/drop_caches'


###################################################################################################
# GIT

	function_exists() {
		declare -f -F $1 > /dev/null
		return $?
	}
	
	declare_git_aliases_for_bash() {
		for git_alias in $(git --list-cmds=alias); do
			alias g$git_alias="git $git_alias"
			completion_function=_git_$(__git_aliased_command $git_alias)
			function_exists $completion_function && __git_complete g$git_alias $completion_function
		done
		for git_command in $(git --list-cmds=main,others,nohelpers); do
			alias g$git_command="git $git_command"
			completion_function=_git_$git_command
			function_exists $completion_function && __git_complete g$git_command $completion_function
		done
	}

	linux_git_completion_functions="/usr/share/bash-completion/completions/git"
	windows_git_completion_functions="/mingw64/share/git/completion/git-completion.bash"
	if [ -f $linux_git_completion_functions ]; then
		. $linux_git_completion_functions
		declare_git_aliases_for_bash $linux_git_completion_functions
	elif [ -f $windows_git_completion_functions ]; then
		. $windows_git_completion_functions
		declare_git_aliases_for_bash $windows_git_completion_functions
	else
		echo "Can’t locate Git completion functions"
	fi

	a gss="~/.scripts/statusGitSvn"
	a gsu="~/.scripts/updateGitSvn"


###################################################################################################
# FILE EDITION

	export EDITOR=vim
	a v="vim"
	a e="$EDITOR"
	a ee="sudo $EDITOR"
	a erc="e ~/.bashrc; source ~/.bashrc; echo '.bashrc sourced'"
	a ercm="e ~/.bashrc_machine_specific; source ~/.bashrc_machine_specific; echo '.bashrc_machine_specific sourced'"
	a eba="e ~/.bash_aliases; source ~/.bash_aliases && echo 'aliases sourced'"
	a ebf="e ~/.bash_functions; source ~/.bash_functions && echo 'functions sourced'"
	a egc="e ~/.gitconfig"
	a eck="v -c 'set ft=lua' ~/.conkyrc"
	a evrc="e ~/.vimrc"
	a efst="ee /etc/fstab"

	function create_sample_bash_script {
		[[ ! -e "$1" ]] && (echo -e '#!/bin/bash\n\n' > "$1" && chmod +x "$1")
		vim + test.bash
	}
	a etb="create_sample_bash_script test.bash"

	a o="xdg-open"
	a m="touch /tmp/meld1.txt /tmp/meld2.txt && meld /tmp/meld1.txt /tmp/meld2.txt"
	a dirdate="mkdir $(date +%F_%T)"
	

# PDF manipulation
	a pdf-from-png="mogrify -format pdf *.png"
	a pdf-concat-all="pdfunite *.pdf merged.pdf"
	a pdf-concat-lossy="\\gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf"
	a pdf-concat-all-lossy="pdf-concat *.pdf"
	a pdf-quality-lower="ps2pdf -dPDFSETTINGS=/ebook merged.pdf merged_lq.pdf"
	# Despeckle, sharpens and compresses
	a pdf-from-scan="convert scan.png -despeckle -normalize -sharpen 0x1.5 -compress jpeg scan_compressed.pdf"

	pandoc_beamer() { pandoc \
		-V theme=Singapore \
		-V aspectratio=169 \
		--slide-level 2 \
		--highlight-style=breezedark \
		-H ~/.templates/pandoc_beamer_header.tex \
		-st beamer \
		--pdf-engine=lualatex \
		${@}
	}
	pandocb() { pandoc_beamer ${@:2} "$1" -o "${1%.md}".pdf; }
	pandocbh() { pandoc_beamer ${@:2} -V handout "$1" -o "${1%.md}"-handout.pdf; }
	export -f pandoc_beamer
	export -f pandocb
	export -f pandocbh



###################################################################################################
# RSYNC

	a rsn="rsync -nvihurlt --exclude-from=$HOME/.rsyncExclude"
	a rsy="rsync -vihurlt --exclude-from=$HOME/.rsyncExclude"
	a rsn_ssh="rsn -e 'ssh -p 1234'"
	a rsy_ssh="rsy -e 'ssh -p 1234'"


###################################################################################################
# OTHER
	a c="bc -l <<<"
	a prettyJson="python -m json.tool"
	a ta="todo.bash"
	a uvc="uvcdynctrl -L ~/.webcam.gpfl"

