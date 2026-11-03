# motd — terminal greeting

A "message of the day" for when you open a terminal, in three columns:

**random picture** (chafa) **│ info box** (greeting, date, weather, system, `tmr` focus) **│ cowsay animal** telling a fortune

On a narrower terminal, the animal moves below. With no pictures, it's just the box and the animal.

- **Source:** `motd/motd`
- **Installed as:** `~/bin/motd` (symlink via `./install.sh`)
- **Pictures:** `~/Pictures/motd/` (`.png .jpg .jpeg .gif .webp`), kept outside the repo so they're never pushed
- **Cache:** `~/.cache/motd/` (weather, refreshed every 30 min, plus pre-rendered pictures)
- **Needs:** `curl`, `sensors`, `chafa` (pictures); optional: `fortune`, `cowsay`, `tmr`
- **Weather source:** [wttr.in](https://wttr.in) (free, no API key)

## Quick reference

| Command                | What it does                                       |
|------------------------|----------------------------------------------------|
| `motd`                 | Picture + info box (default)                       |
| `motd short`           | One line: time · weather · RAM · uptime            |
| `motd weather [city]`  | Weather for `MOTD_CITY`, auto-detect, or the given city |
| `motd cow`             | Just a random cow and fortune                      |
| `motd pic`             | Just a random picture                              |
| `motd pics`            | List the pictures folder and pre-render them (run after adding pictures) |
| `motd -h`              | Help                                               |

### Settings (environment variables)

| Variable    | Default            | Meaning                                                   |
|-------------|--------------------|-----------------------------------------------------------|
| `MOTD_CITY` | *(empty = auto)*   | Fixed weather city, e.g. `MOTD_CITY=Chennai`              |
| `MOTD_PICS` | `~/Pictures/motd`  | Picture folder                                            |
| `MOTD_MODE` | `auto`             | `auto`/`both` = picture + box + cow · `pic` = picture + box (fortune inside) · `cow` = box + cow · `none` = box only |

Set them permanently in `~/.zshrc`, e.g. `export MOTD_CITY=Chennai`, or try them once:
`MOTD_MODE=both motd`.
Size settings are at the top of the script: `PIC_SIZE="30x15"` (chafa cells, ≈240×240 px)
`BOX_W=44` and `COW_W=28` (how wide the cow's fortune bubble wraps).

## Example

```
$ motd                                                          (170-column terminal)
                                                                                     ___________________________
                                                                                    / Vermouth always makes me  \
                                                                                    | brilliant unless it makes |
                                                                                    \ me idiotic. -- E. F. Benson/
         ▅▔▔▀      ▀▔▔▅                                                              ---------------------------
       ▗▂▃▔▝▂▂    ▂▂▆▔▃▂▖          ╭────────────────────────────────────────────╮    \     ____________
       ▘▞▃▅▝▐▝▝▂▂▘▖▔▃▆▝▝▝          │  Good night 🌙  inba                       │     \    |__________|
      ▊▍▏▃▀▅▀▅▝▅▀▘▅▔▅▂▏▋▐▎         │  Tuesday, 03 November 2026 · 22:34         │         /           /\
      ▋▕▃▅▆▔▘▀▐▎▕▗▃▀▅▅▅▃▘▍         ├────────────────────────────────────────────┤        /           /  \
      ▋▀▆▐▀▀▖▐▗▗▗▀▅▀▀▅▆▆▕▍         │  weather  🌦️ +10°C (feels +8°C)            │       /___________/___/|
      ▋▐▐▘▀▁▁▋▗▐▐▐▖▁▂▂▃▘▊▍       ◀─┤           Patchy rain nearby · Leeds       │       |          |     |
    ▁▁▋▘▘▘▗▋▕▍▐▍▋▝▕▏▍▔▂▃▃▍▁▁       │  system   RAM 1.5Gi free · disk 75%        │       |  ==\ /== |     |
   ▐▁▁▁▁▁▁▁▝▅▍▁▁▁▁▕▅▘▁▁▁▁▂▂▁▐      │           CPU +45.1°C · up 3h 46m          │       |   O   O  | \ \ |
    ▖▀▀▀▃▃▀▅▔▅▃▁▁▃▅▔▀▀▀▀▀▅▀▗       │  focus    nothing yet · try: tmr pomo      │       |     <    |  \ \|
     ▀▁▀▀▀▃▃▃▂▁▘▝▁▂▃▃▀▀▃▃▁▀        ╰────────────────────────────────────────────╯      /|          |   \ \
       ▀▂▀▀▅▆▝▀▆▆▀▘▀▀▀▀▂▀                                                              ...
```
(The fox is from Fluent Emoji; in the terminal it's in full color. The animal is cowsay's `box`.)

- **Wide terminal (~120+ columns):** all three side by side, each centered vertically. The `◀─┤` tail
  joins the picture to the box.
- **Medium:** picture + box side by side, and the animal tells the fortune below.
- **Narrow:** picture, box and animal stacked.
- **No pictures:** box + animal.
- Only animals that fit the space left get picked. Widths run from ~30 (default cow) to ~80 (cupcake, turtle, dragon).

## Pictures

**Best for block art:** simple, bold subjects on a plain or transparent background, roughly square.
Detailed photos and wallpapers come out as noise.

The starter set (14 pictures) is **[Microsoft Fluent Emoji](https://github.com/microsoft/fluentui-emoji), 3D style, MIT license**:
rocket, hot beverage, ghost, alien monster, fox, panda, robot, ringed planet, cat face,
penguin, owl, dragon face, unicorn, octopus. To get them again (or add more; see the repo for names):

```bash
base="https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets"
for n in "Rocket" "Fox" "Cat face"; do
  f="$(echo "$n" | tr 'A-Z ' 'a-z_')_3d.png"
  curl -fsSL -o ~/Pictures/motd/"$f" "$base/${n// /%20}/3D/$f"
done
motd pics    # list them and pre-render
```

## Show it on every new terminal *(not enabled yet; see TODO.md)*

Add this to the end of `~/.zshrc`:
```bash
[[ -o interactive ]] && command -v motd >/dev/null && motd
```

## How it works / gotchas
- **Emoji vs. alignment:** emoji widths vary between terminals, and `🌦️` measures as 1 column but displays as 2.
  So box rows don't pad with spaces. They jump the cursor to a fixed column (`ESC[<n>G`) to draw
  the right border, which keeps the box straight whatever the emoji do.
- **Picture cache:** chafa takes ~0.3s on a big photo, so each picture is rendered once and saved in
  `~/.cache/motd/pics/`. The cache key is path + modified time + size + `PIC_SIZE`. A cached run takes ~0.2s.
  `motd pics` renders them all ahead of time.
  `rm -rf ~/.cache/motd` clears everything.
- **Tilix has no image protocol** (kitty/sixel), so chafa draws pictures with colored Unicode
  block characters (`--symbols block`). Simple, high-contrast pictures look best.
  Tall pictures come out narrower: chafa keeps the aspect ratio within 30×15.
- **Weather:** a single request (`format=%c|%t|%f|%C|%l`), cached per city. Offline, it shows the last
  cached value, or "unavailable". wttr.in guesses the location from your IP, so a VPN or Tailscale
  exit node gives the wrong city; set `MOTD_CITY` to fix that.
- **Picking the animal fast:** cowsay is Perl and takes ~30 ms per call. The width of every animal is measured once
  into `~/.cache/motd/cows.tsv` (the first run takes ~2.7s), then one that fits is picked with `awk` + `shuf`, so there's one cowsay call per run.
  Delete that file after installing new cows.
- **Fortune in the box** (`MOTD_MODE=pic` only): `fortune -s -n 120`, flattened and wrapped (`fold`, max 3 lines).
  `fold` leaves no final newline, so the read loop uses `|| [ -n "$line" ]` to keep the last line.
- **Focus line** reshapes `tmr stats` output, so it reads the same log as `tmr`.
- **Cow list:** this Fedora cowsay prints `cowsay -l` one name per line with no header. Lines containing
  `:` are filtered out in case another version adds a header.
- **Testing the layout without a terminal:** `COLUMNS=100 motd | <terminal emulator>`. `tput cols`
  respects `COLUMNS`. Note that `pyte` mishandles `U+FE0F`, so strip it before rendering a test.
