# bash aliases
alias a="alias"
a f="find . -iname"
a grep="grep --color=auto"
a ls="ls --color=auto -F -h"
a l="ls -oh --time-style=long-iso"
a ll="ls -l"
a la="ls -A"
a lla="ls -Al"
a wl="wc -l"
a rm="rm -i"
a r="mv -bt ~/.local/share/Trash/files/"
a pl="ps -eo pid,user,pcpu,pmem,start,comm,args"
grepWithFirstLine () {
	sed -n -e '1p' -e '1d' -e "/$1/Ip"
}
a pg="pl | grepWithFirstLine"
a duh="du -had 1 | sort -h"

a lessh='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less -MR '

a ks="qdbus org.kde.ksmserver /KSMServer logout 0 2 2"

a freemem='sudo sync && sudo echo 3 | sudo tee /proc/sys/vm/drop_caches'
a rs='redshift -l 48.9:2.3 -t 5700:4000 -b 1 -m randr -v'

# git aliases
function_exists() {
	declare -f -F $1 > /dev/null
	return $?
}

. /usr/share/bash-completion/completions/git

for git_alias in $(__git_aliases); do
	alias g$git_alias="git $git_alias"
	completion_function=_git_$(__git_aliased_command $git_alias)
	function_exists $completion_function && __git_complete g$git_alias $completion_function
done
for git_command in $(__git_list_all_commands); do
	alias g$git_command="git $git_command"
	completion_function=_git_$git_command
	function_exists $completion_function && __git_complete g$git_command $completion_function
done


# Text processing
a urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
a urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

# Alienware NumpadEnter mapping to Enter
a awe="xmodmap -e 'keycode 104 = Return'"

# file edition
export EDITOR=vim
a v="vim"
a e="$EDITOR"
a ee="sudo $EDITOR"
a erc="e ~/.bashrc; source ~/.bashrc; echo '.bashrc sourced'"
a ercm="e ~/.bashrc_machine_specific; source ~/.bashrc_machine_specific; echo '.bashrc_machine_specific sourced'"
a eba="e ~/.bash_aliases; source ~/.bash_aliases && echo 'aliases sourced'"
a ebf="e ~/.bash_functions; source ~/.bash_functions && echo 'functions sourced'"
a egc="e ~/.gitconfig"
a eckd="e ~/.conkyrc-desktop"
a eckl="e ~/.conkyrc-laptop"
a eckn="e ~/.conkyrc-netbook"
a evrc="e ~/.vimrc"
a etodo="e ~/todo.txt"
a todo='sort ~/todo.txt | grep -v ^x | grep -E "@waiting|$"'
a efst="ee /etc/fstab"
a eday='grep "^== $(date -I)" ~/doc/activité.asciidoc  && vim + ~/doc/activité.asciidoc || (echo -e "\n== $(date -I)" >> ~/doc/activité.asciidoc && vim + ~/doc/activité.asciidoc)'

# Navigation aliases
a u='[[ "$(pwd)" != "/" ]] && pushd ..'
a p="popd"

# rsync aliases
a rs="rsync -nvihurlt --exclude-from=$HOME/.rsyncExclude"
a rsc="rsync -vihurlt --exclude-from=$HOME/.rsyncExclude"
a rsssh="rslocal -e 'ssh -p 1234'"


######################
# SCRIPTS

a r="~/.scripts/remove"
a et="~/.scripts/emptyTrash"
a gss="~/.scripts/statusGitSvn"
a gsu="~/.scripts/updateGitSvn"


######################
# GUI PROGRAMS

# File editing
GEDITOR=gvim
a g="$GEDITOR"
a gg="kdesudo $GEDITOR"

# Programs
a o="xdg-open"
a syn="kdesudo synaptic"
a m="touch /tmp/meld1.txt /tmp/meld2.txt && meld /tmp/meld1.txt /tmp/meld2.txt"
