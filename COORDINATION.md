# Coordination Protocol

How agents communicate, delegate, and deliver results.

---

## Task Flow

```
Tyler (Conductor)
    │
    │ "Build me a landing page"
    ▼
Hoss (AI Co-Founder)
    │
    ├─► Direct Execution? ──────────────────────────────┐
    │                                                     │
    │   If simple task:                                  │
    │   - Hoss handles directly                          │
    │   - Updates memory                                 │
    │   - Returns result to Tyler                        │
    │                                                     │
    └─► Sub-Agent Spawn? ────────────────────────────────┤
                                                          │
        If complex task:                                  │
        - Hoss assesses required specialists              │
        - Spawns agents with clear, focused tasks         │
        - Agents execute IN PARALLEL                      │
        - Results return to Hoss                          │
        - Hoss synthesizes                                │
        - Hoss delivers to Tyler                          │
                                                          │
        ◄───────────────────────────────────────────────┘
```

---

## Memory Architecture

### Session Start

1. Hoss reads `SOUL.md` → knows identity
2. Hoss reads `USER.md` → knows Tyler's preferences
3. Hoss reads `MEMORY.md` → knows long-term context
4. Hoss reads `memory/YYYY-MM-DD.md` (today + yesterday) → recent events
5. Hoss ready for task

### During Session

1. Decisions → logged to `memory/YYYY-MM-DD.md`
2. Important findings → promoted to `MEMORY.md`
3. Mistakes → logged to `.learnings/ERRORS.md`
4. Lessons → promoted to `LEARNINGS.md`

### Session End

1. Hoss updates daily log with session summary
2. Key decisions documented
3. Pending items noted for next session

---

## Agent Spawning Protocol

### When to Spawn a Sub-Agent

Spawn when:
- Task requires specialized knowledge
- Task is independent and parallelizable
- Task scope warrants dedicated focus
- TDD/code quality requires separate review

Don't spawn when:
- Task is simple/fast (< 5 minutes)
- Task requires Hoss's context/memory
- Task is highly sequential with dependencies

### Spawn Command

```bash
sessions_spawn(
  task="<precise task description>",
  label="<agent-name>",
  runtime="subagent",
  runTimeoutSeconds=<timeout>,
  mode="run"
)
```

### Spawn Template

```
Task: <precise description>
Workspace: <agent workspace>
Context: <what Hoss knows that agent needs>
Output: <what to return/surface>
Timeout: <reasonable timeout>
```

---

## Communication Channels

### Internal (Agent-to-Agent)
- **Filesystem:** Memory files, workspace artifacts
- **GitHub:** Issues, PRs, commits for code collaboration
- **OpenClaw sessions:** Direct messaging via `sessions_send`

### External (Agent-to-World)
- **Discord:** Community feed, notifications, ClawPlex
- **GitHub:** PRs, issues, releases
- **Vercel/Cloudflare:** Deployments
- **Email:** Via himalaya skill

### Tyler-to-Agent
- **Discord DM:** Primary communication
- **Direct chat:** OpenClaw main session
- **iMessage:** Quick pings via Sendblue

---

## Quality Gates

### Code Quality
1. Hoss reviews all code before commit
2. Coder agent enforces TDD (80% coverage)
3. Linting and formatting checks
4. No `git push --force` to main

### Deployment Quality
1. Preview deployment first
2. Visual verification
3. Functional smoke test
4. Only then production

### Documentation Quality
1. Docs match reality
2. README for every project
3. CHANGELOG for releases
4. Inline comments for complex code

---

## Error Handling

### Agent Failure
1. Log error to memory
2. Notify Tyler via Discord
3. Document what failed
4. Propose recovery plan

### Task Blocked
1. Identify blocker
2. Surface to Tyler with options
3. Don't hand problems back—hand decisions forward

### System Failure
1. Check logs: `~/.openclaw/logs/`
2. Check crons: `openclaw cron list`
3. Health check: `bash memory/scripts/check_health.sh`
4. Report to Tyler with assessment

---

## Session Management

### Main Session (Hoss)
- Persistent, long-running
- Memory persists across restarts
- Coordinates all sub-agents
- Primary interface for Tyler

### Sub-Agent Sessions
- Spawned per-task or per-cron
- Isolated workspaces
- Report back to Hoss
- Terminate on completion

### Heartbeat
- Hoss runs heartbeat checks every 30 minutes during active hours (08:00-22:00 CDT)
- Checks: Git backup, memory health, cron status, disk space
- Silent if all OK, alerts if issues found
