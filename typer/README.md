# typer — terminal typing-speed game

Type a random sentence while each character lights up **green** (right) or **red** (wrong).
When you finish, you get your **WPM** and **accuracy**, plus a 🎉 when you beat your best.
Every round is logged, and `typer stats` draws a sparkline of your recent rounds.

- **Source:** `typer/typer`
- **Installed as:** `~/bin/typer` (symlink via `./install.sh`)
- **Log:** `~/.local/share/typer/scores.tsv`
- **Needs:** bash 5 (`$EPOCHREALTIME`); optional `fortune` (sentences come from it, with a built-in list as fallback)

## Quick reference

| Command            | What it does                                        |
|--------------------|-----------------------------------------------------|
| `typer`            | One round with a random sentence                    |
| `typer 5`          | Five rounds in a row, then your average             |
| `typer -t "text"`  | Type your own text (practice a phrase, a command...) |
| `typer best`       | Top 10 rounds by WPM                                |
| `typer stats`      | Today vs. all-time (rounds, avg, best, accuracy) + sparkline |
| `typer log`        | Last 20 rounds                                      |
| `typer -h`         | Help                                                |

**Keys:** just type · **Backspace** fixes mistakes · **Esc** or **Ctrl+C** quits.
The timer starts on your **first keypress**, not when the sentence appears, and the round ends
when you've typed the last character. There's no need to press Enter.

## Example

```
$ typer
  start typing when ready…
  A terminal a day keeps the mouse away.          ← typed chars turn green / red as you go

  97.2 wpm · 97% accuracy · 4.6s · ⚡ blazing
  🎉 new best! (was 58.6)

$ typer stats
today     4 rounds · avg 92.4 wpm · best 116.7 · 97% acc
all time  4 rounds · avg 92.4 wpm · best 116.7 · 97% acc
last 20   ▁█▅▅  (58.6 → 97.2 wpm)
```

Ratings: 🐢 < 30 · 🙂 30+ · 👍 50+ · 🔥 70+ · ⚡ 90+ wpm

## How scoring works
- **WPM** = (correctly placed characters ÷ 5) per minute, the standard "5 characters = 1 word".
  Characters still wrong at the end don't count.
- **Accuracy** = keystrokes that were right when typed ÷ all keystrokes.
  A mistake you fix with Backspace still counts against accuracy, but not against WPM.
- A wrong **space** shows as a red `·` so you can see it.
- Log format (TSV): `date time · wpm · accuracy% · seconds · sentence length`.

## Notes / gotchas
- **Sentences:** `fortune -s`, flattened to one line, 25–90 characters (and less than the terminal width), **plain ASCII only**
  so there are no curly quotes you can't type. After 6 failed tries it uses the built-in `SENTENCES` list. Add your own there.
- **One line only:** the live coloring repaints a single line (`\r` + `ESC[K`), so sentences must fit the terminal width.
  `MAXLEN=90` at the top caps the length.
- **Terminal mode:** while you play it sets `stty -echo -icanon` and hides the cursor. It always restores both,
  including on Esc and Ctrl+C. If a crash ever leaves the terminal weird, run `reset`.
- **Timing:** it uses bash's `$EPOCHREALTIME` (microseconds, no subprocess), so keystroke handling stays snappy.
- **Testing without a human:** the repo's test approach drives it through a Python `pty` that "types" at a fixed speed.
  At 0.2s per key, a 44-character sentence scores ~58.6 wpm, which matches the formula.
