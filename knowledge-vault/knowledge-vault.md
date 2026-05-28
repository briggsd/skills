# knowledge-vault (skill)

**Purpose:** Interactive Claude skill that scaffolds a "second brain" knowledge vault.

## What it does

Walks the user through an interactive setup:
1. Pick flavor (Personal / Work / Minimal)
2. Customize folder list
3. Pick link style (wiki-links vs markdown)
4. Opt in/out of 10 maintenance rules
5. Scaffold the vault + templates

## Structure (inside the `.skill`)

- `SKILL.md` — skill instructions for Claude
- `README.md` — human-facing
- `maintenance-rules.md` — catalog of R1–R10
- `flavors/personal.md`, `work.md`, `minimal.md` — preset defaults
- `templates/` — root CLAUDE.md template + folder templates + note templates

## Install

Install `knowledge-vault.skill` into Claude Code, then invoke the skill and follow the prompts.

## Maintenance rules included (opt-in during setup)

- R1 Cross-linking
- R2 Conflict handling
- R3 Off-the-record protocol
- R4 Substantive session definition
- R5 End-of-session checkpoint
- R6 Archiving
- R7 Search before creating
- R8 Scale cross-session ritual to task
- R9 Productivity plugin deferral (situational)
- R10 Auto-memory integration (situational)

## Future enhancements (ideas)

- Vault audit skill (detect stale content, broken links)
- Vault migration skill (move from wiki-links to markdown or vice versa)
- Daily-note generator that pulls in calendar / tasks
- Promotion to a full plugin if more sub-skills emerge
