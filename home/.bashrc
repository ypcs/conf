# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -d "${HOME}/work/my/scripts" ]
then
    PATH="${PATH}:${HOME}/work/my/scripts"
fi

if [ -d "${HOME}/bin" ]
then
    PATH="${HOME}/bin:${PATH}"
fi

if [ -f "${HOME}/.bashrc.local" ]
then
    . "${HOME}/.bashrc.local"
fi

# Add support for Vagrant workspace (vgws)
if [ -f "${HOME}/work/my/vgws/Vagrantfile" ]
then
    vgws() {
        CUDI="${PWD}"
        cd "${HOME}/work/my/vgws"
        vagrant up
        vagrant ssh
        cd "${CUDI}"
    }
    vgwsdestroy() {
        CUDI="${PWD}"
        cd "${HOME}/work/my/vgws"
        vagrant destroy -f
        cd "${CUDI}"
    }
    vgwshalt() {
        CUDI="${PWD}"
        cd "${HOME}/work/my/vgws"
        vagrant halt
        cd "${CUDI}"
    }
fi

if [ -x /usr/bin/vim ]
then
    export EDITOR="/usr/bin/vim"
    alias nano=vim
fi

alias skim='/usr/bin/nano -v'

if [ -x /usr/share/source-highlight/src-hilite-lesspipe.sh ]
then
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
    export LESS=' -R '
fi

if [ -x /usr/bin/git ]
then
    git-github-origin() {
        if [ ! -d ".git" ]
        then
            echo "Error: not in git repo."
            exit 1
        fi
        ORIGIN="$(git remote -v |grep origin)"
        HTTPS_URL="$(echo ${ORIGIN} |awk '{print $2}' |grep ^https://github.com/)"
        if [ -z "${HTTPS_URL}" ]
        then
            echo "E: Repository doesn't have https github origin."
        fi
        echo "I: Rename origin to https..."
        git remote rename origin https
        GIT_URL="$(echo ${HTTPS_URL} |sed 's,https://,git@,g' |sed 's,github.com/,github.com:,g')"
        if [ -z "$(echo ${GIT_URL} |grep .git$)" ]
        then
            echo "I: Append .git to URL..."
            GIT_URL="${GIT_URL}.git"
        fi
        echo "I: Add new origin ${GIT_URL}..."
        git remote add origin "${GIT_URL}"
    }
fi
