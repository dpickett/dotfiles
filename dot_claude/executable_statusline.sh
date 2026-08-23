#!/usr/bin/env bash
# Claude Code status line - inspired by Starship Catppuccin Macchiato theme

input=$(cat)

# Extract fields from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Catppuccin Macchiato palette (actual escape characters via $'...' syntax)
RED=$'\033[38;2;237;135;150m'      # red #ed8796
PEACH=$'\033[38;2;245;169;127m'    # peach #f5a97f
YELLOW=$'\033[38;2;238;212;159m'   # yellow #eed49f
GREEN=$'\033[38;2;166;218;149m'    # green #a6da95
SAPPHIRE=$'\033[38;2;125;196;228m' # sapphire #7dc4e4
LAVENDER=$'\033[38;2;183;189;248m' # lavender #b7bdf8
CRUST=$'\033[38;2;24;25;38m'       # crust #181926
RESET=$'\033[0m'

# Git repo name from origin URL and branch/status
repo_info=""
git_branch=""
git_dir="${cwd:-$(pwd)}"
if git -C "$git_dir" rev-parse --git-dir > /dev/null 2>&1; then
  # Extract repo name from origin URL (handles https and ssh)
  origin=$(git -C "$git_dir" remote get-url origin 2>/dev/null)
  if [ -n "$origin" ]; then
    repo_name=$(basename "$origin" .git)
    repo_info="$repo_name"
  fi

  branch=$(git -C "$git_dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$git_dir" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_status_flags=""
    if ! git -C "$git_dir" diff --quiet 2>/dev/null || ! git -C "$git_dir" diff --cached --quiet 2>/dev/null; then
      git_status_flags="*"
    fi
    untracked=$(git -C "$git_dir" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    [ "$untracked" -gt 0 ] && git_status_flags="${git_status_flags}?"
    git_branch="${branch}${git_status_flags}"
  fi
fi

# Context gauge
ctx_gauge=""
if [ -n "$used_pct" ]; then
  used_int=${used_pct%.*}
  used_int=${used_int:-0}
  if [ "$used_int" -ge 80 ]; then
    ctx_color=$RED
  elif [ "$used_int" -ge 50 ]; then
    ctx_color=$YELLOW
  else
    ctx_color=$GREEN
  fi

  # 10-cell gauge using block chars: filled=█, empty=░
  filled=$(( used_int / 10 ))
  empty=$(( 10 - filled ))
  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done
  ctx_gauge="${ctx_color}▐${bar}▌ ${used_int}%${RESET}"
fi

# Delimiter
DIM=$'\033[38;2;91;96;120m'  # surface2 #5b6078
SEP=" ${DIM}|${RESET} "

# Assemble status line
parts=()
[ -n "$repo_info" ] && parts+=("${PEACH}${repo_info}${RESET}")
[ -n "$git_branch" ] && parts+=("${YELLOW}${git_branch}${RESET}")
[ -n "$model" ] && parts+=("${SAPPHIRE}${model}${RESET}")
[ -n "$ctx_gauge" ] && parts+=("${ctx_gauge}")

output=""
for part in "${parts[@]}"; do
  [ -n "$output" ] && output="${output}${SEP}"
  output="${output}${part}"
done
printf "%s\n" "${output}"
