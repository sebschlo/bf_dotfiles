# If you come from bash you might have to change your $PATH.
export PATH=$PATH:/Applications/Processing.app/Contents/Java

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Prompt comes from starship (end of file + ~/.config/starship.toml),
# so no oh-my-zsh theme.
ZSH_THEME=""

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/sbin:$PATH"

# Preferred editor for local and remote sessions
alias vim=nvim
export EDITOR='nvim'

# NVM with improved lazy loading and .nvmrc support
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NODE_ENV=development

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# Lazy load conda for faster shell startup
conda() {
  unset -f conda
  if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
    . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
  fi
  conda "$@"
}
# <<< conda initialize <<<

export PYTHONDONTWRITEBYTECODE=True

# history
export HISTCONTROL=ignoredups:erasedups
HISTSIZE=10000
HISTFILESIZE=-1

# Aliases
alias ls='ls -G'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES && sudo killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO && sudo killall Finder'
alias tmux='tmux -2'
alias filesize='du -sch .[!.]* * |sort -h'
alias hp="git push heroku prod:master"

# AMAZON S3
alias syncgal='aws s3 sync --acl public-read --sse --delete ~/src/gallery_plain/ s3://sebs.gallery --exclude ".git/*"'

# Git & agent shortcuts
alias ..='cd ..'
alias add='git add .'
alias push='git push'
alias pull='git pull'
alias m='git switch main'
alias cc='claude --dangerously-skip-permissions'
alias co='codex --full-auto'

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Vim Mode
bindkey -v

# POSTGRES
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

# RUST
export PATH="$HOME/.cargo/bin:$PATH"

export HOMEBREW_NO_AUTO_UPDATE=1

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/sebastian/.lmstudio/bin"
eval "$(rbenv init -)"

# EMACS / DOOM
export PATH="$HOME/.emacs.d/bin:/Applications/Emacs.app/Contents/MacOS:/Applications/Emacs.app/Contents/MacOS/bin:$PATH"

# EXPO RN / ANDROID DEVELOPMENT
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Machine-local secrets and env — kept out of the public dotfiles repo
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Autosuggestions & syntax highlighting (brew-installed)
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^f' autosuggest-accept
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt
eval "$(starship init zsh)"
