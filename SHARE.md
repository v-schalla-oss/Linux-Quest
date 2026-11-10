# Share Linux Quest

Send this whole folder (or a zip of it). Friends install in about two minutes.

## Package it

```bash
cd ~/code
zip -r Linux-Quest.zip Linux-Quest
```

Then send `Linux-Quest.zip` (chat, email, Drive, USB) or push this repo and share the clone URL.

## Friend installs

```bash
unzip Linux-Quest.zip
cd Linux-Quest
chmod +x install.sh
./install.sh
source ~/.bashrc
cd ~/quest-lab
quest login TheirName
quest
```

## Play commands

| Command | What it does |
|---|---|
| `quest login Name` | create/switch player |
| `quest` | show current lesson |
| `quest check` | verify and advance |
| `quest <N>` | jump to unlocked level N (progress kept) |
| `quest levels` | level map |
| `quest who` | progress |
| `quest reset` | restart that player only |

Progress is saved per name under `~/.quest-mastery/users/<name>/`.

## Notes

- Needs bash + python3
- Windows: use WSL or Git Bash
- On a shared machine, each person should use their own login name
