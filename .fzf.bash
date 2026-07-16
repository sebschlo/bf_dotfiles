# Setup fzf: Homebrew on macOS, apt package on Debian/Ubuntu
# -----------------------------------------------------------
if [[ -d /opt/homebrew/opt/fzf/bin && ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* && -f /opt/homebrew/opt/fzf/shell/completion.bash ]] &&
  source /opt/homebrew/opt/fzf/shell/completion.bash
[[ $- == *i* && -f /usr/share/doc/fzf/examples/completion.bash ]] &&
  source /usr/share/doc/fzf/examples/completion.bash

# Key bindings
# ------------
[[ -f /opt/homebrew/opt/fzf/shell/key-bindings.bash ]] &&
  source /opt/homebrew/opt/fzf/shell/key-bindings.bash
[[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] &&
  source /usr/share/doc/fzf/examples/key-bindings.bash
