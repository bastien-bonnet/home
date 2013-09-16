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
alias pl="ps -eo user,pid,pcpu,pmem,start,etime,comm,args"
alias pg="pl | grep -i"
alias ks="qdbus org.kde.ksmserver /KSMServer logout 0 2 2"

alias jv="wget -qO - http://www.jeuxvideo.com/tests.htm | iconv -f latin1 | grep -iE \"<li>.*[0-9]{2}/[0-9]{2} -\" | sed \"s/<[^>]*>//g\" |tac"
alias jvpc="jv | grep 'PC$'"
alias freemem='sudo sync && sudo echo 3 | sudo tee /proc/sys/vm/drop_caches'

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
alias eckd="e ~/.conkyrc-desktop"
alias eckl="e ~/.conkyrc-laptop"
alias eckn="e ~/.conkyrc-netbook"
alias evrc="e ~/.vimrc"
alias efst="ee /etc/fstab"

# Navigation aliases
alias u='[[ "$(pwd)" != "/" ]] && pushd ..'
alias p="popd"

# rsync alisases
alias rslocal="rsync -nvihurlt --exclude-from=$HOME/.rsyncExclude"
alias rslocalc="rsync -vihurlt --exclude-from=$HOME/.rsyncExclude"
alias rsssh="rslocal -e 'ssh -p 1234'"

# Stop Flash tracking everything
alias flashStop="rm -rf ~/.adobe ~/.macromedia; ln -s /dev/null ~/.adobe; ln -s /dev/null ~/.macromedia" 

######################
# SCRIPTS

alias r="~/.scripts/remove"
alias et="~/.scripts/emptyTrash"

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
