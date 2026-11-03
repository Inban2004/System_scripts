# TODO

Ideas and planned changes, grouped by tool. Tick items off (`[x]`) as they're done
and note the change in the README changelog.

---

## motd — v2 layout (planned 2026-11-03, built 2026-11-03)

Goal: make `motd` look good enough to show on every new terminal, **then** add it to `~/.zshrc`.

### 1. Boxed layout, one item per line
- [x] Draw a rounded box around the info, using Unicode box characters `╭ ─ ╮ │ ╰ ╯`
- [x] Put **weather**, **system** and **focus** each on their own labelled line (and wrap the long ones)
- [x] Size the box to the terminal (`tput cols`), with a max width so it doesn't stretch on wide screens
      → done as a fixed `BOX_W=44`; the picture moves above the box when the terminal is too narrow
- [x] Measure line widths correctly: colors and emoji throw off `printf` padding (strip ANSI codes first and count emoji as 2 columns)
      → solved differently: the right border is drawn at an absolute cursor column (`ESC[nG`)

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
- [x] Image folder: `~/Pictures/motd/` (outside the repo, so personal pics never get pushed)
      Allowed types: `.png .jpg .jpeg .gif .webp`
- [x] Pick one at random each run and show it small with `chafa`
- [x] Size: about **240×240 px**. chafa sizes in character cells (~8×16 px each),
      so start with `chafa --size=30x15` and adjust by eye
- [x] Layout options to try:
  - **A)** picture on the **left**, info box on the **right**, side by side (nicest, harder: needs `paste` with fixed-width columns)
  - **B)** picture **above** the box (simple)
- [x] If the folder is empty or missing, skip the picture quietly (fall back to the cow?)
- [x] Terminal check: Tilix has no image protocol (kitty/sixel), so chafa will draw with
      Unicode block characters. Try `chafa --format=symbols --symbols=block` for the best look
- [x] New subcommands: `motd pic` (just a random picture) and `motd pics` (list the folder and count)

### 3. Smaller things
- [x] Shorter uptime text: `up 3h 17m` instead of `up 3 hours, 17 minutes`
- [x] Weather city setting: `MOTD_CITY` env var (done)
- [ ] Pick the actual city and `export MOTD_CITY=...` in `~/.zshrc` (wttr.in guesses **Leeds**)
- [x] Should the cow stay when a picture is shown? Maybe show one or the other: `MOTD_MODE=pic|cow|both`
- [x] Keep a cached run under ~0.2s, since it runs on every terminal open

### 4. Last step
- [x] Drop some pictures into `~/Pictures/motd/` (14 Fluent Emoji 3D + 3 of my wallpapers)
- [x] Cowsay-style: picture "says" the box via a `◀─┤` tail, fortune inside the bubble
- [ ] Check the look in real Tilix and tune `PIC_SIZE` / `BOX_W` by eye
- [ ] Maybe remove the 3 big wallpapers (gargantua, japan, sukuna): detailed photos look noisy as blocks
- [ ] Add to the end of `~/.zshrc`:
      `[[ -o interactive ]] && command -v motd >/dev/null && motd`

---

## Upcoming tools
- [ ] `typer` — typing-speed game: random sentence, WPM + accuracy, best scores in `~/.local/share/typer/`
- [ ] `tidy` — sort `~/Downloads` into folders by file type, with a `--dry-run`
