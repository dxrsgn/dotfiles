# dotfiles

Each top-level directory is a package whose contents mirror `$HOME`.

| Package | Files |
|---------|-------|
| `tmux`  | `~/.tmux.conf`, `~/.tmux/scripts/cyrillic-keys.sh` |
| `vim`   | `~/.vimrc` |

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

Russian layout: `cyrillic-keys.sh` runs after TPM and copies every `prefix` and
`copy-mode-vi` binding onto the Cyrillic key in the same physical position
(`prefix с` = `prefix c`, `Э` = `"`, …). It only binds Cyrillic keys, so no
existing binding is overwritten.

### vim

- WSL: yanks are also copied to the Windows clipboard (via `clip.exe`).
- Russian layout: `langmap` makes normal-mode commands work on ЙЦУКЕН
  (`о` = `j`, `Ж` = `:`, …); insert mode is unaffected.
