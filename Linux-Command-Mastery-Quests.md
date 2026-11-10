# Linux Command Mastery

A practical quest path built from the Colt Steele command course.  
Run every challenge in your **real terminal**. Mark quests done as you clear them.

**Lab home (create once):**

```bash
mkdir -p ~/quest-lab && cd ~/quest-lab
```

**Reset lab anytime:**

```bash
rm -rf ~/quest-lab && mkdir ~/quest-lab
```

---

## How to play

1. Unlock zones in order.
2. For each quest: run **Setup** → complete **Challenge** → pass **Prove**.
3. Finish the **Zone Boss** before the next zone opens.
4. Prefer reading `man` pages when stuck.
5. Daily run: 25–40 minutes. Clear one quest slowly, then repeat it once from memory.

### Rank thresholds

| Rank | XP needed |
|---|---|
| Novice | 0+ |
| Apprentice | 70+ |
| Operator | 160+ |
| Syswalker | 280+ |
| Rootwalker | 390+ |
| Command Master | 520+ |

Progress tracker: Quests `0/23` · Bosses `0/6` · XP `0` · Rank **Novice**

---

## Zone 1 · The Shore
Learn where you are, how to ask for help, and how to move.  
**Unlocks:** Novice

### Quest: Identity Check · +10 XP
**Commands:** `whoami` · `pwd` · `clear`

1. **Setup:** Open a terminal (bash / zsh / WSL Ubuntu).
2. **Challenge:** Print your user, print your location, then clear the screen with `Ctrl+L`.
3. **Prove:** Explain `whoami` vs `pwd` in one sentence each.

```bash
whoami
pwd
# then press Ctrl+L  (or type: clear)
```

- [ ] Cleared

### Quest: Manual Access · +15 XP
**Commands:** `man`

1. **Setup:** Stay in any directory.
2. **Challenge:** Open `man ls`, scroll with space, exit with `q`. Then run `man man`.
3. **Prove:** You can exit a man page without force-closing the terminal.

```bash
man ls
# space = page down, q = quit
man man
```

- [ ] Cleared

### Quest: First Trail · +25 XP
**Commands:** `ls` · `cd` · `pwd`

1. **Setup:**
   ```bash
   mkdir -p ~/quest-lab && cd ~/quest-lab
   ```
2. **Challenge:** Create nested path `shore/alpha`, cd into it, `pwd`, then return with `cd ../..`
3. **Prove:** You used both a relative path and `~` or an absolute path at least once.

```bash
mkdir -p shore/alpha
cd shore/alpha
pwd
cd ../..
pwd
```

- [ ] Cleared

### Quest: Sight Upgrade · +20 XP
**Commands:** `ls -l` · `ls -a` · `ls -la`

1. **Setup:** `cd ~/quest-lab`
2. **Challenge:** Compare `ls`, `ls -a`, and `ls -la`. Spot at least one dotfile.
3. **Prove:** You know what `-a` and `-l` each add.

```bash
ls
ls -a
ls -la
```

- [ ] Cleared

### Zone 1 Boss · +40 XP
From anywhere, land in `~/quest-lab`, list hidden files in long form, clear the screen, then prove your identity.

```bash
cd ~/quest-lab
ls -la
clear   # or Ctrl+L
whoami
pwd
```

- [ ] Boss cleared

---

## Zone 2 · The Workshop
Create, rename, move, copy, and destroy files without a GUI.  
**Unlocks:** Apprentice · Requires Zone 1 boss

### Quest: Raise Walls · +20 XP
**Commands:** `mkdir` · `mkdir -p`

```bash
cd ~/quest-lab
mkdir workshop
mkdir -p workshop/a/b/c
```

**Prove:** Explain why `mkdir a/b/c` fails without `-p`.  
- [ ] Cleared

### Quest: Touch Craft · +15 XP
**Commands:** `touch`

```bash
cd ~/quest-lab/workshop
touch notes.txt draft.md scratch.log
ls
```

**Prove:** Touching an existing file updates its timestamp.  
- [ ] Cleared

### Quest: Relocate & Clone · +25 XP
**Commands:** `mv` · `cp` · `cp -r`

```bash
mv notes.txt journal.txt
mkdir stash
mv journal.txt stash/
cp -r stash stash-copy
ls -R
```

**Prove:** Say when `mv` renames vs moves.  
- [ ] Cleared

### Quest: Clean Cut · +30 XP
**Commands:** `rmdir` · `rm` · `rm -r` · `rm -i`

```bash
mkdir empty-box
rmdir empty-box
rm scratch.log
# careful: recursive delete with prompts
rm -ri stash-copy
```

**Prove:** There is no trash can for `rm`.  
- [ ] Cleared

### Zone 2 Boss · +40 XP
Build `greenhouse/{summer,winter}/seeds`, create 4 empty crop files, rename one, move two into winter, recursively delete summer.

```bash
cd ~/quest-lab
mkdir -p greenhouse/{summer,winter}/seeds
cd greenhouse/summer/seeds
touch tomato.txt basil.txt corn.txt mint.txt
mv mint.txt peppermint.txt
mv tomato.txt basil.txt ../../winter/seeds/
cd ~/quest-lab
rm -r greenhouse/summer
ls -R greenhouse
```

- [ ] Boss cleared

---

## Zone 3 · The Stream
Read, write, redirect, pipe, and expand — the Unix way.  
**Unlocks:** Operator · Requires Zone 2 boss

### Quest: Peek Ends · +20 XP
**Commands:** `head` · `tail` · `less`

```bash
cd ~/quest-lab
seq 1 50 > numbers.txt
head -n 5 numbers.txt
tail -n 8 numbers.txt
less numbers.txt
# G = end, g = start, /word = search, q = quit
```

- [ ] Cleared

### Quest: Redirect Forge · +25 XP
**Commands:** `echo` · `>` · `>>` · `cat`

```bash
echo "day 1" > log.txt
echo "day 2" >> log.txt
echo "day 3" >> log.txt
cat log.txt
```

**Prove:** Explain overwrite `>` vs append `>>`.  
- [ ] Cleared

### Quest: Pipeworks · +35 XP
**Commands:** `|` · `wc` · `sort` · `uniq`

```bash
printf "vanilla\nchocolate\nvanilla\nmint\nchocolate\nvanilla\n" > flavors.txt
sort flavors.txt | uniq -c | sort -nr | head
```

**Prove:** Explain why `uniq` usually needs `sort` first.  
- [ ] Cleared

### Quest: Expansion Magic · +30 XP
**Commands:** `*` · `?` · `{}` · `~` · `$USER`

```bash
cd ~/quest-lab
touch day{1..7}.txt
ls *.txt
echo ~
echo $USER
```

**Prove:** Preview expansions with `echo` before using `rm`.  
- [ ] Cleared

### Zone 3 Boss · +40 XP
Build shopping lists, concatenate them, sort unique items, count lines, and save the ranked result with one pipeline.

```bash
cd ~/quest-lab
printf "milk\neggs\nbutter\n" > groceries.txt
printf "nails\nscrewdriver\n" > hardware.txt
printf "eggs\nmilk\nbread\n" > extras.txt
cat groceries.txt hardware.txt extras.txt | sort | uniq -c | sort -nr > ranked.txt
cat ranked.txt
wc -l ranked.txt
```

- [ ] Boss cleared

---

## Zone 4 · The Hunt
Find files, find text, measure disk, and recover old commands.  
**Unlocks:** Syswalker · Requires Zone 3 boss

### Quest: File Bloodhound · +30 XP
**Commands:** `find`

```bash
cd ~/quest-lab
find . -name "*.txt"
find . -type d
```

- [ ] Cleared

### Quest: Text Bloodhound · +30 XP
**Commands:** `grep` · `grep -n` · `grep -ri`

```bash
echo "green leaves" >> story.txt
grep -n green story.txt
grep -ri green ~/quest-lab
```

**Prove:** `find` searches names; `grep` searches contents.  
- [ ] Cleared

### Quest: Diff Mirror · +20 XP
**Commands:** `diff` · `diff -u`

```bash
cp story.txt story2.txt
echo "extra line" >> story2.txt
diff story.txt story2.txt
diff -u story.txt story2.txt
```

- [ ] Cleared

### Quest: Disk & Memory of Commands · +25 XP
**Commands:** `du -h` · `df -h` · `history`

```bash
du -h . | sort -h | tail
df -h
history | grep find
# rerun an old command with: !<number>
```

- [ ] Cleared

### Zone 4 Boss · +40 XP
Find every `*.txt` under `~/quest-lab`, grep a pattern recursively, then recover a prior command from history.

```bash
cd ~/quest-lab
find . -name "*.txt"
grep -ri milk .
history | grep find
```

- [ ] Boss cleared

---

## Zone 5 · The Engine Room
Inspect processes, stop them safely, and park long jobs in the background.  
**Unlocks:** Rootwalker · Requires Zone 4 boss

### Quest: Process Census · +25 XP
**Commands:** `ps` · `ps aux` · `top`

```bash
ps
ps aux | head
top
# press q to quit top
```

**Prove:** Point to the PID column.  
- [ ] Cleared

### Quest: Soft, Then Hard · +30 XP
**Commands:** `kill` · `kill -15` · `kill -9` · `killall`

```bash
sleep 300 &
jobs
ps
# replace <PID> with the sleep process id
kill <PID>          # gentle (SIGTERM / 15)
# if still alive:
kill -9 <PID>       # force
# or:
# killall sleep
```

**Prove:** Prefer `15` before `9`.  
- [ ] Cleared

### Quest: Foreground / Background · +35 XP
**Commands:** `jobs` · `bg` · `fg` · `Ctrl+Z` · `&`

```bash
sleep 120
# Ctrl+Z to suspend
jobs
bg
jobs
fg
# Ctrl+C to stop
sleep 50 &
jobs
```

- [ ] Cleared

### Zone 5 Boss · +40 XP
Start a long sleep in background, confirm with `jobs`/`ps`, bring it foreground, suspend, resume background, then kill it.

```bash
sleep 200 &
jobs
ps
fg
# Ctrl+Z
bg
kill %1
```

- [ ] Boss cleared

---

## Zone 6 · The Keep
Compress, edit fast, automate with aliases/xargs, and control permissions.  
**Unlocks:** Command Master · Requires Zone 5 boss

### Quest: Bundle & Crush · +35 XP
**Commands:** `gzip` · `gunzip` · `tar` · `tar -czf` · `tar -xzf`

```bash
cd ~/quest-lab
mkdir -p keep/docs
echo one > keep/docs/a.txt
echo two > keep/docs/b.txt
echo three > keep/docs/c.txt
tar -czf docs.tgz keep/docs
rm -r keep/docs
tar -xzf docs.tgz
ls -R keep
```

**Prove:** `gzip` compresses one file; `tar` groups many.  
- [ ] Cleared

### Quest: Terminal Quill · +20 XP
**Commands:** `nano`

```bash
mkdir -p ~/quest-lab/keep
nano ~/quest-lab/keep/readme.txt
# write 3 lines, save, exit with Ctrl+X
# search with Ctrl+W
```

- [ ] Cleared

### Quest: Shortcuts & Batches · +30 XP
**Commands:** `alias` · `xargs`

```bash
alias ll='ls -la'
ll
printf "alpha.txt\nbeta.txt\ngamma.txt\n" > names.txt
cat names.txt | xargs touch
ls
```

**Prove:** Session aliases die unless saved in `~/.zshrc` (Mac) or `~/.bashrc` (bash).  
- [ ] Cleared

### Quest: Keys to the Keep · +40 XP
**Commands:** `ln -s` · `chmod` · `whoami`

```bash
cd ~/quest-lab/keep
echo secret > secret.txt
ln -s secret.txt alias.txt
echo 'echo hi' > script.sh
chmod u+x script.sh
./script.sh
ls -l
# decode the rwx rwx rwx permission string
```

**Prove:** Translate `rw-r--r--` into words.  
- [ ] Cleared

### Zone 6 Boss · +40 XP
Archive a folder with tar+gzip, restore it, create a permanent alias, chmod a script executable, and explain the `ls -l` mode string.

```bash
cd ~/quest-lab
tar -czf keep-backup.tgz keep
# permanent alias on Mac zsh:
# nano ~/.zshrc
# add: alias ll='ls -la'
# then: source ~/.zshrc
```

- [ ] Boss cleared

---

## Victory condition

When all **23 quests** and **6 bosses** are cleared (~520+ XP), you are **Command Master**.

Next difficulty:
1. Redo Zone 3–6 bosses with no notes.
2. Solve real tasks on a remote Linux box over SSH.
