# dotfiles

Each top-level directory is a package whose contents mirror `$HOME`.

| Package | Files |
|---------|-------|
| `tmux`  | `~/.tmux.conf` |

## Install

```bash
git clone https://github.com/dxrsgn/dotfiles.git ~/dotfiles
~/dotfiles/install.sh          # all packages
~/dotfiles/install.sh tmux     # just tmux
```

Existing files are moved to `*.bak` and replaced with symlinks into this repo.
The layout is also compatible with GNU Stow (`stow tmux`).

### tmux

Requires tmux ≥ 3.2 and git. On first launch the config clones
[TPM](https://github.com/tmux-plugins/tpm) and installs plugins automatically.
Inside tmux, `prefix + I` installs newly added plugins, `prefix + U` updates them.
