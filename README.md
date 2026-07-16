# dotfiles

Terminal environment: zsh (vi-mode) + starship, tmux, neovim (lazy.nvim), fzf.

## Fresh VPS (Debian/Ubuntu)

```sh
curl -fsSL https://raw.githubusercontent.com/sebschlo/bf_dotfiles/main/bootstrap.sh | sh
```

Installs apt packages (zsh, tmux, fzf, ripgrep, fd, python3, ...), neovim from the
official release, starship, oh-my-zsh, and tmux plugins; clones this repo to
`~/src/bf_dotfiles`, symlinks the dotfiles, and makes zsh the login shell.
Idempotent — safe to re-run.

## Mac / already cloned

```sh
./install.sh
```

Symlinks only. Idempotent; anything in the way is backed up to
`~/dotfiles_backup_<timestamp>/` first.
