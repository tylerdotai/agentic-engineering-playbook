#!/bin/bash
# Tom Doerr Nightly Digest — fetches daily repos, researches them, posts to Discord
# Runs: Daily at 06:00 CDT (12:00 UTC)
#
# Research: GitHub API + README + feature analysis
# AI Agent implementation patterns included per repo
# Delivery: Discord via Bot API (embeds disabled)

set -euo pipefail

FEED_URL="https://tom-doerr.github.io/repo_posts/feed.xml"
STATE_FILE="/Users/soup/.openclaw/.tom-doerr-state.json"
DISCORD_CHANNEL_ID="1488443694540521607"
MAX_ENTRIES=8

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2; }

# Get Discord bot token
get_discord_token() {
  python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("channels",{}).get("discord",{}).get("token",""))' < ~/.openclaw/openclaw.json 2>/dev/null
}

DISCORD_BOT_TOKEN="$(get_discord_token)"
export DISCORD_BOT_TOKEN
[[ -z "${DISCORD_BOT_TOKEN}" ]] && log "ERROR: Discord bot token not found" && exit 1

# -- post to Discord (no embeds) - call from python --
# (implemented inside main python script below)

# -- main python runner --
python3 - <<'PYEOF'
import subprocess
import json
import sys
import time
import re
from datetime import datetime
from urllib.parse import urlparse

FEED_URL = "https://tom-doerr.github.io/repo_posts/feed.xml"
STATE_FILE = "/Users/soup/.openclaw/.tom-doerr-state.json"
DISCORD_CHANNEL_ID = "1488443694540521607"
DISCORD_BOT_TOKEN = ""
MAX_ENTRIES = 8

def log(msg):
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {msg}", flush=True)

def fetch_feed():
    result = subprocess.run(["curl", "-s", "--max-time", "30", FEED_URL], capture_output=True, text=True)
    return result.stdout

def parse_entries(feed_xml):
    import xml.etree.ElementTree as ET
    from datetime import datetime, timezone

    cutoff = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0)
    ns = {'atom': 'http://www.w3.org/2005/Atom', 'media': 'http://search.yahoo.com/mrss/'}
    entries = []

    try:
        root = ET.fromstring(feed_xml)
    except ET.ParseError as e:
        log(f"XML parse error: {e}")
        return []

    for entry in root.findall('atom:entry', ns):
        updated = entry.find('atom:updated', ns)
        if updated is None:
            continue
        updated_text = updated.text or ''
        try:
            dt = datetime.fromisoformat(updated_text.replace('Z', '+00:00'))
        except ValueError:
            continue
        if dt < cutoff:
            continue

        title_el = entry.find('atom:title', ns)
        title_text = title_el.text if title_el is not None else 'Unknown'

        repo_url = ''
        post_url = ''
        for link in entry.findall('atom:link', ns):
            rel = link.get('rel', '')
            href = link.get('href', '')
            if rel == 'related' and 'github.com' in href:
                repo_url = href
            if '.html' in href and 'tom-doerr' in href:
                post_url = href

        content_el = entry.find('atom:content', ns)
        description = ''
        if content_el is not None and content_el.text:
            text = re.sub(r'<[^>]+>', '', content_el.text)
            description = text.strip()[:300]

        if repo_url:
            entries.append({
                'title': title_text,
                'repo_url': repo_url,
                'post_url': post_url,
                'description': description,
                'updated': updated_text
            })

    return entries

def get_readme(gh_path):
    """Fetch README content from GitHub."""
    for readme_name in ["README.md", "readme.md", "Readme.md", "README.MD"]:
        raw_url = f"https://raw.githubusercontent.com/{gh_path}/HEAD/{readme_name}"
        result = subprocess.run(
            ["curl", "-s", "--max-time", "10", raw_url],
            capture_output=True, text=True
        )
        if result.stdout and len(result.stdout) > 100:
            return result.stdout[:8000]
    return ""

def analyze_readme_features(readme_content, gh_data):
    """Extract features, tech patterns, and use cases from README."""
    features = []
    tech_patterns = []
    use_cases = []

    if not readme_content:
        return features, tech_patterns, use_cases

    text_lower = readme_content.lower()

    # Detect tech patterns
    tech_map = {
        "webhook": "Webhook-driven",
        "api": "API-first",
        "rest": "REST API",
        "graphql": "GraphQL",
        "websocket": "WebSocket",
        "sse": "Server-Sent Events",
        "cli": "CLI tool",
        "tui": "Terminal UI",
        "gui": "GUI/desktop",
        "browser": "Browser-based",
        "docker": "Docker",
        "kubernetes": "Kubernetes",
        "self-hosted": "Self-hosted",
        "cloud": "Cloud-native",
        "local": "Local-first",
        "offline": "Offline-capable",
        "open source": "Open source",
        "free": "Free tier",
        "paid": "Paid/subscription",
        "api key": "API key auth",
        "oauth": "OAuth",
        "jwt": "JWT auth",
        "session": "Session-based",
        "rate limit": "Rate limiting",
        "cache": "Caching layer",
        "database": "Database backend",
        "sqlite": "SQLite",
        "postgres": "PostgreSQL",
        "mysql": "MySQL",
        "redis": "Redis",
        "queue": "Message queue",
        "background": "Background jobs",
        "cron": "Scheduled tasks",
        "web scrap": "Web scraping",
        "automation": "Automation",
        "ai": "AI/ML",
        "llm": "LLM integration",
        "gpt": "GPT/Claude API",
        "embedding": "Embeddings",
        "vector": "Vector DB",
        "rag": "RAG pipeline",
        "agent": "AI agent",
        "multi-agent": "Multi-agent",
        "tool use": "Tool use/calling",
        "mcp": "MCP server",
        "plugin": "Plugin system",
        "extension": "Extensible",
        "webhook": "Webhooks",
        "oauth": "OAuth",
        "github action": "GitHub Actions",
        "ci/cd": "CI/CD pipeline",
        "lambda": "Serverless",
        "edge": "Edge computing",
    }

    detected = set()
    for keyword, label in tech_map.items():
        if keyword in text_lower and label not in detected:
            detected.add(label)
            tech_patterns.append(label)

    # Extract features from headers and bullet points
    feature_lines = []
    for line in readme_content.split('\n'):
        line = line.strip()
        if line.startswith('##') or line.startswith('###'):
            # Section headers = feature areas
            feature_name = re.sub(r'^#+\s*', '', line).strip()
            if len(feature_name) > 3 and len(feature_name) < 60:
                feature_lines.append(feature_name)
        elif line.startswith('-') or line.startswith('*'):
            feat = line.lstrip('-* ').strip()
            if len(feat) > 10 and len(feat) < 150:
                feature_lines.append(feat)

    # Dedupe and limit
    seen = set()
    for f in feature_lines:
        f_clean = f.lower()[:50]
        if f_clean not in seen and not any(skip in f_clean for skip in ['table of', 'contents', 'install', 'license', 'contrib', 'contact', 'github']):
            seen.add(f_clean)
            features.append(f[:100])

    return features[:8], tech_patterns[:6], use_cases[:4]

def build_pros_cons(features, tech_patterns, readme_content, description):
    """Generate pros and cons based on features and patterns."""
    pros = []
    cons = []

    has_api = any("API" in t for t in tech_patterns)
    has_cli = any("CLI" in t for t in tech_patterns)
    has_ai = any(x in ' '.join(tech_patterns).lower() for x in ['ai', 'llm', 'rag', 'agent', 'mcp'])
    is_self_hosted = any("self-hosted" in t.lower() or "local" in t.lower() for t in tech_patterns)
    has_docker = any("docker" in t.lower() for t in tech_patterns)
    has_auth = any(x in ' '.join(tech_patterns).lower() for x in ['oauth', 'jwt', 'api key', 'session'])
    has_queue = any("queue" in t.lower() or "background" in t.lower() for t in tech_patterns)

    text_lower = (readme_content + ' ' + description).lower()

    # Pros
    if has_api:
        pros.append("API-first design — easy to integrate into agent workflows")
    if has_ai:
        pros.append("Built for AI/LLM use — agent-native architecture")
    if has_cli:
        pros.append("CLI tool — scriptable, works great in automated pipelines")
    if is_self_hosted:
        pros.append("Self-hosted option — no vendor lock-in, data stays local")
    if has_docker:
        pros.append("Docker-ready — one-command deployment")
    if has_queue:
        pros.append("Background job support — handles async agent tasks well")
    if "open source" in text_lower:
        pros.append("Open source — auditable, extensible code")
    if "free" in text_lower or "gratis" in text_lower:
        pros.append("Free tier available — low barrier to try")
    if len(features) > 5:
        pros.append(f"Rich feature set — {min(len(features), 8)} capability areas documented")

    # Cons
    if not has_api and "api" in description.lower():
        cons.append("No API — can't integrate into automated agent pipelines")
    if not has_ai and ("agent" in description.lower() or "ai" in description.lower()):
        cons.append("No native AI integration — would need wrapper to use with LLMs")
    if "beta" in text_lower or "alpha" in text_lower or "experimental" in text_lower:
        cons.append("Experimental/beta — may have rough edges or breaking changes")
    if not has_auth and ("auth" in text_lower or "secur" in text_lower):
        cons.append("Unclear auth story — may need custom auth layer for production")
    if has_docker and not any("docker" in l.lower() for l in readme_content.split('\n')[:50]):
        cons.append("Docker mentioned but no Dockerfile — setup may be manual")
    if len(features) < 3:
        cons.append("Limited documentation — hard to assess full capabilities")
    if "npm" in text_lower and "pip" not in text_lower and "cargo" not in text_lower:
        cons.append("JS/TS only — may not fit non-Node.js agent environments")
    if "windows" in description.lower() and "mac" not in description.lower() and "linux" not in description.lower():
        cons.append("Windows-focused — cross-platform support unclear")

    if not pros:
        pros.append("Feature-rich on the surface — README shows active development")
    if not cons:
        cons.append("Limited public info — deep dive needed to assess fully")

    return pros[:4], cons[:3]

def agent_implementation(title, features, tech_patterns, description, readme_content):
    """Suggest how to implement this in an AI agent system."""
    text_lower = (description + ' ' + readme_content[:2000]).lower()
    title_lower = title.lower()

    # Detect the repo category
    is_monitoring = any(x in text_lower for x in ['monitor', 'dashboard', 'metrics', ' observab'])
    is_security = any(x in text_lower for x in ['security', 'auth', 'encrypt', 'pentest', 'ad ', 'active directory'])
    is_devtool = any(x in text_lower for x in ['code', 'git', 'repo', 'build', 'test', 'deploy', 'ci/cd'])
    is_data = any(x in text_lower for x in ['database', 'sql', 'storage', 'backup', 'sync'])
    is_ai_native = any(x in text_lower for x in ['ai agent', 'llm', 'rag', 'mcp', 'tool use', 'autonomous'])
    is_comm = any(x in text_lower for x in ['message', 'chat', 'sms', 'email', 'discord', 'telegram', 'notification'])
    is_web = any(x in text_lower for x in ['scrap', 'crawl', 'fetch', 'http', 'browser', 'web'])
    is_infra = any(x in text_lower for x in ['docker', 'kubernetes', 'server', 'proxy', 'tunnel', 'network'])

    suggestions = []

    # Single agent use
    suggestions.append("**Single Agent Use:** This would work as a dedicated skill or tool that a single agent calls via tool-use. The agent would invoke it with context from its current task, parse the output, and incorporate the results into its response or actions.")

    # Multi-agent patterns
    if is_monitoring or is_infra:
        suggestions.append("**Multi-Agent Pattern:** Could work as a monitoring specialist agent that other agents query for system status. Example: a devops agent polls it for anomalies while a coder agent asks for log context during debugging.")
    elif is_security:
        suggestions.append("**Multi-Agent Pattern:** Security agent acts as a specialized scanner that other agents call before taking action. The planner agent dispatches the security agent, then incorporates findings before executing risky operations.")
    elif is_ai_native:
        suggestions.append("**Multi-Agent Pattern:** Could serve as a shared tool broker — multiple specialized agents (coder, writer, researcher) all route through this to access common AI capabilities. Acts as a force multiplier across the agent team.")
    elif is_data:
        suggestions.append("**Multi-Agent Pattern:** Data specialist agent that other agents query for persistent state. Example: a sales agent and ops agent both read/write customer data through this, making it the system of record for the agent team.")
    elif is_devtool:
        suggestions.append("**Multi-Agent Pattern:** Code reviewer agent uses this to run automated checks while a writer agent uses it for documentation. Could also serve as the deployment orchestrator that multiple agents report to.")
    else:
        suggestions.append("**Multi-Agent Pattern:** Could function as a shared utility agent — one that specialized agents (researcher, writer, analyst) all call for domain-specific data or processing, rather than each agent implementing it themselves.")

    # Integration approach
    if any("cli" in t.lower() for t in tech_patterns):
        suggestions.append("**Integration:** Expose via `exec` tool in OpenClaw — wrap the CLI with a prompt that explains outputs in agent-native terms. For multi-agent: publish as an OpenClaw skill that any agent can load.")

    suggestions.append("**Memory Integration:** For recurring agent use, store API responses in memory with timestamps so downstream agents don't re-query the same data.")

    return suggestions

def research_repo(repo_url, title, description, post_url):
    """Deep research on a repo: features, pros/cons, agent patterns."""
    gh_path = repo_url.replace("https://github.com/", "")

    # GitHub API
    gh_api = f"https://api.github.com/repos/{gh_path}"
    result = subprocess.run(
        ["curl", "-s", "--max-time", "15", gh_api, "-H", "Accept: application/vnd.github.v3+json"],
        capture_output=True, text=True
    )

    stars = "?"
    langs = ""
    description_md = description
    gh_data = {}

    try:
        gh_data = json.loads(result.stdout)
        stars = gh_data.get('stargazers_count', '?')
        language = gh_data.get('language', '')
        topics = gh_data.get('topics', []) or []
        all_langs = [language] + topics if language else topics
        langs = ', '.join([x for x in all_langs if x])[:100]
        desc = gh_data.get('description', '')
        if desc:
            description_md = desc
    except json.JSONDecodeError:
        pass

    # README analysis
    readme = get_readme(gh_path)
    features, tech_patterns, use_cases = analyze_readme_features(readme, gh_data)
    pros, cons = build_pros_cons(features, tech_patterns, readme, description_md)
    agent_patterns = agent_implementation(title, features, tech_patterns, description_md, readme)

    # Extract install command
    install_cmd = "See repo README"
    if readme:
        install_lines = []
        for line in readme.split('\n'):
            line_stripped = line.strip()
            if any(x in line_stripped.lower() for x in ['pip install', 'npm install', 'brew install', 'cargo install', 'go install', 'git clone', 'curl -', 'wget ']):
                install_lines.append(line_stripped)
                if len(install_lines) >= 2:
                    break
        if install_lines:
            install_cmd = ' \\ '.join(install_lines[:2])

    # Build markdown
    result_md = f"""## {title}
**Repo:** {repo_url}
**Stars:** ⭐ {stars} | **Lang:** {langs if langs else 'N/A'}

### What It Is
{description_md if description_md else 'See repo for details.'}

### Tech Signature
{', '.join(tech_patterns) if tech_patterns else 'See repo README'}

### Key Features
{chr(10).join(f"- {f}" for f in features[:6]) if features else '- See repo README'}

### Pros
{chr(10).join(f"+ {p}" for p in pros)}

### Cons
{chr(10).join(f"- {c}" for c in cons)}

### AI Agent Implementation
{chr(10).join(agent_patterns)}

### Quick Install
`{install_cmd}`

### Links
Repo: {repo_url} | Tom's Post: {post_url}"""

    return result_md

def post_to_discord(content, channel_id, bot_token):
    """Post content to Discord channel via Bot API. Suppresses link embeds."""
    import urllib.request
    import urllib.error
    import time

    if len(content) > 2000:
        chunks = [content[i:i+1900] for i in range(0, len(content), 1900)]
    else:
        chunks = [content]

    for i, chunk in enumerate(chunks):
        # Replace markdown links with plain text, then angle-bracket bare URLs
        import re
        # First: handle [text](url) markdown links - extract URL and use text
        chunk_clean = re.sub(r'\[([^\]]{1,200})\]\((https?://[^\)]{1,500})\)', r'\1 (\2)', chunk)
        # Second: convert bare URLs to angle-bracket form (suppresses Discord auto-embed)
        # Stop at common URL terminators: ) ` ' " ] } , more: ; : < >
        chunk_clean = re.sub(
            r'(?<!\()(https?://[^\s\)`\'\"\],;:<>]{4,200})',
            r'<\1>',
            chunk_clean
        )
        payload = json.dumps({"content": chunk_clean, "embeds": []}).encode("utf-8")
        req = urllib.request.Request(
            f"https://discord.com/api/v10/channels/{channel_id}/messages",
            data=payload,
            headers={
                "Authorization": f"Bot {bot_token}",
                "Content-Type": "application/json",
                "User-Agent": "DiscordBot (https://github.com/discord/discord-example-bot, 1.0.0)"
            },
            method="POST"
        )
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                resp_body = resp.read().decode("utf-8", errors="ignore")
                if resp_body:
                    try:
                        resp_obj = json.loads(resp_body)
                        msg_id = resp_obj.get("id", "?")
                        print(f"Chunk {i+1}/{len(chunks)} posted (ID: {str(msg_id)[:8]})", flush=True)
                    except:
                        print(f"Chunk {i+1}/{len(chunks)} posted", flush=True)
                else:
                    print(f"Chunk {i+1}/{len(chunks)} posted (empty)", flush=True)
        except urllib.error.HTTPError as e:
            err_body = e.read().decode("utf-8", errors="ignore")[:300]
            print(f"Chunk {i+1}/{len(chunks)} HTTP {e.code}: {err_body}", flush=True)
            if e.code == 429:
                try:
                    err_json = json.loads(err_body)
                    wait = err_json.get("retry_after", 5)
                except:
                    wait = 5
                print(f"Rate limited, waiting {wait}s...", flush=True)
                time.sleep(wait + 0.5)
                try:
                    with urllib.request.urlopen(req, timeout=30):
                        print(f"Chunk {i+1} retry OK", flush=True)
                except Exception as retry_err:
                    print(f"Chunk {i+1} retry failed: {retry_err}", flush=True)
        except Exception as e:
            print(f"Chunk {i+1}/{len(chunks)} error: {e}", flush=True)

        if i < len(chunks) - 1:
            time.sleep(2)


def main():
    global DISCORD_BOT_TOKEN

    log("Starting Tom Doerr digest...")

    # DISCORD_BOT_TOKEN is set at bash level via get_discord_token()
    # Pass it through via environment
    import os
    global_bot_token = os.environ.get("DISCORD_BOT_TOKEN", "")
    if not global_bot_token:
        global_bot_token = get_discord_token()
    DISCORD_BOT_TOKEN = global_bot_token
    log(f"Token available: {'yes' if DISCORD_BOT_TOKEN else 'NO'}")

    log("Fetching feed...")
    feed = fetch_feed()

    log("Parsing entries...")
    entries = parse_entries(feed)
    count = len(entries)
    log(f"Found {count} new entries")

    if count == 0:
        log("No new entries.")
        with open(STATE_FILE, 'w') as f:
            json.dump({"last_run": datetime.utcnow().isoformat() + "Z"}, f)
        return

    if count > MAX_ENTRIES:
        log(f"Capping to {MAX_ENTRIES} entries")
        entries = entries[:MAX_ENTRIES]
        count = MAX_ENTRIES

    digest = f"# ⚡ Tom Doerr's Heaters — {datetime.now().strftime('%B %d, %Y')}\n\n{count} repos that caught my eye. Deep dive below.\n\n---"

    for i, entry in enumerate(entries):
        log(f"Researching: {entry['title']}...")
        research = research_repo(
            entry['repo_url'],
            entry['title'],
            entry['description'],
            entry['post_url']
        )
        digest += f"\n\n{research}\n\n---"

        if i < len(entries) - 1:
            time.sleep(2)

    digest = digest.rstrip('-').rstrip()
    digest += f"\n\n---\n_Built by Hoss ⚡ | tom-doerr.github.io/repo_posts_"

    with open(STATE_FILE, 'w') as f:
        json.dump({"last_run": datetime.utcnow().isoformat() + "Z"}, f)

    log("Posting to Discord...")
    post_to_discord(digest, DISCORD_CHANNEL_ID, DISCORD_BOT_TOKEN)
    log("Done!")

if __name__ == '__main__':
    main()
PYEOF
