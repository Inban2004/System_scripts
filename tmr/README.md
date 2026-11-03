# tmr — terminal timer, pomodoro & focus log

Big-font clock, countdown, stopwatch and pomodoro in the terminal.
It keeps the laptop awake while running (`systemd-inhibit`), shows a desktop
notification when a timer ends, and logs finished sessions.

- **Source:** `tmr/tmr`
- **Installed as:** `~/bin/tmr` (symlink, via `./install.sh`)
- **Log:** `~/.local/share/tmr/log.tsv`
- **Needs:** `termdown` (`pip install --user termdown`), `notify-send`
- **Origin:** first script, made with Claude web

## Quick reference

| Command             | What it does                                                |
|---------------------|-------------------------------------------------------------|
| `tmr`               | Live big clock                                              |
| `tmr 25m [title]`   | Countdown (any termdown time: `90s`, `10m`, `1h30m`, `14:30`) |
| `tmr up [title]`    | Stopwatch, counting up                                      |
| `tmr pomo [cycles]` | 25m focus / 5m break, 15m long break every 4th (default 4)  |
| `tmr log`           | Today's finished sessions                                   |
| `tmr stats`         | Today's focus count and total minutes                       |
| `tmr -h`            | Help                                                        |

## Examples

```bash
tmr 45m "Study DSA"      # 45-minute countdown titled "Study DSA"
tmr up "Gym"             # stopwatch
tmr pomo 2               # 2 focus/break cycles (~1 hour)
tmr 14:30 "Meeting"      # count down to 2:30 PM
```

Keys while running (from termdown): **Space** = pause/resume, **R** = reset,
**Q** or **Ctrl+C** = quit. Quitting a countdown early does **not** log it.

### Log / stats
```
$ tmr log
2026-11-03 10:00  focus  25m  Focus 1/4
2026-11-03 10:25  break  5m   Break

$ tmr stats
Today: 1 focus sessions, 25 min total
```

## Notes / gotchas
- `FONT="big"` at the top sets the figlet font termdown uses. Change it if it looks wrong.
- Countdowns of 10 seconds or less show in red (`-c 10`) and beep at the end (`-b`).
- Only sessions of type `focus` count toward `stats`. Breaks are logged but not counted.
- Log format (TSV): `date time <TAB> type <TAB> duration <TAB> title`.
