# Cron Schedule

Automated tasks run on schedule via OpenClaw cron system.

## Active Crons

| ID | Name | Schedule | Next | Last | Status | Agent |
|----|------|----------|------|------|--------|-------|
| `a24a33cd-90b3-4b7b-9416-812fe26af334` | Meta harness evolution | `0 3 * * *` | 3:00 AM | 17h ago | ERROR | main |
| `6a4e10fc-5a8e-455c-a810-4a341db0fc92` | Tom Doerr daily digest | `0 6 * * *` | 6:00 AM | 14h ago | OK | isolated |
| `a316de2d-2c74-403a-90e8-aeacf5867409` | Memory index rebuild | `0 7 * * *` | 7:00 AM | 13h ago | OK | main |
| `1d623c83-8060-49f2-8445-6d33fcfad831` | Hoss daily standup | `5 8 * * *` | 8:05 AM | 12h ago | OK | isolated |

## Cron Details

### Meta Harness Evolution
- **Schedule:** 3:00 AM daily
- **Purpose:** Self-improvement loop for the agent harness
- **Agent:** main
- **Status:** ERROR (17h since last run) — under investigation

### Tom Doerr Daily Digest
- **Schedule:** 6:00 AM daily
- **Purpose:** Fetches curated AI/agent news from Tom Doerr's RSS feed, generates research digest with specific AI agent implementation patterns
- **Output:** Posts to #personal-intelligence Discord channel
- **Agent:** isolated
- **Feed:** https://tom-doerr.github.io/repo_posts/feed.xml

### Memory Index Rebuild
- **Schedule:** 7:00 AM daily
- **Purpose:** Rebuilds FTS5 full-text search index for memory files
- **Agent:** main
- **Script:** `memory-fts-indexer.sh rebuild`

### Hoss Daily Standup
- **Schedule:** 8:05 AM daily
- **Purpose:** Morning health check and daily log entry
- **Agent:** isolated

## Managing Crons

```bash
# List all crons
openclaw cron list

# View recent runs
openclaw cron runs <cron-id>

# Create a new cron
openclaw cron create \
  --name "my-task" \
  --schedule "0 9 * * *" \
  --agent einstein \
  --task "Description of task"

# Delete a cron
openclaw cron delete <cron-id>
```

## Active Hours

Crons run 24/7 but Hoss (main agent) operates in active hours:
- **Start:** 8:00 AM CDT
- **End:** 10:00 PM CDT
- Heartbeat checks run every 30 minutes during active hours only
