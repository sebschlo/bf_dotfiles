# Setup fzf: Homebrew on macOS, apt package on Debian/Ubuntu
# -----------------------------------------------------------
if [[ -d /opt/homebrew/opt/fzf/bin && ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* && -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] &&
  source /opt/homebrew/opt/fzf/shell/completion.zsh
[[ $- == *i* && -f /usr/share/doc/fzf/examples/completion.zsh ]] &&
  source /usr/share/doc/fzf/examples/completion.zsh

# Key bindings
# ------------
[[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] &&
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] &&
  source /usr/share/doc/fzf/examples/key-bindings.zsh
