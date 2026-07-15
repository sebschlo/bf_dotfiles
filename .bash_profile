# Unlike earlier versions, Bash4 sources your bashrc on non-interactive shells.
# The line below prevents anything in this file from creating output that will
# break utilities that use ssh as a pipe, including git and mercurial.
[ -z "$PS1" ] && return

# User specific aliases and functions for all shells
export EDITOR=nvim
export VISUAL=nvim
export SHELL="/bin/bash"

set -o vi
stty stop undef

# create TAGS
alias tagphp='/home/engshare/admin/scripts/tagphp'  # or just have this in your $PATH
alias tagall='rm TAGS; find . -name "*.php" -o -name "*.phpt" -o -name "*.c" -o -name "*.cpp" -o -name "*.c++"  -o -name "*.h" -o -name "*.hpp" -o -name "*.py" -o -name "*.pl" -o -name "*.pm" -o -name "*.java" -o -name "*.thrift" | ctags -L -'
alias tagcpp='rm TAGS; find . -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" | ctags -L -'

# PATH
export PATH=/opt/homebrew/bin:$PATH

alias org="cd ~/Dropbox/org"

# history
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; history -n; $PROMPT_COMMAND"
HISTSIZE=10000
HISTFILESIZE=-1

# Formatting
export PS1="@\[$(tput sgr0)\]\[\033[38;5;193m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;195m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;177m\]\\$\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
export HISTSIZE=10000

# Git completion
#[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}


## PERSONAL LAPTOP
#if [ "$HOSTNAME" = "Tatan.local" ]; then
  echo "Adding Tatan Configuration"

  # Aliases
  alias ls='ls -G'
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES && sudo killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO && sudo killall Finder'
  alias tmux='tmux -2'

  # POSTGRES
  export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

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

  # AMAZON S3
  alias syncgal='aws s3 sync --acl public-read --sse --delete ~/src/gallery_plain/ s3://sebs.gallery --exclude ".git/*"'
  alias filesize='du -sch .[!.]* * |sort -h'

  # Machine-local secrets and env — kept out of the public dotfiles repo
  [ -f ~/.bash_profile.local ] && source ~/.bash_profile.local

  alias hp="git push heroku prod:master"

  export PATH="$HOME/.cargo/bin:$PATH"

  HOMEBREW_NO_AUTO_UPDATE=1
#fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/sebastian/.lmstudio/bin"
