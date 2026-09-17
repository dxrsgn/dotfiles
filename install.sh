#!/usr/bin/env bash
# Symlink dotfile packages into $HOME.
# Usage: ./install.sh [package...]   (default: all packages)
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES"

if [ $# -gt 0 ]; then
  packages=("$@")
else
  packages=()
  for d in */; do packages+=("${d%/}"); done
fi

for pkg in "${packages[@]}"; do
  [ -d "$pkg" ] || { echo "no such package: $pkg" >&2; exit 1; }
  echo "==> $pkg"
  while IFS= read -r -d '' src; do
    rel="${src#"$pkg"/}"
    dest="$HOME/$rel"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      echo "    backing up $dest -> $dest.bak"
      mv "$dest" "$dest.bak"
    fi
    ln -sfn "$DOTFILES/$src" "$dest"
    echo "    $dest -> $DOTFILES/$src"
  done < <(find "$pkg" -type f -print0)
done

if [[ " ${packages[*]} " == *" tmux "* ]] && ! command -v tmux >/dev/null; then
  echo "note: tmux is not installed (e.g. sudo apt install tmux)"
fi
