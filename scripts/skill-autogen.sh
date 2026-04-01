#!/bin/bash
# skill-autogen.sh
# Analyzes recent session history and suggests/creates skills for non-trivial solutions
# Usage: bash skill-autogen.sh [suggest|create|list]

SKILLS_DIR="/Users/soup/.openclaw/skills"
MEMORY_DIR="/Users/soup/.openclaw/workspace/memory"
MODE="${1:-suggest}"

# Categories for skills
CATEGORIES="coding|devops|research|discord|cloudflare|github|railway|search|memory|workflow"

suggest_skills() {
  echo "=== Skill Generation Suggestions ==="
  echo ""
  echo "Analyzing recent memory for patterns that could become reusable skills..."
  echo ""
  
  # Look for patterns in recent memory files
  for f in "$MEMORY_DIR"/2026-03-*.md; do
    if [ -f "$f" ]; then
      echo "--- $(basename "$f") ---"
      # Extract lines that look like problem-solving or non-trivial completions
      grep -E "(solved|fixed|built|implemented|created|deployed|resolved)" "$f" 2>/dev/null | head -5
      echo ""
    fi
  done
}

create_skill() {
  local name="$2"
  local trigger="$3"
  local content="$4"
  
  if [ -z "$name" ] || [ -z "$trigger" ] || [ -z "$content" ]; then
    echo "Usage: $0 create \"skill-name\" \"trigger phrase\" \"description\""
    exit 1
  fi
  
  # Convert name to kebab-case for directory
  dir=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  skill_path="$SKILLS_DIR/$dir"
  
  if [ -d "$skill_path" ]; then
    echo "Skill '$name' already exists at $skill_path"
    exit 1
  fi
  
  mkdir -p "$skill_path"
  
  cat > "$skill_path/SKILL.md" << EOF
# $name

## Trigger
"$trigger"

## Description
$content

## Implementation
_TODO: fill in implementation details_

## Triggers
- $trigger
- TODO: add more trigger phrases

## Status
auto-generated: $(date)
EOF

  echo "Created skill: $skill_path/SKILL.md"
}

list_skills() {
  echo "=== Existing Skills ==="
  for d in "$SKILLS_DIR"/*/; do
    if [ -d "$d" ] && [ -f "$d/SKILL.md" ]; then
      name=$(basename "$d")
      trigger=$(grep -m1 "Trigger" "$d/SKILL.md" 2>/dev/null | cut -d'"' -f2 || echo "no trigger")
      status=$(grep "status" "$d/SKILL.md" 2>/dev/null | head -1 || echo "")
      echo "  $name — $trigger $status"
    fi
  done
}

case "$MODE" in
  suggest) suggest_skills ;;
  create) create_skill "$@" ;;
  list) list_skills ;;
  *) echo "Usage: $0 {suggest|create \"name\" \"trigger\" \"desc\"|list}" ;;
esac
