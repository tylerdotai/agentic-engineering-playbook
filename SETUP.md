# Setup Guide

How to set up your own AI agent team with OpenClaw.

---

## Prerequisites

- **macOS or Linux** (OpenClaw host)
- **Node.js 18+** (for OpenClaw)
- **GitHub account** (for repos and PAT)
- **MiniMax account** (for model access)

---

## Step 1: Install OpenClaw

```bash
# Install via npm
npm install -g openclaw

# Or via package manager
brew install openclaw
```

---

## Step 2: Configure OpenClaw

```bash
# Initialize
openclaw init

# Configure model provider (MiniMax)
openclaw config set model.minimax.api_key YOUR_API_KEY
openclaw config set model.minimax.base_url https://api.minimax.io/anthropic

# Set default model
openclaw config set default_model minimax-portal/MiniMax-M2.7
```

---

## Step 3: Set Up Workspace

```bash
# Create workspace directory
mkdir -p ~/.openclaw/workspace

# Create memory directory
mkdir -p ~/.openclaw/workspace/memory

# Create agents directory
mkdir -p ~/.openclaw/agents
```

---

## Step 4: Create Identity Files

Create the following files in `~/.openclaw/workspace/`:

### SOUL.md
Your agent's personality and identity. See [SOUL.md](SOUL.md) for template.

### IDENTITY.md
Your agent's role and responsibilities. See [IDENTITY.md](IDENTITY.md) for template.

### MEMORY.md
Long-term memory file. Start with your background, goals, and key context.

### USER.md
Information about the human(s) you work with.

### HEARTBEAT.md
Proactive monitoring rules. What to check, when, and how to alert.

---

## Step 5: Install Skills

```bash
# Install from ClawHub
openclaw skills install github
openclaw skills install vercel-deploy
openclaw skills install cloudflare
openclaw skills install docker

# Or manually
cp -r /path/to/skill ~/.openclaw/skills/
```

See [SKILLS.md](SKILLS.md) for full catalog.

---

## Step 6: Configure Sub-Agents

```bash
# Create agent directories
mkdir -p ~/.openclaw/agents/{builder,coder,devops,einstein,scout,marketer}

# Each agent needs its own workspace and configuration
openclaw agents create --name builder --workspace ~/.openclaw/agents/builder
```

---

## Step 7: Set Up GitHub Integration

```bash
# Generate GitHub PAT
# Settings → Developer settings → Personal access tokens → Generate new token
# Required scopes: repo, read:user, workflow

# Configure GitHub
openclaw config set github.token YOUR_GITHUB_PAT
```

---

## Step 8: Configure Cron Jobs

```bash
# List current crons
openclaw cron list

# Create a new cron
openclaw cron create \
  --name "daily-digest" \
  --schedule "0 6 * * *" \
  --agent einstein \
  --task "Run research digest and post findings"
```

---

## Step 9: Memory Index Setup

```bash
# Build full-text search index
bash ~/.openclaw/scripts/memory-fts-indexer.sh rebuild

# Add to crontab for daily rebuild
# 0 7 * * * bash ~/.openclaw/scripts/memory-fts-indexer.sh rebuild
```

---

## Step 10: Communication Setup

### Discord (for community and alerts)
```bash
# Configure Discord webhook
openclaw config set discord.webhook YOUR_WEBHOOK_URL
```

### iMessage (via Sendblue)
```bash
# Install sendblue CLI
brew install sendblue/tap/sendblue

# Configure
sendblue auth login YOUR_API_KEY
```

---

## Step 11: Test Your Setup

```bash
# Run a simple task
openclaw agents run --name main --task "What day is it?"

# Check memory health
bash ~/.openclaw/scripts/check_health.sh

# Verify skills
openclaw skills list
```

---

## Directory Structure

Final structure should look like:

```
~/.openclaw/
├── workspace/
│   ├── SOUL.md
│   ├── IDENTITY.md
│   ├── MEMORY.md
│   ├── USER.md
│   ├── HEARTBEAT.md
│   ├── AGENTS.md
│   ├── TOOLS.md
│   ├── memory/
│   │   └── YYYY-MM-DD.md
│   └── .learnings/
├── agents/
│   ├── main/
│   ├── builder/
│   ├── coder/
│   ├── devops/
│   ├── einstein/
│   └── scout/
├── skills/
│   ├── github/
│   ├── vercel-deploy/
│   └── cloudflare/
├── memory/
│   ├── memory.fts.db
│   └── *.md
└── scripts/
    ├── backup_manifest.sh
    ├── memory-fts-indexer.sh
    └── memory-search.sh
```

---

## Useful Commands

```bash
# Agent management
openclaw agents list                    # List all agents
openclaw agents spawn --name <name>     # Spawn new agent
openclaw agents kill --name <name>      # Kill agent

# Cron management
openclaw cron list                      # List crons
openclaw cron runs <cron-id>            # Show recent runs

# Skills
openclaw skills list                    # List installed skills
openclaw skills install <name>          # Install skill
openclaw skills check                   # Audit skill health

# Logs
openclaw logs --agent main --lines 100  # View logs
```

---

## Troubleshooting

### Agent not responding
- Check if OpenClaw daemon is running: `openclaw gateway status`
- Restart if needed: `openclaw gateway restart`

### Memory not persisting
- Check disk space: `df -h`
- Verify memory files exist: `ls -la ~/.openclaw/workspace/memory/`
- Rebuild index: `bash ~/.openclaw/scripts/memory-fts-indexer.sh rebuild`

### Skills not loading
- Check skill paths: `openclaw skills list`
- Verify skill structure: each skill needs `SKILL.md`
- Check for errors: `openclaw skills check`

### Model API errors
- Verify API key: `openclaw config get model.minimax.api_key`
- Check rate limits: MiniMax dashboard
- Try fallback model

---

## Next Steps

1. Run your first real task
2. Set up your first cron job
3. Build something with your agent team
4. Document your setup in your own version of this playbook
