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

cdAndLs () { cd $1 && l; }
a cl="cdAndLs"

a rl="readlink -m"

a wl="wc -l"
a lessh='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less -MR '

a f="find . -iname"
a grep="grep --color=auto"

a urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
a urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'


###################################################################################################
# SYSTEM

a u='sudo apt update && sudo apt upgrade'
a pl="ps -eo pid,user,pcpu,pmem,start,comm,args"
grepWithFirstLine () {
	head -n 1
	grep -i $1
}
a pg="pl | grepWithFirstLine"

duh () { du -had 1 ${1:-.} | sort -h; }

a lsb='lsblk -I8,253 -o NAME,SIZE,MOUNTPOINT,FSTYPE,TYPE,LABEL,FSUSE%'
luksOpen () { (set -ux; sudo cryptsetup luksOpen /dev/"$1" "$1"_crypt && sudo mount /dev/mapper/"$1"_crypt "$2"); }
luksClose () { (set -ux; sudo umount "$2" && sudo cryptsetup luksClose /dev/mapper/"$1"_crypt); }

a rs='redshift -l 48.9:2.3 -t 5700:4000 -b 1 -m randr -v'

a ks="qdbus org.kde.ksmserver /KSMServer logout 0 2 2"
a kl="qdbus org.kde.ksmserver /KSMServer logout 0 3 3"

a ez="teensy_loader_cli -vw -mmcu=atmega32u4"


###################################################################################################
# CLEANING
a rm="rm -i"
a r="mv -bt ~/.local/share/Trash/files/"
a rdo="r ~/Downloads/*"
a r="~/.scripts/remove"
a et="~/.scripts/emptyTrash"
a secure_erase="sudo shred -vzn1"
a freemem='sudo sync && sudo echo 3 | sudo tee /proc/sys/vm/drop_caches'


###################################################################################################
# GIT

. /usr/share/bash-completion/completions/git

function_exists() {
	declare -f -F $1 > /dev/null
	return $?
}

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
a eck="e ~/.conkyrc"
a evrc="e ~/.vimrc"
a efst="ee /etc/fstab"

function create_sample_bash_script {
	[[ ! -e "$1" ]] && (echo -e '#!/bin/bash\n\n' > "$1" && chmod +x "$1")
	vim + test.bash
}
a etb="create_sample_bash_script test.bash"

a o="xdg-open"
a m="touch /tmp/meld1.txt /tmp/meld2.txt && meld /tmp/meld1.txt /tmp/meld2.txt"


###################################################################################################
# RSYNC

a rs="rsync -nvihurlt --exclude-from=$HOME/.rsyncExclude"
a rsc="rsync -vihurlt --exclude-from=$HOME/.rsyncExclude"
a rsssh="rslocal -e 'ssh -p 1234'"

