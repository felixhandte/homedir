# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=20000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "Done: $(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# # Source Facebook definitions
# if [ -f /home/engshare/admin/scripts/master.bashrc ]; then
#     . /home/engshare/admin/scripts/master.bashrc
# fi

# include CUDA toolkit
if [ -d "/usr/local/cuda-5.0" ] ; then
    export PATH="$PATH:/usr/local/cuda-5.0/bin"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-5.0/lib:/usr/local/cuda-5.0/lib64"
fi

# include OS X Git dir
if [ -d "/usr/local/git/bin" ] ; then
    export PATH="$PATH:/usr/local/git/bin"
fi

# include Android commands
if [ -d "$HOME/prog/android/adt/sdk/tools" ] ; then
    export PATH="$PATH:$HOME/prog/android/adt/sdk/tools"
fi
if [ -d "$HOME/prog/android/adt/sdk/platform-tools" ] ; then
    export PATH="$PATH:$HOME/prog/android/adt/sdk/platform-tools"
fi

# #get rid of lead www, etc
# alias tbgs='tbgs -i --stripdir'
# alias tbgr='tbgr -i --stripdir'
# alias fbgs='fbgs -i --stripdir'
# alias fbgr='fbgr -i --stripdir'
# alias obgs='obgs -i --stripdir'
# alias obgr='obgr -i --stripdir'
# alias cbgs='cbgs -i --stripdir'
# alias cbgr='cbgr -i --stripdir'

#typo aliases
alias cd..='cd ..'
alias cit='git'
alias g='git'
alias gi='git'
alias gti='git'
alias gitst='git st'
alias qgit='git'
alias tgit='git'
alias igt='git'

alias gh='hg'
alias hghg='hg'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias ls-la='ls -la'

alias findn='find . -name'
alias install='sudo apt-get install'

function follow() {
	mkdir -p ${@: -1} && mv "$@" &&	cd ${@: -1}
}

function say() {
	if [[ "${1}" =~ -[a-z]{2} ]]; then
		local lang=${1#-}
		local text="${*#$1}"
	else
		local lang=${LANG%_*}
		local text="$*"
	fi
	mplayer "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &>/dev/null
}

function remake() {
	while true
	do
		inotifywait -e modify * 2>&1
		make
	done
}

# Source: http://stackoverflow.com/questions/1763891/can-stdout-and-stderr-use-different-colors-under-xterm-konsole
function colerr() (set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

export EDITOR=nano

if [ -f ~/.gitenvvars ]; then
	. ~/.gitenvvars
fi

# The following needs to run after any aliases you want to get completion.
source ~/.bash_complete_aliases

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Glob dotfiles.
shopt -s dotglob

function _parse_git_branch {
    if [ "$(git rev-parse --show-toplevel 2>/dev/null)" = "$HOME" ]; then
        return
    fi
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        branch=${ref#refs/heads/}
	if [ "$branch" = "master" ]; then
		echo " (m)"
	else
	        echo " ("${branch:0:15}")"
	fi
}

# Determines the "branch" of the current repo and emits it.
# For use in generating the prompt.
# Avoids invoking "git" or "hg" for the sake of speed
_dotfiles_scm_info()
{
  # find out if we're in a git or hg repo by looking for the control dir
    local d git hg
    d="$PWD"
    while test "$d" != "/" ; do
        if [ -f "$d/.githomedirmarker" ] ; then
            break
        fi
        if test -d "$d/.git" ; then
            git="$d"
            break
        fi
        if test -d "$d/.hg" ; then
            hg="$d"
            break
        fi
        # portable "realpath" equivalent
            d=$(cd "$d/.." && echo $PWD)
    done
    # weird echo constructs are to force a suffix of a space character
    # in the case where we find a branch; we don't output anything if
    # we don't find one
    if test -n "$hg" ; then
        if test -f $hg/.hg/bookmarks.current ; then
            echo " (`cat $hg/.hg/bookmarks.current`)"
        elif test -f $hg/.hg/branch ; then
            echo " (`cat $hg/.hg/branch`)"
        fi
    elif test -n "$git" ; then
        if test -f "$git/.git/HEAD" ; then
            local head="`cat $git/.git/HEAD`"
            case "$head" in
                ref:\ refs/heads/master)
                    echo " (m)"
                    ;;
                ref:\ refs/heads/*)
                    if test -n "$ZSH_VERSION" ; then
                        # older zsh doesn't support the bash substring syntax
                        echo " ($head[17,-1])"
                    else
                        echo " (${head:16})"
                    fi
                    ;;
                *)
                    # not sure what this is
                    echo " (${head:7})"
                    ;;
            esac
        fi
    fi
}

function _color_return {
    ret=$?
    if [ $ret = 0 ]; then
        echo "0"
    else
        echo "31"
    fi
    #return $ret
}

PROMPT_COMMAND=""

if [ "`id -u`" -eq 0 ]; then
    END='#'
else
    END='$'
fi

PS1="\[\e[0;\$(_color_return)m\]\u\[\e[0m\]@\[\e[0;$((31 + $(hostname | cksum | cut -c1-3) % 6))m\]\h\[\e[0m\]:\w\[\e[0;33m\]\$(_dotfiles_scm_info)\[\e[0m\]$END "
