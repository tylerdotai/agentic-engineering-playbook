# Agentic Engineering Playbook

## The Comprehensive Technical White Paper on Running an AI Agent Team with OpenClaw

> **What if one person could run a company?** Not by working 80 hours a week—but by orchestrating a team of AI agents that never sleep, never forget, and never drop the ball.
>
> This is the real, operational playbook for how Tyler Delano—IT Support tech by day, AI agent builder by night—runs an entire product operation with Hoss (primary AI co-founder) and 12 specialized sub-agents.

---

## The Premise

**One human conductor. Multiple specialized agents.** Each agent has a role, a workspace, and a set of skills. They don't know about each other. They don't need to. They just execute.

Tyler is the conductor. Hoss is the co-founder. The sub-agents are specialists.

**This isn't automation. It's amplification.**

---

## The Numbers

| Metric | Value |
|--------|-------|
| Total Agents | 13 (Hoss + 12 sub-agents) |
| Skills Installed | 67 |
| Tokens Burned (since Jan 31) | ~3 billion |
| Monthly AI Cost | ~$17 ($200/year) |
| Primary Model | MiniMax 2.7 |
| Agent Platform | OpenClaw |
| Infrastructure | Mac mini M4 Pro (local) + Raspberry Pi (backup) |

---

## The Agent Team

### Human / Conductor

**Tyler Delano** — [@tylerdotai](https://twitter.com/tylerdotai) | [LinkedIn](https://linkedin.com/in/tylerpdelano)

The conductor. Makes decisions, sets direction, works the day job (Amazon L3 IT Support), builds at night. Runs 16-18 hours a day. Has skin in the game.

- Pizza delivery driver → Amazon September 2018 (tier 1 stower) → IT Support L3
- Fell into AI agents January 21st, 2026—went all in as a hobby
- **The insight:** AI agents are the great equalizer. The little guy can finally have the same leverage as the enterprise.

### AI Co-Founder

**Hoss** — Primary agent

Primary AI co-founder. Reads memory files, maintains context, coordinates sub-agents, executes tasks, pushes back when Tyler's wrong. Lives in the workspace.

- Orchestrator and executor
- Maintains memory across sessions
- Coordinates sub-agents
- Quality gates code, docs, deployments

### 12 Sub-Agents

| Agent | Role | Active |
|-------|------|--------|
| **builder** | Builds and ships SaaS products | ✓ |
| **coder** | Test coverage, TDD enforcement | ✓ (workspace ready) |
| **devops** | Infrastructure, deployments, Docker | ✓ |
| **einstein** | Autoresearch, skill improvement | ✓ |
| **marketer** | Content, brand, audience | ✓ |
| **ops** | Financials, vendors, reliability | ✓ (workspace ready) |
| **sales** | Lead outreach, pipeline | ✓ (workspace ready) |
| **scout** | Market research, lead generation | ✓ |
| **eval-middleware** | Agent evaluation system | ✓ |
| **commit-scanner** | Git commit analysis | ✓ |
| **pr-inspector** | Pull request review | ✓ |
| **release-herald** | Release notifications | ✓ |
| **webhook-processor** | Webhook handling | ✓ |
| **issue-triage** | GitHub issue management | ✓ |

*(✓ = active with full workspace, placeholder = 64-byte stub directories)*

---

## The Architecture

```
Tyler (Conductor)
    ↓
Hoss (AI Co-Founder)
    ├── Memory System
    │   ├── SOUL.md (identity)
    │   ├── IDENTITY.md (role)
    │   ├── MEMORY.md (long-term context)
    │   ├── USER.md (preferences)
    │   └── memory/YYYY-MM-DD.md (daily logs)
    │
    └── Sub-Agents (parallel execution)
        ├── einstein (research)
        ├── scout (market intel)
        ├── builder (product dev)
        ├── coder (code quality)
        ├── devops (infra/deploy)
        ├── marketer (content)
        ├── eval-middleware (quality)
        ├── commit-scanner (commits)
        ├── pr-inspector (PRs)
        ├── release-herald (releases)
        ├── webhook-processor (webhooks)
        └── issue-triage (issues)
```

---

## The Coordination Protocol

### How Tasks Flow

**1. Tyler identifies a task**
Could be anything—build a website, research competitors, write an email, fix a bug, create a plan.

**2. Hoss receives the task**
Reads memory, assesses scope, determines if sub-agents are needed. If yes, spawns them. If no, handles it directly.

**3. Sub-agents execute in parallel**
Builder might build a frontend while Scout researches competitors while Einstein runs a digest. All on cron, all independent.

**4. Hoss synthesizes results**
Sub-agents return their output. Hoss integrates it, updates memory, and delivers a coherent result to Tyler.

**5. Tyler makes decisions**
Hoss surfaces options with tradeoffs and a recommendation. Tyler chooses. Hoss executes. Loop continues.

### Memory System

The memory system is what makes this work. Hoss doesn't start fresh each session—he reads his workspace files and knows who he is, what Tyler cares about, and what happened before.

**Files:**
- `SOUL.md` — Identity and personality
- `IDENTITY.md` — Role definition
- `MEMORY.md` — Long-term curated memory
- `USER.md` — Tyler's preferences and context
- `HEARTBEAT.md` — Proactive monitoring rules
- `AGENTS.md` — Sub-agent registry
- `memory/YYYY-MM-DD.md` — Daily logs
- `.learnings/` — Lessons from mistakes

---

## The Skills Catalog

67 skills installed across the agent team. See [SKILLS.md](SKILLS.md) for full documentation.

### Core Skills

| Skill | Purpose |
|-------|---------|
| **github** | GitHub API, repo management, issues, PRs |
| **github-mcp** | GitHub MCP server integration |
| **docker** | Container builds, Docker Compose |
| **cloudflare** | DNS, pages, workers, CDN |
| **vercel-deploy** | Vercel deployments |
| **mini-agent-integration** | MiniMax CLI agent spawning |
| **minimax-mcp** | Token Plan API access |
| **openai-whisper** | Audio transcription |
| **spotify-player** | Spotify control |
| **tmux** | Terminal session management |
| **himalaya** | Email management |
| **1password** | Credential retrieval |
| **apple-notes** | Notes integration |
| **things-mac** | Todo management |

### Specialty Skills

| Skill | Purpose |
|-------|---------|
| **eval-agent** | Agent evaluation and scoring |
| **blogwatcher** | RSS feed monitoring |
| **search-skill** | Web search (SearXNG) |
| **session-logs** | Log analysis |
| **model-usage** | API usage tracking |
| **healthcheck** | System health monitoring |

---

## The Cron Schedule

Automated tasks run on schedule. See [CRONS.md](CRONS.md) for full schedule.

| Time | Task | Agent | Status |
|------|------|-------|--------|
| 3:00 AM | Meta harness evolution | main | ERROR |
| 6:00 AM | Tom Doerr daily digest | isolated | OK |
| 7:00 AM | Memory index rebuild | main | OK |
| 8:05 AM | Hoss daily standup | isolated | OK |

---

## Operational Scripts

See [scripts/](scripts/) directory for automation scripts.

| Script | Purpose |
|--------|---------|
| `agent-health-check.sh` | System health verification |
| `memory-fts-indexer.sh` | Full-text search index |
| `memory-search.sh` | Memory search |
| `tom-doerr-digest.sh` | RSS to Discord research |
| `skill-autogen.sh` | Skill suggestion/creation |

---

## Projects Built With This System

| Project | URL | Stage |
|---------|-----|-------|
| **clawplex** | https://clawplex.dev | Live — DFW AI builder community |
| **fort-os** | https://fort-os.com | Active — Managed OpenClaw hosting |
| **fwpanthers** | https://fwpanthers.vercel.app | Active — Hockey team website |
| **tylerdotai.com** | https://tylerdotai.com | Active — Personal brand |
| **flume-showcase** | https://flume-showcase.vercel.app | Active — This playbook site |

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Agent Platform | OpenClaw |
| Primary Model | MiniMax 2.7 (4500 req/5hrs) |
| Secondary | MiniMax 2.7-highspeed |
| Image Gen | MiniMax image-01 |
| Voice | MiniMax Speech 2.8 |
| Search | SearXNG (self-hosted) |
| Hosting | Vercel (frontend), Cloudflare Pages (static) |
| GitHub | github.com/tylerdotai |
| Communication | Discord (community), Sendblue (iMessage) |

---

## Setup Guide

See [SETUP.md](SETUP.md) for complete setup instructions.

### Quick Start

1. Install OpenClaw
2. Configure MiniMax API keys
3. Set up workspace directory
4. Load skills
5. Configure sub-agents
6. Set up memory files
7. Configure crons

---

## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

**This is open source.** If you see something wrong, submit a PR. If you have questions, open an issue.

---

## License

MIT License — See [LICENSE](LICENSE)

---

## Contact

- **Tyler Delano:** [@tylerdotai](https://twitter.com/tylerdotai) | [LinkedIn](https://linkedin.com/in/tylerpdelano) | tyyler.delano@icloud.com
- **Hoss (AI Co-Founder):** Managed through OpenClaw
- **Community:** https://discord.gg/q8kEquTu3z (ClawPlex)

---

*Built with OpenClaw. Operated from DFW Area, Texas.*
