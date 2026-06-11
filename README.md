# public-skills

A collection of Claude Code skills I've built and found useful enough to share.

Each skill lives in its own directory — a `SKILL.md` plus any supporting files. The directory *is* the skill.

## Skills

- [delegate-implement](delegate-implement/) — Coordinator/implementer duo: Claude writes a tight spec and reviews, a delegated implementer (in-harness subagent or the Codex CLI) does the file-heavy typing, with an independent test gate and diff reconciliation. Ships a portable playbook, a spec scaffold, a Codex wrapper, and a fill-in-the-blanks per-repo overlay template.
- [knowledge-vault](knowledge-vault/) — Interactive setup for a "second brain" markdown vault. Picks a flavor (personal/work/minimal), scaffolds folders and templates, and wires up opt-in maintenance rules.

## Installing a skill

Copy the skill's directory into `~/.claude/skills/` (available in every project) or into a
single repo's `.claude/skills/`. For example:

```bash
cp -r delegate-implement ~/.claude/skills/
```

The skill is picked up on the next Claude Code session.
