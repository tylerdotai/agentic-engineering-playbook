#!/bin/bash
# Agent Health Check Script
# Run this to verify all agents and systems are operational

set -e

echo "==================================="
echo "Agent Team Health Check"
echo "==================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall status
ALL_OK=true

# Check 1: OpenClaw Gateway
echo -n "OpenClaw Gateway: "
if openclaw gateway status > /dev/null 2>&1; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}ERROR${NC}"
    ALL_OK=false
fi

# Check 2: Agent Directories
echo -n "Agent Directories: "
AGENTS=("builder" "coder" "devops" "einstein" "marketer" "scout" "eval-middleware" "commit-scanner" "pr-inspector" "release-herald" "webhook-processor" "issue-triage")
MISSING=0
for agent in "${AGENTS[@]}"; do
    if [ ! -d "$HOME/.openclaw/agents/$agent" ]; then
        MISSING=$((MISSING+1))
    fi
done
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}OK (12 agents)${NC}"
else
    echo -e "${YELLOW}WARNING ($MISSING missing)${NC}"
fi

# Check 3: Memory Directory
echo -n "Memory Directory: "
if [ -d "$HOME/.openclaw/workspace/memory" ]; then
    MEM_FILES=$(ls -1 "$HOME/.openclaw/workspace/memory"/*.md 2>/dev/null | wc -l)
    echo -e "${GREEN}OK ($MEM_FILES files)${NC}"
else
    echo -e "${RED}MISSING${NC}"
    ALL_OK=false
fi

# Check 4: Skills
echo -n "Skills Installation: "
SKILL_COUNT=$(ls -1d $HOME/.openclaw/skills/*/ 2>/dev/null | wc -l)
if [ $SKILL_COUNT -gt 50 ]; then
    echo -e "${GREEN}OK ($SKILL_COUNT skills)${NC}"
else
    echo -e "${YELLOW}LOW ($SKILL_COUNT skills)${NC}"
fi

# Check 5: Cron Jobs
echo -n "Cron Jobs: "
CRON_COUNT=$(openclaw cron list 2>/dev/null | grep -c "cron" || echo "0")
if [ "$CRON_COUNT" -gt 0 ]; then
    echo -e "${GREEN}OK ($CRON_COUNT jobs)${NC}"
else
    echo -e "${YELLOW}No crons found${NC}"
fi

# Check 6: Workspace Files
echo -n "Workspace Files: "
REQUIRED_FILES=("SOUL.md" "MEMORY.md" "USER.md" "IDENTITY.md" "HEARTBEAT.md" "AGENTS.md")
MISSING_FILES=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$HOME/.openclaw/workspace/$file" ]; then
        MISSING_FILES=$((MISSING_FILES+1))
    fi
done
if [ $MISSING_FILES -eq 0 ]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}MISSING ($MISSING_FILES files)${NC}"
    ALL_OK=false
fi

# Check 7: Git Integration
echo -n "Git Remote: "
if git -C "$HOME/.openclaw/workspace" remote -v 2>/dev/null | grep -q "origin"; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${YELLOW}No remote configured${NC}"
fi

# Check 8: Disk Space
echo -n "Disk Space: "
DISK_USAGE=$(df -h "$HOME" | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 90 ]; then
    echo -e "${GREEN}OK ($DISK_USAGE%)${NC}"
else
    echo -e "${RED}WARNING ($DISK_USAGE%)${NC}"
fi

echo ""
echo "==================================="
if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}All systems operational${NC}"
    exit 0
else
    echo -e "${RED}Some checks failed${NC}"
    exit 1
fi
