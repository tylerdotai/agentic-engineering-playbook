#!/bin/bash
# memory-search.sh — Fast FTS5 search over all memory files
# Usage: memory-search "query"

DB="/Users/soup/.openclaw/memory/memory.fts.db"

if [ ! -f "$DB" ]; then
  echo "Index not found. Run: bash /Users/soup/.openclaw/scripts/memory-fts-indexer.sh rebuild"
  exit 1
fi

query="$*"
if [ -z "$query" ]; then
  echo "Usage: memory-search \"query\""
  exit 1
fi

results=$(sqlite3 -json "$DB" "
  SELECT filename, date, snippet(memory_fts, 2, '**', '**', '...', 40) as snippet
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
