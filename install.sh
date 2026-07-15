#!/bin/sh
# Symlink these dotfiles into $HOME.
# Idempotent: correct links are left alone; anything else is backed up first.
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

link() {
  src="$REPO/$1"
  dst="$HOME/$1"
  if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then
    echo "ok      $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "$1")"
    if ! mv "$dst" "$BACKUP/$1" 2>/dev/null; then
      echo "SKIP    $dst (cannot move it away — check ownership)"
      return
    fi
    echo "backup  $dst -> $BACKUP/$1"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked  $dst -> $src"
}

# single files
link .bash_profile
link .bashrc
link .condarc
link .fzf.bash
link .fzf.zsh
link .gitconfig
link .inputrc
link .tmux.conf
link .vimrc
link .zshrc
link .config/starship.toml

# whole directories (nothing writes into these at runtime except lazy-lock.json,
# which we want tracked)
link .config/nvim
link .config/wezterm
link .doom.d

echo "done. backups (if any) in: $BACKUP"
