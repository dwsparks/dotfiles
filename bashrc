# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
shopt -s histappend
export HISTCONTROL=erasedups
export HISTSIZE=10000

export HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac



#set up vi/vim
if hash mvim 2>/dev/null; then
        alias vim='mvim -v'
fi
if hash vim 2>/dev/null; then
    export VISUAL='vim -f'
    export EDITOR='vim -f'
fi

if [ -d "$HOME/Documents" ]; then
    alias d="cd ~/Documents"
fi
if [ -d "$HOME/Documents/Projects" ]; then
    alias p="cd ~/Documents/Projects"
else
    if [ -d "$HOME/Projects" ]; then
        alias p="cd ~/Projects"
    fi
fi

alias ls="/bin/ls -lah"

alias gst='git status'
alias gb='git branch'
alias gca='git commit -v -a'
#source git-completion.bash

alias vp='vim ~/dotfiles/bash_profile'
alias sp='source ~/.bash_profile'

export HISTIGNORE="fg*"

## Set up the command prompt to have git status
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local  BLACK="\[\033[0;0m\]"

 # PS1="$GREEN\$(parse_git_branch)$BLACK\$ "
 PS1="\u@\h$GREEN \$(parse_git_branch)$BLACK\$ "
 PS2='> '
 PS4='+ '

 case "$TERM" in
 xterm*|rxvt*)
     PS1="\[\e]0;\u@\h \$(parse_git_branch)\a\]$PS1"
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
 else
     export CLICOLOR=1
 fi
}
proml

function directory_to_titlebar {
   local pwd_length=42  # The maximum length we want (seems to fit nicely
                        # in a default length Terminal title bar).
   # Get the current working directory.  We'll format it in $dir.
   local dir="$PWD"

   # Substitute a leading path that's in $HOME for "~"
   if [[ "$HOME" == ${dir:0:${#HOME}} ]] ; then
       dir="~${dir:${#HOME}}"
   fi

   # Append a trailing slash if it's not there already.
   if [[ ${dir:${#dir}-1} != "/" ]] ; then
       dir="$dir/"
   fi

   # Truncate if we're too long.
   # We preserve the leading '/' or '~/', and substitute
   # ellipses for some directories in the middle.
   if [[ "$dir" =~ (~){0,1}/.*(.{${pwd_length}}) ]] ; then
       local tilde=${BASH_REMATCH[1]}
       local directory=${BASH_REMATCH[2]}

       # At this point, $directory is the truncated end-section of the
       # path.  We will now make it only contain full directory names
       # (e.g. "ibrary/Mail" -> "/Mail").
       if [[ "$directory" =~ [^/]*(.*) ]] ; then
           directory=${BASH_REMATCH[1]}
       fi

       # Can't work out if it's possible to use the Unicode ellipsis,
       # '…' (Unicode 2026).  Directly embedding it in the string does not
       # seem to work, and \u escape sequences ('\u2026') are not expanded.
       #printf -v dir "$tilde/\u2026$s", $directory"
       dir="$tilde/...$directory"
   fi

   # Don't embed $dir directly in printf's first argument, because it's
   # possible it could contain printf escape sequences.
   printf "\033]0;%s\007" "$dir"
}

if [[ "$TERM" == "xterm" || "$TERM" == "xterm-color" ]] ; then
 export PROMPT_COMMAND="directory_to_titlebar"
fi

export PATH=/usr/local/bin:/usr/bin:/bin:/sbin:~/bin:$PATH
