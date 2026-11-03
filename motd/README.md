# motd — terminal greeting

A "message of the day" for when you open a terminal: a greeting for the time of day,
the date, the weather, a one-line system check, today's focus minutes from `tmr`,
and a random cow telling you a fortune.

- **Source:** `motd/motd`
- **Installed as:** `~/bin/motd` (symlink via `./install.sh`)
- **Cache:** `~/.cache/motd/weather` (refreshed every 30 min)
- **Needs:** `curl`, `sensors`; optional: `fortune`, `cowsay`, `tmr`
- **Weather source:** [wttr.in](https://wttr.in) (free, no API key; finds your location from your IP)

## Quick reference

| Command               | What it does                                         |
|-----------------------|------------------------------------------------------|
| `motd`                | Full greeting (default)                              |
| `motd short`          | One line: time · weather · system                    |
| `motd weather`        | Weather for your auto-detected location (cached)     |
| `motd weather Chennai`| Weather for any city (not cached)                    |
| `motd cow`            | Just a random cow and fortune                        |
| `motd -h`             | Help                                                 |

## Example

```
$ motd

Good night 🌙  inba
Tuesday, 03 November 2026 · 22:05

weather  Leeds, England, GB: 🌦️  +10°C (feels +8°C), Patchy rain nearby
system   RAM free 2.2Gi · disk 75% used · +47.6°C · up 3 hours, 17 minutes
focus    Today: 2 focus sessions, 50 min total

 ________________________________
< Sometimes I live in the country >
 --------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

```
$ motd short
Tue 22:05 · Leeds, England, GB: 🌦️  +10°C (feels +8°C), Patchy rain nearby · RAM free 2.2Gi · ...
```

## Show it on every new terminal

Add this line to the end of `~/.zshrc`:
```bash
[[ -o interactive ]] && command -v motd >/dev/null && motd
```
Use `motd short` there instead if the full version is too much.

## Notes / gotchas
- **Speed:** a cached run is ~0.07s. When the cache has expired, the first terminal waits up to 4s for wttr.in (`curl -m 4`). If you're offline, it shows the last cached weather.
- **Wrong city?** wttr.in guesses from your IP, and VPNs/Tailscale exit nodes change that guess. Use `motd weather <city>` for a specific place, or put a city in the auto URL inside `weather()`.
- **Settings at the top of the script:** `WEATHER_TTL` (cache seconds) and `WEATHER_FMT` ([wttr.in format codes](https://github.com/chubin/wttr.in#one-line-output)).
- **Cow list:** this Fedora cowsay prints `cowsay -l` one name per line with no header. Lines containing `:` are filtered out in case another version adds a header. Some cows (dragon, stegosaurus...) are big.
- **Focus line** just calls `tmr stats`, so it reads the same log as `tmr`.
