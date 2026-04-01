#!/bin/bash
# memory-fts-indexer.sh
# Builds and updates an FTS5 index over all memory/*.md files
# Usage: bash memory-fts-indexer.sh [rebuild|update|search "query"]

MEMORY_DIR="/Users/soup/.openclaw/workspace/memory"
DB="/Users/soup/.openclaw/memory/memory.fts.db"
MODE="${1:-rebuild}"

rebuild() {
  echo "Building FTS5 index over memory files..."
  
  # Create or recreate the FTS5 table
  sqlite3 "$DB" "
    DROP TABLE IF EXISTS memory_fts;
    CREATE VIRTUAL TABLE memory_fts USING fts5(
      filename,
      date,
      content,
      tokenize='porter unicode61'
    );
  "

  # Index all markdown files
  for f in "$MEMORY_DIR"/*.md; do
    if [ -f "$f" ]; then
      filename=$(basename "$f")
      # Extract date from filename if it looks like YYYY-MM-DD
      date=$(echo "$filename" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
      content=$(cat "$f")
      
      sqlite3 "$DB" "
        INSERT INTO memory_fts (filename, date, content)
        VALUES (
          '$(echo "$filename" | sed "s/'/''/g")',
          '$(echo "${date:-unknown}" | sed "s/'/''/g")',
          '$(echo "$content" | sed "s/'/''/g")'
        );
      "
    fi
  done

  # Also index top-level memory files
  for f in "$MEMORY_DIR"/MEMORY.md "$MEMORY_DIR"/../MEMORY.md; do
    if [ -f "$f" ]; then
      filename=$(basename "$f")
      content=$(cat "$f")
      sqlite3 "$DB" "
        INSERT INTO memory_fts (filename, date, content)
        VALUES (
          '$(echo "$filename" | sed "s/'/''/g")',
          'curated',
          '$(echo "$content" | sed "s/'/''/g")'
        );
      "
    fi
  done

  echo "Done. $(sqlite3 "$DB" "SELECT COUNT(*) FROM memory_fts") entries indexed."
  echo "Last updated: $(date)"
}

search() {
  query="${2:-}"
  if [ -z "$query" ]; then
    echo "Usage: $0 search \"query\""
    exit 1
  fi
  
  if [ ! -f "$DB" ]; then
    echo "Index not found. Run '$0 rebuild' first."
    exit 1
  fi
  
  results=$(sqlite3 -json "$DB" "
    SELECT filename, date, snippet(memory_fts, 2, '**', '**', '...', 30) as snippet
    FROM memory_fts
    WHERE memory_fts MATCH '$(echo "$query" | sed "s/'/''/g")'
    ORDER BY rank
    LIMIT 10
  " 2>&1)
  
  if [ -z "$results" ] || [ "$results" = "[]" ]; then
    echo "No results for: $query"
  else
    echo "$results" | python3 -m json.tool 2>/dev/null || echo "$results"
  fi
}

case "$MODE" in
  rebuild) rebuild ;;
  search) search "$@" ;;
  *) echo "Usage: $0 {rebuild|search \"query\"}" ;;
esac
