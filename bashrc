shopt -s histappend
export HISTCONTROL=erasedups
export HISTSIZE=10000

export PATH=~/bin:~/bin/baseline/bin:/usr/local/git/bin:/Applications/VMware\ Fusion.app/Contents/Library/:~/bin/apache-ant-1.9.4/bin:$PATH
export VAGRANT_VMWARE_CLONE_DIRECTORY=/Users/dustins/Documents/Projects/.vagrant_vmware_vms
export VAGRANT_DEFAULT_PROVIDER=vmware_fusion

alias vim='mvim -v'
export VISUAL='vim -f'
export EDITOR='vim -f'


alias d="cd ~/Documents"
alias p="cd ~/Documents/Projects"
alias ls="/bin/ls -a"

alias gst='git status'
alias gb='git branch'
alias gca='git commit -v -a'
#source git-completion.bash

#alias vp='vim ~/dotfiles/bash_profile'
#alias sp='source ~/.bash_profile'

export HISTIGNORE="fg*"

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
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
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

# PS1="$GREEN\$(parse_git_branch)$BLACK\$ "
PS1="$GREEN\$(parse_git_branch)$BLACK\$ "
PS2='> '
PS4='+ '
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

eval "$(baseline autocomplete)"

date
export PATH=$PATH:/Users/dustins/bin/baseline/bin

##
# android dev
##
export ANDROID_HOME=/Users/dustins/bin/android-sdk-macosx
export PATH=$PATH:$ANDROID_HOME/tools
##
# Your previous /Users/dustins/.bash_profile file was backed up as /Users/dustins/.bash_profile.macports-saved_2014-06-30_at_23:49:35
##

# MacPorts Installer addition on 2014-06-30_at_23:49:35: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH
