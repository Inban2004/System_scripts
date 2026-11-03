# TODO

Ideas and planned changes, grouped by tool. Tick items off (`[x]`) as they're done
and note the change in the README changelog.

---

## motd — v2 layout (planned 2026-11-03)

Goal: make `motd` look good enough to show on every new terminal, **then** add it to `~/.zshrc`.

### 1. Boxed layout, one item per line
- [ ] Draw a rounded box around the info, using Unicode box characters `╭ ─ ╮ │ ╰ ╯`
- [ ] Put **weather**, **system** and **focus** each on their own labelled line (and wrap the long ones)
- [ ] Size the box to the terminal (`tput cols`), with a max width so it doesn't stretch on wide screens
- [ ] Measure line widths correctly: colors and emoji throw off `printf` padding (strip ANSI codes first and count emoji as 2 columns)

Target look:
```
╭──────────────────────────────────────────────╮
│  Good night 🌙  inba                         │
│  Tuesday, 03 November 2026 · 22:05           │
├──────────────────────────────────────────────┤
│  weather  🌦️  +10°C (feels +8°C)             │
│           Patchy rain nearby · Leeds         │
│  system   RAM free 2.2Gi · disk 75%          │
│           CPU +47.6°C · up 3h 17m            │
│  focus    2 sessions · 50 min today          │
╰──────────────────────────────────────────────╯
```

### 2. Random picture from a folder, via `chafa`
- [ ] Image folder: `~/Pictures/motd/` (outside the repo, so personal pics never get pushed)
      Allowed types: `.png .jpg .jpeg .gif .webp`
- [ ] Pick one at random each run and show it small with `chafa`
- [ ] Size: about **240×240 px**. chafa sizes in character cells (~8×16 px each),
      so start with `chafa --size=30x15` and adjust by eye
- [ ] Layout options to try:
  - **A)** picture on the **left**, info box on the **right**, side by side (nicest, harder: needs `paste` with fixed-width columns)
  - **B)** picture **above** the box (simple)
- [ ] If the folder is empty or missing, skip the picture quietly (fall back to the cow?)
- [ ] Terminal check: Tilix has no image protocol (kitty/sixel), so chafa will draw with
      Unicode block characters. Try `chafa --format=symbols --symbols=block` for the best look
- [ ] New subcommands: `motd pic` (just a random picture) and `motd pics` (list the folder and count)

### 3. Smaller things
- [ ] Shorter uptime text: `up 3h 17m` instead of `up 3 hours, 17 minutes`
- [ ] Choose a fixed weather city (wttr.in guessed **Leeds**, probably wrong because of VPN/Tailscale)
- [ ] Should the cow stay when a picture is shown? Maybe show one or the other: `MOTD_MODE=pic|cow|both`
- [ ] Keep a cached run under ~0.2s, since it runs on every terminal open

### 4. Last step
- [ ] Add to the end of `~/.zshrc`:
      `[[ -o interactive ]] && command -v motd >/dev/null && motd`

---

## Upcoming tools
- [ ] `typer` — typing-speed game: random sentence, WPM + accuracy, best scores in `~/.local/share/typer/`
- [ ] `tidy` — sort `~/Downloads` into folders by file type, with a `--dry-run`
