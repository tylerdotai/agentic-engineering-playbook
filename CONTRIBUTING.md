# Contributing to Agentic Engineering Playbook

Contributions welcome. This is open source—help make it better.

---

## How to Contribute

### Reporting Issues

Found a bug? Something incorrect? Open an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Your environment (OS, OpenClaw version, etc.)

### Submitting Changes

1. **Fork the repo**
2. **Create a branch** for your change
   ```bash
   git checkout -b fix/agent-coordination-detail
   ```
3. **Make your changes**
   - Keep commits atomic and descriptive
   - Update docs if you change behavior
   - Test your changes
4. **Commit with clear message**
   ```bash
   git commit -m "fix: clarify coordination protocol for sub-agent spawning"
   ```
5. **Push and PR**
   ```bash
   git push origin fix/agent-coordination-detail
   ```
6. **Open a Pull Request**

### What to Contribute

- **Fixes:** Typos, broken links, outdated info
- **Improvements:** Better explanations, clearer diagrams
- **New Sections:** Additional use cases, tools, techniques
- **Skills:** New skill documentation
- **Scripts:** Operational scripts that could help others

---

## Style Guide

### Documentation
- Use **Markdown** for all docs
- Keep lines under 100 characters when possible
- Use code blocks with language specified
- Include examples where helpful

### Commits
- Start with type: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`
- Be specific: `fix: correct cron schedule for memory-index-rebuild`
- Reference issues: `fix: resolve #42 (memory leak in FTS indexer)`

### Pull Requests
- Title: Clear, concise summary
- Description: What, why, how
- Link related issues
- Include screenshots for UI changes

---

## Areas Needing Work

- [ ] `SKILLS.md` — Full skill documentation for each skill
- [ ] `docs/CODING_STANDARDS.md` — TDD enforcement rules
- [ ] `docs/SECURITY.md` — API key management, secrets
- [ ] `scripts/` — More automation scripts
- [ ] `docs/TROUBLESHOOTING.md` — Common issues and fixes
- [ ] `docs/TOOLS.md` — Complete tool inventory

---

## Questions?

- Open an issue for bugs/questions
- Reach out via Discord: https://discord.gg/q8kEquTu3z (ClawPlex)
- Twitter: [@tylerdotai](https://twitter.com/tylerdotai)

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
