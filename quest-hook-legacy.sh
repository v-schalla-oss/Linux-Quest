#!/usr/bin/env bash
# quest — terminal watcher/verifier for Linux Command Mastery
# Runs locally on your Mac. Verifies quests by inspecting ~/quest-lab
# and recent shell history. No Cursor canvas access required.

set -euo pipefail

QUEST_HOME="${QUEST_HOME:-$HOME/.quest-mastery}"
LAB="${QUEST_LAB:-$HOME/quest-lab}"
PROGRESS="$QUEST_HOME/progress.json"
HIST_SNIP="$QUEST_HOME/recent-history.txt"
SESSION_LOG="$QUEST_HOME/session.log"

# Avoid macOS sed "illegal byte sequence" on zsh history
export LC_ALL=C
export LANG=C

mkdir -p "$QUEST_HOME" "$LAB"
touch "$SESSION_LOG"

# Progress format: {"quest":"s1","done":["s1"],"boss":[]}
init_progress() {
  if [[ ! -f "$PROGRESS" ]]; then
    printf '%s\n' '{"quest":"s1","done":[],"boss":[]}' > "$PROGRESS"
  fi
}

json_get() {
  # tiny jq-free helpers
  python3 - "$PROGRESS" "$1" <<'PY'
import json,sys
p=json.load(open(sys.argv[1]))
key=sys.argv[2]
v=p.get(key)
if isinstance(v,list):
    print(",".join(v))
else:
    print(v if v is not None else "")
PY
}

json_set_quest() {
  python3 - "$PROGRESS" "$1" <<'PY'
import json,sys
path,q=sys.argv[1],sys.argv[2]
p=json.load(open(path))
p["quest"]=q
json.dump(p, open(path,"w"))
PY
}

json_mark_done() {
  python3 - "$PROGRESS" "$1" <<'PY'
import json,sys
path,qid=sys.argv[1],sys.argv[2]
p=json.load(open(path))
if qid not in p["done"]:
    p["done"].append(qid)
json.dump(p, open(path,"w"))
print("ok")
PY
}

json_mark_boss() {
  python3 - "$PROGRESS" "$1" <<'PY'
import json,sys
path,zid=sys.argv[1],sys.argv[2]
p=json.load(open(path))
if zid not in p["boss"]:
    p["boss"].append(zid)
json.dump(p, open(path,"w"))
PY
}

# Capture recent history for command-based checks.
# Notes for macOS zsh:
# 1) History often is NOT flushed until `fc -W` or shell exit
# 2) sed can crash on binary bytes → we parse with python instead
refresh_history() {
  python3 - "$HOME" "$HIST_SNIP" "$SESSION_LOG" <<'PY'
import os, re, sys
home, out, session = sys.argv[1], sys.argv[2], sys.argv[3]
lines = []

# Live session log written by quest hook / quest log
if os.path.isfile(session):
    try:
        with open(session, "r", errors="ignore") as f:
            lines.extend(f.read().splitlines()[-300:])
    except OSError:
        pass

zsh = os.path.join(home, ".zsh_history")
bash = os.path.join(home, ".bash_history")
src = zsh if os.path.isfile(zsh) else (bash if os.path.isfile(bash) else None)
if src:
    try:
        with open(src, "rb") as f:
            data = f.read()
        text = data.decode("utf-8", errors="ignore")
        for raw in text.splitlines()[-300:]:
            # zsh extended: ": 1699999999:0;command"
            m = re.match(r"^:\s*\d+:\d+;(.*)$", raw)
            lines.append(m.group(1) if m else raw)
    except OSError:
        pass

with open(out, "w", errors="ignore") as f:
    f.write("\n".join(lines[-400:]) + ("\n" if lines else ""))
PY
}

hist_has() {
  refresh_history
  grep -Eiq -- "$1" "$HIST_SNIP" 2>/dev/null || grep -Eiq -- "$1" "$SESSION_LOG" 2>/dev/null
}

# Record a command into session log (used by hook + manual)
cmd_log() {
  printf '%s\n' "$*" >> "$SESSION_LOG"
}

# ---- quest definitions ----
# order matters
QUEST_ORDER=(s1 s2 s3 s4 boss1 w1 w2 w3 w4 boss2 t1 t2 t3 t4 boss3 h1 h2 h3 h4 boss4 e1 e2 e3 boss5 k1 k2 k3 k4 boss6)

quest_title() {
  case "$1" in
    s1) echo "Identity Check (whoami/pwd/clear)" ;;
    s2) echo "Manual Access (man)" ;;
    s3) echo "First Trail (ls/cd/pwd)" ;;
    s4) echo "Sight Upgrade (ls -la)" ;;
    boss1) echo "Zone 1 Boss" ;;
    w1) echo "Raise Walls (mkdir -p)" ;;
    w2) echo "Touch Craft (touch)" ;;
    w3) echo "Relocate & Clone (mv/cp)" ;;
    w4) echo "Clean Cut (rm)" ;;
    boss2) echo "Zone 2 Boss" ;;
    t1) echo "Peek Ends (head/tail/less)" ;;
    t2) echo "Redirect Forge (> >>)" ;;
    t3) echo "Pipeworks (sort|uniq)" ;;
    t4) echo "Expansion Magic ({})" ;;
    boss3) echo "Zone 3 Boss" ;;
    h1) echo "File Bloodhound (find)" ;;
    h2) echo "Text Bloodhound (grep)" ;;
    h3) echo "Diff Mirror (diff)" ;;
    h4) echo "Disk & History (du/df/history)" ;;
    boss4) echo "Zone 4 Boss" ;;
    e1) echo "Process Census (ps/top)" ;;
    e2) echo "Soft Then Hard (kill)" ;;
    e3) echo "Jobs bg/fg" ;;
    boss5) echo "Zone 5 Boss" ;;
    k1) echo "Bundle & Crush (tar/gzip)" ;;
    k2) echo "Terminal Quill (nano)" ;;
    k3) echo "Shortcuts (alias/xargs)" ;;
    k4) echo "Keys to the Keep (chmod/ln)" ;;
    boss6) echo "Zone 6 Boss / Command Master" ;;
    *) echo "Unknown" ;;
  esac
}

quest_hint() {
  case "$1" in
    s1) cat <<EOF
Setup: any directory
Challenge:
  whoami
  pwd
  # Ctrl+L or clear
EOF
      ;;
    s2) cat <<EOF
Challenge:
  man ls
  # press q to quit
  man man
EOF
      ;;
    s3) cat <<EOF
Challenge:
  cd ~/quest-lab
  mkdir -p shore/alpha
  cd shore/alpha && pwd
  cd ../..
EOF
      ;;
    s4) cat <<EOF
Challenge:
  cd ~/quest-lab
  ls
  ls -a
  ls -la
EOF
      ;;
    boss1) cat <<EOF
Boss:
  cd ~/quest-lab
  ls -la
  whoami
  pwd
EOF
      ;;
    w1) echo "cd ~/quest-lab && mkdir -p workshop/a/b/c" ;;
    w2) echo "cd ~/quest-lab/workshop && touch notes.txt draft.md scratch.log" ;;
    w3) echo "Use mv to rename/move and cp -r to copy a folder under ~/quest-lab/workshop" ;;
    w4) echo "Practice rmdir on empty dirs and rm -ri on a disposable folder under lab" ;;
    boss2) echo "mkdir -p greenhouse/{summer,winter}/seeds, touch crops, mv, rm -r summer" ;;
    t2) echo "echo hi > log.txt; echo more >> log.txt; cat log.txt  (in ~/quest-lab)" ;;
    t4) echo "cd ~/quest-lab && touch day{1..7}.txt && ls day*.txt" ;;
    h1) echo "find ~/quest-lab -name '*.txt'" ;;
    h2) echo "grep -ri green ~/quest-lab" ;;
    k1) echo "tar -czf docs.tgz some-dir && tar -tzf docs.tgz" ;;
    k4) echo "chmod u+x script.sh && ls -l script.sh" ;;
    *) echo "Run the challenge for: $(quest_title "$1")" ;;
  esac
}

# Return 0 if quest verified
verify_quest() {
  local q="$1"
  case "$q" in
    s1)
      hist_has 'whoami' && hist_has 'pwd'
      ;;
    s2)
      hist_has 'man[[:space:]]+ls' || hist_has 'man ls'
      ;;
    s3)
      [[ -d "$LAB/shore/alpha" ]] || hist_has 'shore/alpha'
      ;;
    s4)
      hist_has 'ls[[:space:]]+-la' || hist_has 'ls -la' || hist_has 'ls -al'
      ;;
    boss1)
      hist_has 'ls[[:space:]]+-la' && hist_has 'whoami' && [[ -d "$LAB" ]]
      ;;
    w1)
      [[ -d "$LAB/workshop/a/b/c" ]]
      ;;
    w2)
      [[ -f "$LAB/workshop/notes.txt" && -f "$LAB/workshop/draft.md" && -f "$LAB/workshop/scratch.log" ]] \
        || [[ -f "$LAB/workshop/notes.txt" ]]
      ;;
    w3)
      hist_has '\bmv\b' && hist_has '\bcp\b'
      ;;
    w4)
      hist_has '\brm\b' || hist_has 'rmdir'
      ;;
    boss2)
      [[ -d "$LAB/greenhouse/winter" ]] || hist_has 'greenhouse'
      ;;
    t1)
      hist_has '\bhead\b' && hist_has '\btail\b'
      ;;
    t2)
      [[ -f "$LAB/log.txt" ]] || hist_has '>>'
      ;;
    t3)
      hist_has 'uniq' && hist_has 'sort'
      ;;
    t4)
      compgen -G "$LAB/day*.txt" > /dev/null || hist_has 'day\{1\.\.7\}'
      ;;
    boss3)
      hist_has 'uniq' || [[ -f "$LAB/ranked.txt" ]]
      ;;
    h1)
      hist_has '\bfind\b'
      ;;
    h2)
      hist_has '\bgrep\b'
      ;;
    h3)
      hist_has '\bdiff\b'
      ;;
    h4)
      hist_has '\bdu\b' || hist_has '\bhistory\b'
      ;;
    boss4)
      hist_has '\bfind\b' && hist_has '\bgrep\b'
      ;;
    e1)
      hist_has '\bps\b' || hist_has '\btop\b'
      ;;
    e2)
      hist_has '\bkill\b'
      ;;
    e3)
      hist_has '\bjobs\b' || hist_has 'sleep .*&'
      ;;
    boss5)
      hist_has '\bjobs\b' && hist_has '\bkill\b'
      ;;
    k1)
      hist_has '\btar\b' || compgen -G "$LAB/*.tgz" > /dev/null || compgen -G "$LAB/*.tar.gz" > /dev/null
      ;;
    k2)
      hist_has '\bnano\b' || [[ -f "$LAB/keep/readme.txt" ]]
      ;;
    k3)
      hist_has '\balias\b' || hist_has 'xargs'
      ;;
    k4)
      hist_has 'chmod' || hist_has 'ln -s'
      ;;
    boss6)
      hist_has '\btar\b' && hist_has 'chmod'
      ;;
    *)
      return 1
      ;;
  esac
}

next_after() {
  local cur="$1" i
  for i in "${!QUEST_ORDER[@]}"; do
    if [[ "${QUEST_ORDER[$i]}" == "$cur" ]]; then
      local j=$((i + 1))
      if (( j < ${#QUEST_ORDER[@]} )); then
        echo "${QUEST_ORDER[$j]}"
      else
        echo "DONE"
      fi
      return
    fi
  done
  echo "s1"
}

cmd_status() {
  init_progress
  local cur done_list boss_list
  cur="$(json_get quest)"
  done_list="$(json_get done)"
  boss_list="$(json_get boss)"
  echo "Lab:      $LAB"
  echo "Progress: $PROGRESS"
  echo "Current:  $cur — $(quest_title "$cur")"
  echo "Done:     ${done_list:-"(none)"}"
  echo "Bosses:   ${boss_list:-"(none)"}"
  echo
  echo "Hint:"
  quest_hint "$cur"
  echo
  echo "Run:  quest check"
}

cmd_check() {
  init_progress
  local cur next
  cur="$(json_get quest)"
  echo "Checking: $cur — $(quest_title "$cur")"

  # Help interactive zsh flush this session into ~/.zsh_history when possible.
  # (No-op if not in zsh or fc unavailable.)
  if command -v fc >/dev/null 2>&1; then
    fc -W 2>/dev/null || true
  fi

  if verify_quest "$cur"; then
    json_mark_done "$cur" >/dev/null
    if [[ "$cur" == boss* ]]; then
      case "$cur" in
        boss1) json_mark_boss shore ;;
        boss2) json_mark_boss workshop ;;
        boss3) json_mark_boss stream ;;
        boss4) json_mark_boss hunt ;;
        boss5) json_mark_boss engine ;;
        boss6) json_mark_boss keep ;;
      esac
    fi
    next="$(next_after "$cur")"
    if [[ "$next" == "DONE" ]]; then
      echo "CLEARED. Command Master achieved."
      json_set_quest "DONE"
    else
      json_set_quest "$next"
      echo "CLEARED → next: $next — $(quest_title "$next")"
      echo
      quest_hint "$next"
    fi
  else
    echo "NOT YET — evidence not found in $LAB or recent history."
    echo
    quest_hint "$cur"
    echo
    echo "Tips:"
    echo "  1) Run the challenge commands"
    echo "  2) Flush history:  fc -W"
    echo "  3) Or log them:    quest log whoami"
    echo "                     quest log pwd"
    echo "  4) Then:           quest check"
    return 1
  fi
}

cmd_hook_install() {
  local marker="# quest-mastery-hook"
  if [[ -n "${ZSH_VERSION:-}" ]] || [[ "$(basename "$SHELL")" == "zsh" ]]; then
    if ! grep -q "$marker" "$HOME/.zshrc" 2>/dev/null; then
      cat >> "$HOME/.zshrc" <<'EOF'

# quest-mastery-hook
setopt INC_APPEND_HISTORY
quest_preexec_log() {
  print -r -- "$1" >> "$HOME/.quest-mastery/session.log" 2>/dev/null || true
}
quest_auto_check() {
  command -v quest >/dev/null 2>&1 || return 0
  case "$PWD" in
    "$HOME/quest-lab"|"$HOME/quest-lab"/*)
      quest check >/tmp/quest-last-check.txt 2>&1 || true
      if grep -q "^CLEARED" /tmp/quest-last-check.txt 2>/dev/null; then
        echo
        cat /tmp/quest-last-check.txt
      fi
      ;;
  esac
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec quest_preexec_log
add-zsh-hook precmd quest_auto_check
EOF
      echo "Installed zsh hook into ~/.zshrc"
      echo "Run: source ~/.zshrc"
    else
      echo "Hook already installed in ~/.zshrc"
    fi
  else
    if ! grep -q "$marker" "$HOME/.bashrc" 2>/dev/null; then
      cat >> "$HOME/.bashrc" <<'EOF'

# quest-mastery-hook
quest_auto_check() {
  command -v quest >/dev/null 2>&1 || return 0
  history 1 2>/dev/null | sed 's/^ *[0-9]* *//' >> "$HOME/.quest-mastery/session.log"
  case "$PWD" in
    "$HOME/quest-lab"|"$HOME/quest-lab"/*)
      quest check >/tmp/quest-last-check.txt 2>&1 || true
      if grep -q "^CLEARED" /tmp/quest-last-check.txt 2>/dev/null; then
        echo
        cat /tmp/quest-last-check.txt
      fi
      ;;
  esac
}
PROMPT_COMMAND="quest_auto_check${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
EOF
      echo "Installed bash hook into ~/.bashrc"
      echo "Run: source ~/.bashrc"
    else
      echo "Hook already installed in ~/.bashrc"
    fi
  fi
  echo "Watch mode: inside ~/quest-lab, each prompt auto-runs quest check."
  echo "Commands are also logged to ~/.quest-mastery/session.log"
}

cmd_hook_remove() {
  echo "Open ~/.zshrc (or ~/.bashrc) and delete the block marked: # quest-mastery-hook"
}

cmd_reset() {
  rm -f "$PROGRESS"
  init_progress
  echo "Progress reset."
  if [[ "${1:-}" == "--lab" ]]; then
    rm -rf "$LAB"
    mkdir -p "$LAB"
    echo "Lab reset: $LAB"
  fi
}

usage() {
  cat <<EOF
quest — watch/verify Linux Command Mastery from your real terminal

Usage:
  quest              status + current quest
  quest hint         show current challenge
  quest check        verify current quest from lab/history (advances if ok)
  quest log <cmd>    manually record a command as evidence
  quest hook install auto-check after each command inside ~/quest-lab
  quest hook remove  how to uninstall hook
  quest reset        reset progress
  quest reset --lab  reset progress + wipe ~/quest-lab

Evidence sources:
  1) Files/folders under ~/quest-lab
  2) ~/.zsh_history (run fc -W first on Mac zsh)
  3) ~/.quest-mastery/session.log
EOF
}

main() {
  init_progress
  case "${1:-}" in
    ""|status) cmd_status ;;
    hint) init_progress; quest_hint "$(json_get quest)" ;;
    check) cmd_check ;;
    log) shift; cmd_log "$*" ; echo "Logged: $*" ;;
    hook)
      case "${2:-}" in
        install) cmd_hook_install ;;
        remove) cmd_hook_remove ;;
        *) usage; exit 1 ;;
      esac
      ;;
    reset) cmd_reset "${2:-}" ;;
    -h|--help|help) usage ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
