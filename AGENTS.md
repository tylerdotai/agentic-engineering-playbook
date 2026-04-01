# AGENTS.md — Agent Architecture

## Overview

Tyler runs a team of 13 agents: 1 primary (Hoss) + 12 sub-agents. This document details the architecture, roles, and coordination.

---

## The Agent Team

### Hoss (Primary Agent)
- **Role:** AI Co-Founder, Orchestrator
- **Workspace:** `~/.openclaw/workspace/`
- **Model:** MiniMax 2.7
- **Responsibilities:**
  - Memory maintenance
  - Sub-agent coordination
  - Task execution
  - Quality gates
  - Strategic thinking

### Sub-Agents

| Agent | Workspace | Role | Active |
|-------|-----------|------|--------|
| **builder** | `agents/builder/` | Builds and ships SaaS products | ✓ |
| **coder** | `agents/coder/` | Test coverage, TDD enforcement | placeholder |
| **devops** | `agents/devops/` | Infrastructure, deployments, Docker | ✓ |
| **einstein** | `agents/einstein/` | Autoresearch, skill improvement | ✓ |
| **marketer** | `agents/marketer/` | Content, brand, audience | ✓ |
| **ops** | `agents/ops/` | Financials, vendors, reliability | placeholder |
| **sales** | `agents/sales/` | Lead outreach, pipeline | placeholder |
| **scout** | `agents/scout/` | Market research, lead generation | ✓ |
| **eval-middleware** | `agents/eval-middleware/` | Agent evaluation system | ✓ |
| **commit-scanner** | `agents/commit-scanner/` | Git commit analysis | ✓ |
| **pr-inspector** | `agents/pr-inspector/` | Pull request review | ✓ |
| **release-herald** | `agents/release-herald/` | Release notifications | ✓ |
| **webhook-processor** | `agents/webhook-processor/` | Webhook handling | ✓ |
| **issue-triage** | `agents/issue-triage/` | GitHub issue management | ✓ |

---

## Directory Structure

```
~/.openclaw/
├── agents/
│   ├── main/              # Hoss (primary)
│   ├── builder/
│   ├── coder/
│   ├── devops/
│   ├── einstein/
│   ├── marketer/
│   ├── scout/
│   ├── eval-middleware/
│   ├── commit-scanner/
│   ├── pr-inspector/
│   ├── release-herald/
│   ├── webhook-processor/
│   └── issue-triage/
├── workspace/            # Hoss's workspace (primary)
│   ├── SOUL.md
│   ├── IDENTITY.md
│   ├── MEMORY.md
│   ├── USER.md
│   ├── AGENTS.md
│   ├── HEARTBEAT.md
│   ├── TOOLS.md
│   └── memory/
│       └── YYYY-MM-DD.md
├── skills/               # 67 skills installed
├── memory/
│   ├── memory.fts.db     # Full-text search index
│   └── *.md              # Daily logs
└── scripts/              # Operational scripts
```

---

## Agent Spawning

Agents are spawned via OpenClaw:

```bash
openclaw agents spawn --name <agent> --workspace <workspace> [--timeout <seconds>]
```

Or via `sessions_spawn` tool for sub-agents.

---

## Inter-Agent Communication

Agents communicate through:
1. **Shared filesystem** — Memory files in workspace
2. **GitHub** — Issues, PRs, commits
3. **Discord** — Community feed, notifications
4. **OpenClaw sessions** — Direct messaging

---

## Coordination Patterns

### Task Delegation
1. Tyler → Hoss (task)
2. Hoss assesses: direct execution vs sub-agent spawn
3. If sub-agent: Hoss spawns with clear task + workspace
4. Sub-agent executes → returns results to Hoss
5. Hoss synthesizes → surfaces to Tyler

### Memory Flow
1. Daily logs in `memory/YYYY-MM-DD.md`
2. Hoss promotes important info to `MEMORY.md`
3. Decisions get documented
4. Agent updates documented in respective agent workspace

---

## Evaluation System

See `skills/eval-agent/SKILL.md` for evaluation system.

**9 evals live across 3 agents:**
- coder: TDD discipline, 80% coverage, no regressions
- ops: cost tracking, alert relevance, summary quality
- scout: lead quality, signal detection, context usage

---

## Cron Jobs

Automated tasks run on schedule via OpenClaw cron:

```bash
openclaw cron list
```

| Schedule | Task | Target | Status |
|----------|------|--------|--------|
| `0 3 * * *` | Meta harness evolution | main | ERROR |
| `0 6 * * *` | Tom Doerr daily digest | isolated | OK |
| `0 7 * * *` | Memory index rebuild | main | OK |
| `5 8 * * *` | Hoss daily standup | isolated | OK |

---

## Model Usage

- **Primary:** MiniMax 2.7 (4500 req/5hrs)
- **High-speed:** MiniMax 2.7-highspeed
- **Cost:** ~$200/year all-in
- **Tokens burned:** ~3B since Jan 31, 2026
