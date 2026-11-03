#!/usr/bin/env bash
# install.sh — symlink every tool (<name>/<name>) into ~/bin
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/bin"
mkdir -p "$BIN"

for dir in "$REPO"/*/; do
    name="$(basename "$dir")"
    src="$dir$name"
    [ -f "$src" ] || continue
    dest="$BIN/$name"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        # a real file is in the way: keep it as a backup
        mv "$dest" "$dest.bak"
        echo "backed up  $dest -> $dest.bak"
    fi
    chmod +x "$src"
    ln -sfn "$src" "$dest"
    echo "linked     $name -> $src"
done
