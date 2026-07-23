#!/bin/sh
# Bootstrap a fresh Debian/Ubuntu box (VPS) with my terminal environment:
# apt packages, neovim (official build), starship, oh-my-zsh, tpm, dotfile symlinks.
#
#   curl -fsSL https://raw.githubusercontent.com/sebschlo/bf_dotfiles/main/bootstrap.sh | sh
#
# Idempotent: safe to re-run. Mac-only files get linked too; they're inert here.
set -e

REPO_URL="${BF_DOTFILES_REPO:-https://github.com/sebschlo/bf_dotfiles.git}"
REPO_DIR="$HOME/src/bf_dotfiles"

# Everything apt should install. Edit to taste.
PACKAGES="git curl ca-certificates zsh tmux fzf ripgrep fd-find unzip
  htop tree jq wget tig python3 python3-pip python3-venv locales
  zsh-autosuggestions zsh-syntax-highlighting"

main() {
  command -v apt-get >/dev/null 2>&1 || {
    echo "error: this script only supports Debian/Ubuntu (apt-get not found)" >&2
    exit 1
  }

  SUDO=""
  if [ "$(id -u)" -ne 0 ]; then
    command -v sudo >/dev/null 2>&1 || {
      echo "error: run as root or install sudo first" >&2
      exit 1
    }
    SUDO="sudo"
  fi

  echo "==> apt packages"
  export DEBIAN_FRONTEND=noninteractive
  $SUDO apt-get update -qq
  # shellcheck disable=SC2086  # PACKAGES is intentionally word-split
  $SUDO apt-get install -y -qq $PACKAGES

  # Debian/Ubuntu ship fd as fdfind; the fzf helpers in .bash_profile expect fd
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    $SUDO ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi

  # .zshrc exports LANG=en_US.UTF-8; minimal server images don't generate it
  if ! locale -a 2>/dev/null | grep -qi '^en_US\.utf-\?8$'; then
    echo "==> en_US.UTF-8 locale"
    $SUDO sed -i 's/^# *\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen 2>/dev/null || true
    grep -q '^en_US\.UTF-8 UTF-8' /etc/locale.gen 2>/dev/null ||
      echo 'en_US.UTF-8 UTF-8' | $SUDO tee -a /etc/locale.gen >/dev/null
    $SUDO locale-gen >/dev/null || true
  fi

  # apt's neovim is too old for this config (needs 0.11+: vim.uv, vim.lsp.completion)
  if [ ! -x /opt/nvim/bin/nvim ]; then
    echo "==> neovim (latest stable release)"
    case "$(uname -m)" in
      x86_64)        nvim_arch=x86_64 ;;
      aarch64|arm64) nvim_arch=arm64 ;;
      *) echo "error: unsupported architecture $(uname -m)" >&2; exit 1 ;;
    esac
    curl -fsSL -o /tmp/nvim.tar.gz \
      "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz"
    $SUDO rm -rf "/opt/nvim-linux-${nvim_arch}" /opt/nvim
    $SUDO tar -C /opt -xzf /tmp/nvim.tar.gz
    $SUDO mv "/opt/nvim-linux-${nvim_arch}" /opt/nvim
    rm -f /tmp/nvim.tar.gz
  fi
  $SUDO ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

  if ! command -v starship >/dev/null 2>&1; then
    echo "==> starship prompt"
    curl -fsSL https://starship.rs/install.sh | $SUDO sh -s -- --yes >/dev/null
  fi

  echo "==> dotfiles repo"
  if [ ! -d "$REPO_DIR" ]; then
    mkdir -p "$(dirname "$REPO_DIR")"
    git clone "$REPO_URL" "$REPO_DIR"
  elif [ -d "$REPO_DIR/.git" ]; then
    git -C "$REPO_DIR" pull --ff-only || true
  fi

  echo "==> symlinks"
  sh "$REPO_DIR/install.sh"

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended --keep-zshrc >/dev/null
  fi

  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "==> tmux plugin manager"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null || true

  echo "==> neovim plugins (lazy.nvim restore, headless)"
  nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 ||
    echo "note: plugin restore had issues; run :Lazy restore inside nvim"

  user="$(id -un)"
  zsh_path="$(command -v zsh)"
  if [ "$(getent passwd "$user" | cut -d: -f7)" != "$zsh_path" ]; then
    echo "==> default shell -> zsh"
    $SUDO chsh -s "$zsh_path" "$user" ||
      echo "warning: chsh failed; run manually: chsh -s $zsh_path" >&2
  fi

  echo ""
  echo "All set. Start using it with: exec zsh   (or reconnect)"
}

main "$@"
