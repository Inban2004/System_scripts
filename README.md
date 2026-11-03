# System_scripts

Small, fun and useful command-line tools for my Fedora laptop, built together with Claude.

**Machine:** Fedora 43 (KDE, Wayland), zsh, btrfs, ~7 GB RAM + zram swap.

## Tools

| Tool | Folder | What it's for | Try it |
|------|--------|---------------|--------|
| `tmr` | [`tmr/`](tmr/README.md) | Big clock, countdown, stopwatch, pomodoro + focus log | `tmr pomo` |
| `sys` | [`sys/`](sys/README.md) | System health, RAM hogs, network, boot, updates, cleanup | `sys` |
| `motd` | [`motd/`](motd/README.md) | Greeting: picture │ info box (weather, system, focus) │ cowsay animal with a fortune | `motd` |

Each folder's README covers that tool's commands, examples and gotchas.

## Layout

```
System_scripts/
├── README.md        ← you are here (index of all tools)
├── install.sh       ← symlinks every tool into ~/bin
├── TODO.md          ← planned changes and future tool ideas
├── tmr/
│   ├── tmr          ← the script (same name as the folder)
│   └── README.md
├── sys/
│   ├── sys
│   └── README.md
└── motd/
    ├── motd
    └── README.md
```

**Rule:** every tool lives in `<name>/<name>`, with a `<name>/README.md` next to it.
`install.sh` relies on this layout.

## Install / set up on a fresh machine

```bash
git clone https://github.com/Inban2004/System_scripts.git ~/claude_code/scripts
cd ~/claude_code/scripts
./install.sh          # links ~/bin/tmr, ~/bin/sys, ...
```
`~/bin` must be on your `PATH`; Fedora's default `~/.bashrc` adds it.
The links point back into this repo, so editing a script here takes effect right away.

## Shared conventions (keep new scripts consistent)

- Bash with `set -euo pipefail`
- A `usage()` heredoc, shown with `-h` / `--help`
- Subcommands handled with a `case` dispatcher, plus a sensible default with no arguments
- Colored section banners: `printf '\033[1;<color>m...'` (32 green, 33 yellow, 35 magenta, 36 cyan)
- Persistent data goes in `~/.local/share/<tool>/` (TSV logs), and throwaway cache in `~/.cache/<tool>/`; never in the repo
- Anything that uses sudo or deletes things asks first or says so in the help text

## Adding a new tool

1. `mkdir foo && $EDITOR foo/foo` (follow the conventions above)
2. Write `foo/README.md`: purpose, quick-reference table, examples, gotchas
3. Add a row to the **Tools** table above
4. `./install.sh`, then commit: `git add foo README.md && git commit -m "foo: add ..."`

## Changelog

- **2026-11-03** — `motd`: three-column layout, with the cowsay animal moved to the right of the box
  (below when it doesn't fit), cow widths cached so a run stays ~0.2s.
- **2026-11-03** — `motd`: cowsay-style speech bubble (`◀─┤` tail, fortune inside the box),
  14 Fluent Emoji 3D starter pictures (MIT), `motd pics` pre-renders, fixed the fortune losing its last line.
- **2026-11-03** — `motd` v2: rounded info box (one item per line), random `chafa`
  picture from `~/Pictures/motd` beside it (cached render), `MOTD_CITY`/`MOTD_PICS`/`MOTD_MODE`
  settings, shorter uptime, `pic`/`pics` subcommands. Not in `~/.zshrc` yet.
- **2026-11-03** — Added `motd`: greeting, wttr.in weather (cached 30 min),
  system one-liner, `tmr` focus stats, random cowsay fortune.
- **2026-11-03** — Repo created. Added `tmr` (made earlier with Claude web) and `sys`.
  Fixes to `sys`: per-app memory with spaces in names, duplicate disk line on btrfs,
  dnf5 `needs-restarting`, non-zero exit on an unknown subcommand.
