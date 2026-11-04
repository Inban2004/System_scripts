# cmds — cheat sheet for all my tools

Can't remember what you have or how a command works? Type `cmds`.
It's built **live from `~/bin`**: it follows each symlink that `install.sh` made back to `<repo>/<name>/<name>`,
so a new tool shows up automatically, **from any repo (public or private)**, with no list to maintain.

- **Source:** `cmds/cmds`
- **Installed as:** `~/bin/cmds` (symlink via `./install.sh`)
- **Also in:** `motd`, whose info box shows a random `tip` from `cmds` on every run

## Quick reference

| Command            | What it does                                         |
|--------------------|------------------------------------------------------|
| `cmds`             | Every tool with a one-line description               |
| `cmds <tool>`      | That tool's full usage + where its README is         |
| `cmds all`         | Every tool's usage on one page                       |
| `cmds find <word>` | Search all commands: `cmds find undo`, `cmds find pomo` |
| `cmds tip`         | One random command to try                            |
| `cmds -h`          | Help                                                 |

## Example

```
$ cmds

your tools (6 · from ~/bin)

  cmds    cheat sheet for all my tools, built live from ~/bin so it's never out of date
  motd    terminal greeting: random picture | info box (weather, system, focus) | cowsay fortune
  sys     Fedora system health, maintenance and cleanup dispatcher
  tidy    sort a messy folder (default ~/Downloads) into type folders; dry run first, undo anytime
  tmr     clock / countdown / pomodoro / stopwatch, keeps system awake, logs sessions
  typer   terminal typing-speed game: live coloring, WPM + accuracy, best scores

  more: cmds <tool> full usage · cmds find <word> search · cmds tip random idea

$ cmds find undo
  tidy go [dir]          actually move the files (logged, undoable)
  tidy undo              put back everything from the last `tidy go`

$ cmds tip
tmr pomo [cycles]   pomodoro set: 25m focus / 5m break, long break every 4th (default 4 cycles)
```

## How it reads the tools (the contract every tool must follow)

`cmds` relies on the repo conventions, so **every new tool needs these** or it won't show up properly:

1. **Layout:** `<name>/<name>`, installed with that repo's `install.sh` (the `~/bin/<name>` symlink is how `cmds` finds it).
2. **Line 2 of the script** is the description: `# <name> — <what it does>` (with an em dash `—`).
3. **A `usage()` function holding a heredoc** (`cat <<'EOF' ... EOF`), where each command line looks like
   `  <name> <args>   <description>`: two leading spaces, then **at least 2 spaces** between the
   command and its description. `cmds tip` and motd's tip split on that gap.

It reads the usage text **from the source with `sed`**. It never runs the tools, so it's instant (~0.02s)
and has no side effects.

Check that all tools follow rule 3:
```bash
for t in */; do t=${t%/}; sed -n "/^usage() *{/,/^EOF/p" $t/$t | grep -E "^  $t( |$)" \
  | grep -vE '^  \S.*\S {2,}\S' | sed "s/^/$t: /"; done      # no output = all good
```

## Notes
- `cmds tip-raw` prints `command|description` and is what motd uses.
- **How tools are found:** every symlink in `~/bin` whose real path ends in `<name>/<name>`. Plain files (like `tmr.bak`)
  and links to other things are ignored. No repo path is written in the script, so private repos stay out of
  this public code.
- Moved or re-cloned a repo? Re-run its `install.sh` and `cmds` follows the new links.
