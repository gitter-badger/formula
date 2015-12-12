# return on non-interactive shells - don't put anything that might produce output above here...
[[ $- != *i* ]] && return

###
### Global Configuration
###

# pull in global profile
if [ -f /etc/profile ]; then
	. /etc/profile
fi

# a nice liberal path with our own local items first
export PATH="$HOME/bin:$HOME/local/bin:$HOME/local/sbin:$PATH:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"

export GIT_EXECUTABLE=$(which git 2>/dev/null)

ps1_git_branch() {
	[ -z "$GIT_EXECUTABLE" ] && return
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		if lsmod | grep vboxguest; then
		    # Do nothing
		    :
		else
			git diff --quiet 2>/dev/null >&2 && dirty="" || dirty="●"
		fi
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		git diff --quiet 2>/dev/null >&2 && dirty="" || dirty="●"
	fi
	echo " git:${ref#refs/heads/}${dirty}"
}

num_users() {
	who | wc -l | tr -d ' '
}

num_jobs() {
	jobs -s | wc -l | tr -d ' '
}


login-info() {
	local loadavg=''
	if [ ! -r /proc/loadavg ]; then
		loadavg=$(uptime | awk -F'[a-z]:' '{print $2}' | awk -F' ' '{print $1}')
	else
		loadavg=$(awk '{print $2}' /proc/loadavg)
	fi

	if [ $(echo "${loadavg}>2" | bc -l) -eq 1 ]; then
		echo "Load average is above 2.0, skipping login info..."
		return
	fi

	# these arrays hold our login info items
	# the index of the names array matches the index of the output array
	local command_names
	local command_output


	command_names[0]="zombies"
	command_output[0]=$(ps aux | grep ' Z. ' | grep -v grep)

	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		if lsmod | grep vboxguest; then
		    # Do nothing
		    :
		else
			command_names[2]="disks > 90%"
			command_output[2]=$(df -lk 2>/dev/null | grep -v '^Filesystem' | awk '{ if ($5 > 90) { print $0 } }')
		fi
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		command_names[2]="disks > 90%"
		command_output[2]=$(df -lk 2>/dev/null | grep -v '^Filesystem' | awk '{ if ($5 > 90) { print $0 } }')
	fi

	# output it all
	echo ""
	echo -e "${USER} login to ${HOSTNAME} - $(date)"
	uptime
	echo ""

	# i is our loop iteration
	local i=0

	# l is the length of dashes needed to make a flush 80.
	# dashes & fulldashes are strings used in output
	local l=0
	local dashes=""
	local fulldashes=$(printf "%80s" | tr ' ' '-')

	# loop through our login_info items
	while [ $i -lt ${#command_names[@]} ]; do
		# only show commands with output
		if [ ! -z "${command_output[$i]}" ]; then
			# build the amount of dashes needed to make a flush 80
			l=$((80 - 7 - ${#command_names[$i]}))
			dashes=$(printf "%${l}s" | tr ' ' '-')
			echo "---( ${command_names[$i]} )$dashes"

			# show our output, use printf so that our newlines are shown
			printf "${command_output[$i]}\n"

			echo $fulldashes
		fi

		# next
		i=$(($i + 1))
	done
}

###
### Shell customization
###

# page with less
[ -x $(which less) ] && export PAGER=less || echo "WARNING: more sucks, install less"

# edit with vim
[ -x $(which vim) ] && export EDITOR=vim || {
	[ -x $(which vi) ] && export EDITOR=vi || echo "WARNING: couldn't find vi or vim"
}

# shell options
shopt -s cdspell        # correct minor spelling mistakes in directory names for cd
shopt -s checkwinsize   # keep the LINES & COLUMNS variables updated
shopt -s cmdhist        # save multi-line commands as a single history entry
shopt -s lithist        # multi-line commands in the history should maintain the newlines
shopt -u dotglob        # do not glob files that begin with a period in expansion
shopt -s extglob        # add extended globing
shopt -s histappend     # append the history to HISTFILE instead of overwriting
shopt -s histreedit     # allow for re-edits on failed history commands
shopt -s histverify     # verify history command before passing it to the shell
shopt -s checkhash      # ensure a hash command exists before re-executing, otherwise search in PATH
shopt -s promptvars     # ensure our prompt is parsed
shopt -s checkwinsize   # make sure bash updates our window size so that lines wrap properly
set -o notify           # report on terminated background jobs immediately
set -o ignoreeof        # dont log out on eof (^D)

# set our umask
umask 022

# find out some info about our term capabilities
term_colour=0
case $TERM in
	xterm*|color_xterm|rxvt|Eterm|screen*|linux)
	term_colour=1
	;;
esac

if [ ${term_colour} -eq 1 ]; then
        BLACK='\[\e[0;30m\]'
        BLUE='\[\e[0;34m\]'
        GREEN='\[\e[0;32m\]'
        CYAN='\[\e[0;36m\]'
        RED='\[\e[0;31m\]'
        PURPLE='\[\e[0;35m\]'
        BROWN='\[\e[0;33m\]'
        LIGHTGRAY='\[\e[0;37m\]'
        DARKGRAY='\[\e[1;30m\]'
        YELLOW='\[\e[1;33m\]'
        WHITE='\[\e[1;37m\]'
        NC='\[\e[m\]'
fi

# dircolors
if [ ${term_colour} -eq 1 ] && ( dircolors --help && ls --color ) &> /dev/null; then
        if [[ -f ~/.dir_colors ]]; then
                eval `dircolors -b ~/.dir_colors`
        elif [[ -f /etc/DIR_COLORS ]]; then
                eval `dircolors -b /etc/DIR_COLORS`
        fi
        alias ls="ls --color=auto"
        alias ll="ls --color=auto -al"
        alias grep="grep --colour"
else
        alias ls="ls -F"
        alias ll="ls -Fal"
fi

# set window title
case $TERM in
        xterm*|rxvt*|Eterm)
		export PROMPT_COMMAND='echo -ne "\033]2;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
                ;;
        screen*)
		# when in tmux (screen) set the title of the current pane to our hostname by default
		# to override it just 'export TITLE=Blah' in your shell
		export TITLE=$HOSTNAME
		export PROMPT_COMMAND='echo -ne "\033]2;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007\033k${TITLE}\033\\"'
                ;;
esac

# my prompt
# http://i.imgur.com/jfYidAv.png
[ ${EUID} -eq 0 ] && user_colour="${RED}" || user_colour="${LIGHTGRAY}"
PROMPT1="${user_colour}\u@\h ${BLUE}\w${NC} — u:\$(num_users) j:\$(num_jobs)\$(ps1_git_branch) (\D{%H:%M:%S %m.%d})"
export PS1="\n${PROMPT1}\n#\! ${user_colour}❯❯❯${NC} "

# use the bash-completion package if we have it
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
[ -f /etc/bash_completion ] && source /etc/bash_completion

complete 2>&1 >/dev/null
if [ $? = 0 ]; then
        # completion entries
        complete -A alias       alias unalias
        complete -A command     which
        complete -A export      export printenv
        complete -A hostname    ssh telnet ftp ncftp ping dig nmap
        complete -A helptopic   help
        complete -A job -P '%'  fg jobs
        complete -A setopt      set
        complete -A shopt       shopt
        complete -A signal      kill killall
        complete -A user        su userdel passwd
        complete -A group       groupdel groupmod newgrp
        complete -A directory   cd rmdir
fi

# command aliases - be paranoid & fix typos
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias iv='vi'
alias sl='ls'
alias vp='cp'
alias mb='mv'
alias grpe='grep'
alias gpre='grep'
alias whcih='which'
alias snv='svn'
alias poweroff='echo "Please run /sbin/poweroff to turn off the system"'

# only run pip with virtualenv and use the active env
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

# see if we have a custom set of init actions to include
test -r ~/.bash_custom && . ~/.bash_custom

# login info
login-info

