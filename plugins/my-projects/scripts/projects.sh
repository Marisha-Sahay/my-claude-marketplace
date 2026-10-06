#!/usr/bin/env bash
# Discover and describe Marisha's local projects.
#
# Usage:
#   projects.sh list            Table of all projects (name, branch, state, description)
#   projects.sh brief           Compact index (used by the SessionStart hook)
#   projects.sh path <name>     Absolute path of a project (fuzzy match)
#   projects.sh show <name>     Full context: path, git state, recent commits, stack, README
#
# Roots to scan: $MY_PROJECTS_ROOT (colon-separated), default ~/dev/github.
# Descriptions: scripts/descriptions.txt ("name|description"), falling back to README title.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESCRIPTIONS="$SCRIPT_DIR/descriptions.txt"
ROOTS="${MY_PROJECTS_ROOT:-$HOME/dev/github}"

all_projects() {
  local IFS=:
  for root in $ROOTS; do
    [ -d "$root" ] || continue
    for dir in "$root"/*/; do
      [ -d "$dir" ] || continue
      dir="${dir%/}"
      case "$(basename "$dir")" in .*) continue ;; esac
      printf '%s\n' "$dir"
    done
  done
}

describe() {
  local dir="$1" name desc readme
  name="$(basename "$dir")"
  if [ -f "$DESCRIPTIONS" ]; then
    desc="$(grep -i "^${name}|" "$DESCRIPTIONS" | head -1 | cut -d'|' -f2-)"
    [ -n "$desc" ] && { printf '%s' "$desc"; return; }
  fi
  for readme in "$dir/README.md" "$dir/readme.md" "$dir/README"; do
    if [ -f "$readme" ]; then
      grep -m1 -E '^#+ |^[A-Za-z]' "$readme" | sed -E 's/^#+ *//' | cut -c1-100
      return
    fi
  done
  printf '(no description)'
}

git_branch() { git -C "$1" branch --show-current 2>/dev/null; }

git_state() {
  local dir="$1" n
  git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || { printf 'no-git'; return; }
  n="$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$n" = "0" ]; then printf 'clean'; else printf '%s changed' "$n"; fi
}

find_project() {
  local query="$1" dir name lq matches=""
  lq="$(printf '%s' "$query" | tr '[:upper:]' '[:lower:]')"
  # 1) exact, 2) prefix, 3) substring
  for pass in exact prefix substr; do
    while IFS= read -r dir; do
      name="$(basename "$dir" | tr '[:upper:]' '[:lower:]')"
      case "$pass" in
        exact)  [ "$name" = "$lq" ] && matches="$matches$dir"$'\n' ;;
        prefix) case "$name" in "$lq"*) matches="$matches$dir"$'\n' ;; esac ;;
        substr) case "$name" in *"$lq"*) matches="$matches$dir"$'\n' ;; esac ;;
      esac
    done < <(all_projects)
    [ -n "$matches" ] && break
  done
  matches="${matches%$'\n'}"
  if [ -z "$matches" ]; then
    echo "No project matches '$query'. Run: projects.sh list" >&2
    return 1
  fi
  if [ "$(printf '%s\n' "$matches" | wc -l | tr -d ' ')" -gt 1 ]; then
    echo "'$query' is ambiguous; matches:" >&2
    printf '%s\n' "$matches" | while IFS= read -r d; do echo "  $(basename "$d")" >&2; done
    return 2
  fi
  printf '%s\n' "$matches"
}

detect_stack() {
  local d="$1" s=""
  [ -f "$d/pom.xml" ] && s="$s Maven/Java"
  { [ -f "$d/build.gradle" ] || [ -f "$d/build.gradle.kts" ]; } && s="$s Gradle"
  [ -f "$d/package.json" ] && s="$s Node"
  [ -f "$d/next.config.mjs" ] || [ -f "$d/next.config.js" ] && s="$s Next.js"
  [ -f "$d/vite.config.ts" ] || [ -f "$d/vite.config.js" ] && s="$s Vite"
  { [ -f "$d/requirements.txt" ] || [ -f "$d/pyproject.toml" ]; } && s="$s Python"
  [ -f "$d/CMakeLists.txt" ] && s="$s CMake/C++"
  [ -f "$d/Cargo.toml" ] && s="$s Rust"
  [ -f "$d/go.mod" ] && s="$s Go"
  [ -f "$d/.claude-plugin/marketplace.json" ] && s="$s Claude-plugin-marketplace"
  [ -z "$s" ] && [ -f "$d/index.html" ] && s=" static HTML/JS"
  printf '%s' "${s# }"
}

cmd_list() {
  printf '%-30s %-40s %-12s %s\n' PROJECT BRANCH STATE DESCRIPTION
  all_projects | while IFS= read -r dir; do
    printf '%-30s %-40s %-12s %s\n' "$(basename "$dir")" "$(git_branch "$dir" || true)" \
      "$(git_state "$dir")" "$(describe "$dir")"
  done
}

cmd_brief() {
  echo "Marisha's local projects (root: $ROOTS). Use the my-projects skill or /my-projects:project <name> to work on one."
  all_projects | while IFS= read -r dir; do
    printf -- '- %s (%s): %s\n' "$(basename "$dir")" "$dir" "$(describe "$dir")"
  done
}

cmd_show() {
  local dir
  dir="$(find_project "$1")" || return $?
  echo "# $(basename "$dir")"
  echo "Path:        $dir"
  echo "Description: $(describe "$dir")"
  echo "Stack:       $(detect_stack "$dir")"
  if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
    echo "Remote:      $(git -C "$dir" remote get-url origin 2>/dev/null || echo none)"
    echo "Upstream:    $(git -C "$dir" remote get-url upstream 2>/dev/null || echo none)"
    echo "Branch:      $(git_branch "$dir")"
    echo "State:       $(git_state "$dir")"
    echo
    echo "## Recent commits"
    git -C "$dir" log --oneline -8 2>/dev/null
    echo
    echo "## Uncommitted changes"
    git -C "$dir" status --short 2>/dev/null | head -20
    echo
    echo "## Local branches (most recent first)"
    git -C "$dir" for-each-ref --sort=-committerdate --count=8 \
      --format='%(refname:short)  (%(committerdate:relative))' refs/heads 2>/dev/null
  else
    echo "Git:         not a git repository"
  fi
  echo
  echo "## Top-level files"
  ls -1 "$dir" | head -40
  for f in CLAUDE.md AGENTS.md; do
    if [ -f "$dir/$f" ]; then echo; echo "## $f"; head -60 "$dir/$f"; fi
  done
  for f in README.md readme.md README; do
    if [ -f "$dir/$f" ]; then echo; echo "## README (first 40 lines)"; head -40 "$dir/$f"; break; fi
  done
}

case "${1:-list}" in
  list)  cmd_list ;;
  brief) cmd_brief ;;
  path)  [ $# -ge 2 ] || { echo "usage: $0 path <name>" >&2; exit 1; }; find_project "$2" ;;
  show)  [ $# -ge 2 ] || { echo "usage: $0 show <name>" >&2; exit 1; }; cmd_show "$2" ;;
  *)     echo "usage: $0 {list|brief|path <name>|show <name>}" >&2; exit 1 ;;
esac
