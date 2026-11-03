# motd — terminal greeting

A "message of the day" for when you open a terminal. A **random picture** from your
folder sits next to an **info box** with a greeting, the date, weather, a system check
and today's focus minutes from `tmr`. With no pictures, a random cow tells you a fortune instead.

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
| `motd pics`            | List the pictures folder and the count             |
| `motd -h`              | Help                                               |

### Settings (environment variables)

| Variable    | Default            | Meaning                                                   |
|-------------|--------------------|-----------------------------------------------------------|
| `MOTD_CITY` | *(empty = auto)*   | Fixed weather city, e.g. `MOTD_CITY=Chennai`              |
| `MOTD_PICS` | `~/Pictures/motd`  | Picture folder                                            |
| `MOTD_MODE` | `auto`             | `auto` (picture if any, else cow) · `pic` · `cow` · `both` · `none` |

Set them permanently in `~/.zshrc`, e.g. `export MOTD_CITY=Chennai`, or try them once:
`MOTD_MODE=both motd`.
Size settings are at the top of the script: `PIC_SIZE="30x15"` (chafa cells, ≈240×240 px)
and `BOX_W=44`.

## Example

```
$ motd

 ▃▂▗▀▝▁▃▁▁▃▁▔▀▝▆▆▐▂▃▗▂▂▁▘▔▝▘▆▔▊  ╭────────────────────────────────────────────╮
 ▅▊▅▅▔▘▔▃▃▝▀▃▁▁▔▅▀▃▃▁▃▀▘▗▀▂▅▖▎▂  │  Good night 🌙  inba                       │
 ▖▐▆▁▁▁▕▆▖▁▃▅▘▅▔▔▆▆▅▀▔▃▃▅▅▂▔▏▃▔  │  Tuesday, 03 November 2026 · 22:21         │
 ▅▆▆▀▃▂▃▃▀▆▅▅▅▅▀▖▀▅▘▝▃▆▅▅▅▀▝▀▅▏  ├────────────────────────────────────────────┤
 ▁▃▂▃▀▃▆▆▀▃▂▕▊▔▘▁▔▔▎▁▂▅▅▅▝▎▞▘▆▍  │  weather  🌦️ +10°C (feels +8°C)            │
 ▀▃▃▃▃▃▔▗▁▁▂▂▗▔▃▗▅▂▂▁▗▝▕▕▏▁▍▔▏▁  │           Patchy rain nearby · Leeds       │
 ▝▃▃▃▃▀▅▃▂▁▋▂▃▔▁▔▕▏▏▔▔▆▂▆▆▅▁▀▁▃  │  system   RAM 1.9Gi free · disk 75%        │
 ▁▃▃▃▔▃▃▘▅▅▅▀▖▋▆▊▅▁▔▝▆▔▀▂▋▎▐▃▆▊  │           CPU +51.2°C · up 3h 33m          │
 ▀▝▀▀▅▖▖▆▆▕▅▅▃▃▀▅▃▃▀▖▖▂▁▖▂▋▝▆▆▘  │  focus    nothing yet · try: tmr pomo      │
 ▀▀▀▀▀▅▅▀▀▀▅▅▅▀▘▁▁▂▁▁▔▅▀▅▀▂▁▁▂▆  ╰────────────────────────────────────────────╯
```
(In the terminal, the picture is in full color.)

- **Wide terminal:** the picture is on the left and the box on the right. Whichever is shorter is centered vertically.
- **Narrow terminal** (picture + box don't fit): the picture goes above the box.
- **No pictures / `MOTD_MODE=cow`:** just the box, with the cow below.

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
  `~/.cache/motd/pics/`. The cache key is path + modified time + size + `PIC_SIZE`. A cached run takes ~0.14s.
  `rm -rf ~/.cache/motd` clears everything.
- **Tilix has no image protocol** (kitty/sixel), so chafa draws pictures with colored Unicode
  block characters (`--symbols block`). Simple, high-contrast pictures look best.
  Tall pictures come out narrower: chafa keeps the aspect ratio within 30×15.
- **Weather:** a single request (`format=%c|%t|%f|%C|%l`), cached per city. Offline, it shows the last
  cached value, or "unavailable". wttr.in guesses the location from your IP, so a VPN or Tailscale
  exit node gives the wrong city; set `MOTD_CITY` to fix that.
- **Focus line** reshapes `tmr stats` output, so it reads the same log as `tmr`.
- **Cow list:** this Fedora cowsay prints `cowsay -l` one name per line with no header. Lines containing
  `:` are filtered out in case another version adds a header.
- **Testing the layout without a terminal:** `COLUMNS=100 motd | <terminal emulator>`. `tput cols`
  respects `COLUMNS`. Note that `pyte` mishandles `U+FE0F`, so strip it before rendering a test.
