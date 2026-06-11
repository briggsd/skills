# public-skills

A collection of Claude Code skills I've built and found useful enough to share.

Each skill lives in its own directory — a `SKILL.md` plus any supporting files. The directory *is* the skill.

## Skills

- [content-synthesis](content-synthesis/) — Turn consumed content (YouTube, articles, papers, podcasts, or files dropped in `_inbox`) into reusable knowledge. Extracts topics, methodology, and takeaways, then produces tiered output — quick capture, working synthesis, or full artifacts (slides, docs, briefings) — and drives a guided "research open questions" loop.
- [data-room](data-room/) — Build a structured working environment before drafting. Scans source materials and produces a source inventory, conflict log, missing-context list, and duplicates report — the four artifacts that prevent structural hallucinations in serious knowledge work.
- [delegate-implement](delegate-implement/) — Coordinator/implementer duo: Claude writes a tight spec and reviews, a delegated implementer (in-harness subagent or the Codex CLI) does the file-heavy typing, with an independent test gate and diff reconciliation. Ships a portable playbook, a spec scaffold, a Codex wrapper, and a fill-in-the-blanks per-repo overlay template.
- [knowledge-vault](knowledge-vault/) — Interactive setup for a "second brain" markdown vault. Picks a flavor (personal/work/minimal), scaffolds folders and templates, and wires up opt-in maintenance rules.
- [topic-validator](topic-validator/) — Scan a vault topic doc for concept-level redundancy: sections making the same point under different headings, or insights appended rather than woven in. Runs after a topic distillation or on demand for existing docs.

## Installing a skill

Copy the skill's directory into `~/.claude/skills/` (available in every project) or into a
single repo's `.claude/skills/`. For example:

```bash
cp -r delegate-implement ~/.claude/skills/
```

The skill is picked up on the next Claude Code session.
