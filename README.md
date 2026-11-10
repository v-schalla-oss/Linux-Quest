# Linux Quest

A terminal game that teaches Linux commands through **29 story levels**.
Each player gets a name, saved progress, and their own lab folder.

## Quick start

```bash
chmod +x install.sh
./install.sh
source ~/.bashrc
cd ~/quest-lab
quest login YourName
quest
```

## Play

| Command | What it does |
|---|---|
| `quest login Name` | create/switch player |
| `quest` | show current lesson (story + goal) |
| `quest check` | verify skills and unlock the next level |
| `quest <N>` | jump to unlocked level N (keeps progress) |
| `quest levels` | numbered level map |
| `quest who` | who is logged in + progress |
| `quest users` | all players on this machine |
| `quest reset` | restart only the current player |
| `quest log <cmd>` | manually log evidence if tracking missed it |
| `quest help` | full help |

Progress is stored per player in `~/.quest-mastery/users/<name>/`.
Lab files live in `~/quest-lab/<name>/`.

## Share with friends

See [SHARE.md](./SHARE.md). Zip this folder and send it, or share the git repo.

## Files

| File | Purpose |
|---|---|
| `quest` | main game script |
| `install.sh` | installs `quest` into `~/bin` + shell logger |
| `SHARE.md` | how to share / install elsewhere |
| `Linux-Command-Mastery-Quests.md` | markdown playbook companion |
| `quest-hook-legacy.sh` | older hook-based experiment (optional) |

## Requirements

- bash terminal (macOS, Linux, WSL, or cloud shell)
- `python3` (used for progress + evidence parsing)
