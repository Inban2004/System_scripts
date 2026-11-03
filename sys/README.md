# sys — Fedora system health & maintenance

One command to check on your machine, update it and clean it up.

- **Source:** `sys/sys`
- **Installed as:** `~/bin/sys` (symlink via `./install.sh`; edits apply right away)
- **Log:** `~/.local/share/sys/health.tsv`

## Quick reference

| Command          | What it does                                         | Needs sudo | Changes system |
|------------------|------------------------------------------------------|:----------:|:--------------:|
| `sys`            | Same as `sys health`                                 |            |                |
| `sys health`     | Memory, swap/zram, memory pressure, disk, temp, uptime |          |                |
| `sys mem`        | Top 10 processes by RAM + totals per app             |            |                |
| `sys net`        | Interfaces, gateway, DNS, internet check             |            |                |
| `sys big [path]` | 10 largest folders (default `$HOME`)                 |            |                |
| `sys boot`       | Boot time, slowest services, failed services         |            |                |
| `sys snap`       | Save a one-line memory snapshot to the log           |            |                |
| `sys log`        | Show the last 20 snapshots                           |            |                |
| `sys update`     | dnf + flatpak + firmware updates, then reboot check  | yes        | yes            |
| `sys clean`      | Remove orphans, caches, old journals (asks first)    | yes        | yes            |
| `sys -h`         | Help                                                 |            |                |

## Examples

### `sys health` — "is my laptop OK?"
```
── Memory
Mem:   7.1Gi total   5.3Gi used   1.7Gi available
Swap:  7.1Gi total   2.3Gi used
── Memory pressure
some avg10=0.05 avg60=0.56 avg300=0.41
── Disk
/dev/nvme0n1p2  196G  139G   47G  75% /
── Temperature
Tctl:  +50.9°C
── Uptime
up 49 minutes
```
How to read it:
- **available** is the RAM number that matters, not "free".
- **Memory pressure avg10** under ~10 is fine. If it climbs higher, apps are waiting on memory and things feel laggy.
- **Disk Use%** over ~90% is when to run `sys clean` or `sys big`.

### `sys mem` — "what's eating my RAM?"
```
── Totals by process name
Isolated Web Co   4100 MB     ← all Firefox tabs combined
firefox            694 MB
claude             344 MB
```
`Isolated Web Co` is one Firefox tab or site. Close tabs if this number gets big.

### `sys big` — "where did my disk space go?"
```
sys big                 # scan your home folder
sys big ~/Downloads     # scan one folder
sys big /var            # system folders (some may be unreadable without sudo)
```

### `sys net` — "is the internet broken or is it me?"
Ends with:
```
IPv4 reachable     ← you can reach the internet
DNS resolving      ← website names work
```
If **IPv4 FAILED**, the problem is your Wi-Fi or router. If only **DNS FAILED**, the connection works but name lookups don't; Tailscale's DNS (100.100.100.100) is a common cause.

### `sys boot` — "why is startup slow?"
Shows the total boot time, the 10 slowest services and any failed ones.
Example fix for a failed first-boot wizard:
```
sudo systemctl disable initial-setup.service
```

### `sys snap` + `sys log` — track memory over time
```
sys snap        # logged: used=5375M avail=1887M swap=2365M
sys log         # table of past snapshots
```
Run `sys snap` when the system feels slow, so you can compare later.

### `sys update` — update everything
Runs `dnf upgrade --refresh` → `flatpak update` → firmware check → "reboot needed?".
It asks for your sudo password, and dnf asks before it installs anything.

### `sys clean` — free up space
Shows how much space can be freed and asks **y/N** before it does anything. Then it:
- removes packages nothing needs anymore (`dnf autoremove`)
- clears the dnf cache
- removes unused flatpak runtimes
- deletes journal logs older than 7 days (`JOURNAL_KEEP` at the top of the script)
- clears the thumbnail cache

## Suggested routine
- **Daily / when it feels slow:** `sys`, then `sys mem`
- **Weekly:** `sys update`
- **Monthly:** `sys clean`, then `sys big`
