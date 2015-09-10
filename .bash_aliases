# bash aliases
alias f="find . -iname"
alias grep="grep --color=auto"
alias ls="ls --color=auto -F"
alias l="ls"
alias ll="ls -l"
alias la="ls -A"
alias lla="ls -Al"
alias wl="wc -l"
alias rm="rm -i"
alias r="mv -bt ~/.local/share/Trash/files/"
alias pl="ps -eo pid,user,pcpu,pmem,start,comm,args"
grepWithFirstLine () {
	sed -n -e '1p' -e '1d' -e "/$1/Ip"
}
alias pg="pl | grepWithFirstLine"
alias duh="du -had 1 | sort -h"

alias lessh='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less -MR '

alias ks="qdbus org.kde.ksmserver /KSMServer logout 0 2 2"

alias jv="wget -qO - http://www.jeuxvideo.com/tests.htm | iconv -f latin1 | grep -iE \"<li>.*[0-9]{2}/[0-9]{2} -\" | sed \"s/<[^>]*>//g\" |tac"
alias jvpc="jv | grep 'PC$'"
alias freemem='sudo sync && sudo echo 3 | sudo tee /proc/sys/vm/drop_caches'
alias rs='redshift -l 48.9:2.3 -t 5700:4000 -b 1 -m randr -v'

# Text processing
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

# Alienware NumpadEnter mapping to Enter
alias awe="xmodmap -e 'keycode 104 = Return'"

# file edition
export EDITOR=vim
alias v="vim"
alias e="$EDITOR"
alias ee="sudo $EDITOR"
alias erc="e ~/.bashrc; source ~/.bashrc; echo '.bashrc sourced'"
alias ercm="e ~/.bashrc_machine_specific; source ~/.bashrc_machine_specific; echo '.bashrc_machine_specific sourced'"
alias eba="e ~/.bash_aliases; source ~/.bash_aliases && echo 'aliases sourced'"
alias ebf="e ~/.bash_functions; source ~/.bash_functions && echo 'functions sourced'"
alias eckd="e ~/.conkyrc-desktop"
alias eckl="e ~/.conkyrc-laptop"
alias eckn="e ~/.conkyrc-netbook"
alias evrc="e ~/.vimrc"
alias etodo="e ~/todo.txt"
alias todo='sort ~/todo.txt | grep -v ^x | grep -E "@waiting|$"'
alias efst="ee /etc/fstab"

# Navigation aliases
alias u='[[ "$(pwd)" != "/" ]] && pushd ..'
alias p="popd"

# rsync aliases
alias rslocal="rsync -nvihurlt --exclude-from=$HOME/.rsyncExclude"
alias rslocalc="rsync -vihurlt --exclude-from=$HOME/.rsyncExclude"
alias rsssh="rslocal -e 'ssh -p 1234'"

######################
# SCRIPTS

alias r="~/.scripts/remove"
alias et="~/.scripts/emptyTrash"
alias gss="~/.scripts/statusGitSvn"
alias gsu="~/.scripts/updateGitSvn"

######################
# GUI PROGRAMS

# File editing
GEDITOR=gvim
alias g="$GEDITOR"
alias gg="kdesudo $GEDITOR"

# Programs
alias o="xdg-open"
alias syn="kdesudo synaptic"
alias gp="kdesudo gparted"
alias m="touch /tmp/meld1.txt /tmp/meld2.txt && meld /tmp/meld1.txt /tmp/meld2.txt"
