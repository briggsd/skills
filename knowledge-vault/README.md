# knowledge-vault

An interactive Claude skill that scaffolds a "second brain" knowledge vault — a folder structure with embedded `CLAUDE.md` instructions, templates, and maintenance rules that Claude follows across sessions.

## What it does

Claude walks you through a short interactive setup:

1. **Pick a flavor** — Personal (life admin, family, hobbies), Work (business, team, projects), or Minimal (bare skeleton).
2. **Customize folders** — add or remove from the flavor's default list.
3. **Pick a link style** — Obsidian-style `[[wiki-links]]` or standard markdown links.
4. **Pick maintenance rules** — cross-linking, conflict handling, "off the record" protocol, archiving, session logging, etc. Opt in or out of each.
5. **Scaffold** — folders + per-folder `CLAUDE.md` and `_guide.md` + note templates in `_templates/`.

After setup, every future Claude session reads the root `CLAUDE.md` at the start and maintains the vault per the rules you picked — saving decisions, updating project state, logging sessions, cross-linking as it goes.

## Why you'd want this

Claude on its own starts every conversation cold. This skill gives you a persistent, file-based memory system Claude can read, write, and update. Over weeks and months your vault becomes a real knowledge base — projects, people, decisions, context — that lives across every session.

## Install

Drop the `.skill` file into your Claude Cowork plugins/skills directory, or use the "Save skill" button when someone shares the file with you.

## Invoke

Say any of:
- "Help me set up a knowledge vault"
- "Build me a second brain"
- "I want a CLAUDE.md system"
- "Set up a context vault"

## Maintenance

Re-invoke the skill on an existing vault to audit for stale content, add a new folder, migrate link styles, or regenerate templates.

## What's in this skill

```
knowledge-vault/
  SKILL.md              # skill instructions for Claude
  README.md             # this file (human-facing)
  maintenance-rules.md  # catalog of opt-in rules
  flavors/
    personal.md         # personal-use defaults
    work.md             # work-use defaults
    minimal.md          # bare-skeleton defaults
  templates/
    root-claude.md      # template for the vault's root CLAUDE.md
    folder-claude.md    # generic per-folder CLAUDE.md
    folder-guide.md     # generic per-folder _guide.md
    _templates/         # note templates (daily-note, project, person, etc.)
```

## Credit

Built from a working knowledge-vault setup, generalized for sharing.
