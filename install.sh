#!/usr/bin/env bash
# Install Linux Command Mastery (quest) for the current user.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${SCRIPT_DIR}/quest"

if [[ ! -f "$SRC" ]]; then
  echo "Missing quest next to install.sh"
  exit 1
fi

mkdir -p "$HOME/bin" "$HOME/quest-lab" "$HOME/.quest-mastery"
cp "$SRC" "$HOME/bin/quest"
chmod +x "$HOME/bin/quest"

# Put ~/bin on PATH for future shells
if ! grep -q 'HOME/bin' "$HOME/.bashrc" 2>/dev/null; then
  printf '\nexport PATH="$HOME/bin:$PATH"\n' >> "$HOME/.bashrc"
fi

# Quest command logger (per-player session.log)
if ! grep -q '_quest_log_last_command' "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<'EOF'

# quest-mastery-hook — log typed commands into the current player's session.log
_quest_log_last_command() {
  local cmd logdir logfile slug
  cmd=$(history 1 2>/dev/null | sed 's/^ *[0-9]* *//')
  [[ -n "$cmd" ]] || return 0
  case "$cmd" in
    quest*|\#*) return 0 ;;
  esac
  slug=""
  if [[ -f "$HOME/.quest-mastery/current_user" ]]; then
    slug=$(sed -n '2p' "$HOME/.quest-mastery/current_user" 2>/dev/null)
  fi
  if [[ -n "$slug" ]]; then
    logdir="$HOME/.quest-mastery/users/$slug"
  else
    logdir="$HOME/.quest-mastery"
  fi
  mkdir -p "$logdir"
  logfile="$logdir/session.log"
  if [[ -f "$logfile" ]] && [[ "$(tail -n 1 "$logfile" 2>/dev/null)" == "$cmd" ]]; then
    return 0
  fi
  printf '%s\n' "$cmd" >> "$logfile"
}
PROMPT_COMMAND="_quest_log_last_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
EOF
fi

# Optional system-wide link when allowed
if [[ -w /usr/local/bin ]] 2>/dev/null; then
  ln -sf "$HOME/bin/quest" /usr/local/bin/quest 2>/dev/null || true
elif command -v sudo >/dev/null 2>&1; then
  sudo ln -sf "$HOME/bin/quest" /usr/local/bin/quest 2>/dev/null || true
fi

export PATH="$HOME/bin:$PATH"

echo
echo "Installed: $HOME/bin/quest"
echo
echo "Start playing:"
echo "  source ~/.bashrc"
echo "  cd ~/quest-lab"
echo "  quest login YourName"
echo "  quest"
echo
