# tidy — sort Downloads into type folders (safely)

Moves the loose files in a folder (default `~/Downloads`) into `Images/`, `Documents/`, `Archives/`...
by extension. It's **safe by design**:

1. Plain `tidy` is a **dry run** that only shows the plan.
2. `tidy go` moves files and **logs every move**.
3. `tidy undo` puts them all back.

It never deletes anything.

- **Source:** `tidy/tidy`
- **Installed as:** `~/bin/tidy` (symlink via `./install.sh`)
- **Move logs:** `~/.local/share/tidy/moves-<date>-<time>-<pid>.tsv` (renamed `*.undone.tsv` after an undo)

## Quick reference

| Command                  | What it does                                                   |
|--------------------------|----------------------------------------------------------------|
| `tidy`                   | Dry run for `~/Downloads`: counts and sizes per folder, nothing moves |
| `tidy ~/Desktop`         | Dry run for any folder                                         |
| `tidy -v`                | Dry run listing every file under its target folder             |
| `tidy go [dir]`          | Do it: move files, log each move                               |
| `tidy undo`              | Reverse the most recent `go` (run it again for the one before)  |
| `tidy history`           | Past runs, with `(undone)` marks                               |
| `tidy old [days] [dir]`  | Biggest files not modified in N days (default 90); **list only** |
| `tidy -h`                | Help                                                           |

## Categories

| Folder        | Extensions |
|---------------|------------|
| `Images/`     | jpg jpeg png gif webp svg bmp tif tiff heic ico avif |
| `Videos/`     | mp4 mkv webm mov avi m4v |
| `Audio/`      | mp3 wav flac ogg m4a opus aac |
| `Documents/`  | pdf doc docx odt rtf txt md epub |
| `Slides/`     | ppt pptx odp key |
| `Sheets/`     | xls xlsx ods csv |
| `Diagrams/`   | drawio puml dia vsdx |
| `Archives/`   | zip gz tgz bz2 xz 7z rar tar zst |
| `Installers/` | rpm deb iso appimage flatpakref exe msi run |
| `Code/`       | sh py c cpp h js ts json html css java go rs ipynb yml yaml |
| `Fonts/`      | ttf otf woff woff2 |

Matching ignores case (`IMG.JPG` → `Images/`). To add a type, edit the `CATS` table at the top of the script
(and `ORDER`, for a new folder).

**Always left alone:** subfolders, hidden files (`.env`, `.config`...), unfinished downloads
(`.part .crdownload .tmp .download`), files with no extension, and unknown types. The plan lists these.

## Example

```
$ tidy
tidy plan for /home/inba/Downloads (dry run — nothing moved)

  Images/       47 files      30MB
  Videos/        2 files     155MB
  Documents/    59 files      27MB
  Slides/       16 files      79MB
  Sheets/        5 files     617KB
  Diagrams/      4 files      96KB
  Archives/     14 files     1.7GB
  Installers/    2 files     3.9GB
  Code/          2 files     9.8KB
  total        151 files     5.8GB

  left alone (unknown type): atlas-credentials.env, flag, LICENSE, metalink.metalink
  left alone (hidden / unfinished): 13 files

  run tidy go to move them · tidy undo reverses it

$ tidy go          # moves them, prints the same table, "moved 151 files."
$ tidy undo        # "restored 151 files."
```

## Notes / gotchas
- **Name clashes:** if `Images/photo.jpg` already exists, the new one becomes `Images/photo (1).jpg`. Nothing is overwritten
  (`mv -n` too).
- **Undo is careful:** it only moves a file back if it's still where tidy put it **and** the original name is free.
  Anything else is skipped and reported, with where the file is now.
  It also removes category folders that end up empty.
- **Each move is logged as it happens,** so if a run is interrupted, `tidy undo` still reverses what got moved.
- **Only the top level** of the folder is sorted. Files inside existing subfolders are never touched.
- **Tested** on a fake Downloads folder (spaces, uppercase extensions, a clash, `.part`, hidden files, no extension,
  an existing subfolder): `go` → second `go` with a clash → `undo` → `undo` left it byte-for-byte identical (md5).
- **Bash gotcha found while building:** `exit` inside `"$(...)"` only exits the subshell, so the folder is checked
  into a variable first (`DIR=$(dir_arg ...)`). That way a bad path stops the script.
