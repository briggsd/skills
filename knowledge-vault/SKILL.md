---
name: knowledge-vault
description: Interactively scaffold a Claude-native "second brain" knowledge vault — a folder structure with embedded CLAUDE.md instructions, templates, and maintenance rules that Claude follows across sessions. Triggers on "knowledge vault", "second brain", "set up CLAUDE.md system", "personal knowledge base", "memory hub", "context engineering vault".
---

# knowledge-vault

This skill walks the user through setting up a persistent knowledge vault that Claude reads and maintains across sessions. The vault acts as a "second brain" — Claude's source of truth for long-lived context about the user's work, projects, people, and decisions.

## When to invoke this skill

Invoke when the user says anything like:
- "help me set up a knowledge vault"
- "build me a second brain"
- "I want a CLAUDE.md system"
- "create a personal knowledge base"
- "set up a memory hub / context vault"

## What to do when invoked

Run the interactive setup below. **Do not scaffold anything until the user has answered every question.** Adapt the questions to the conversation — if the user has already answered something (e.g., they told you it's for personal use), skip that question.

### Step 1 — Confirm the target folder

Ask the user which folder to scaffold into. Accept an absolute path. If they haven't selected a folder yet, prompt them to select or create one. Verify the folder is empty or near-empty before scaffolding — if it has content, confirm they want to add vault files alongside it.

### Step 2 — Pick a flavor

Ask: **"Is this for personal use or work use?"**

Flavors live in `flavors/`:
- **Personal** (`flavors/personal.md`) — folders tilted toward life admin, family/friends, hobbies. Relaxed PII rules so you can store phone numbers, addresses, birthdays for loved ones.
- **Work** (`flavors/work.md`) — folders for a business/team context. Strict PII rules — work contact info only for team members.
- **Minimal** (`flavors/minimal.md`) — bare skeleton: Daily, Projects, Notes, Resources, _templates. Add more as you grow.

Read the chosen flavor file — it defines the default folder list and any flavor-specific overrides.

### Step 3 — Customize the folder list

Show the flavor's default folder list to the user and ask:
- "Want to remove any?"
- "Want to add any?"

Common add-ons you can suggest: Goals, Journal, Reading, Meals, Workouts, Media, Travel, Invoices, Clients.

### Step 4 — Link style

Ask: **"Obsidian-style `[[wiki-links]]` or standard markdown `[text](path)` links?"**

- Wiki-links only work if the user has an Obsidian-compatible renderer. Flag this.
- If the user isn't sure, ask what tool they plan to view the vault in. Default to wiki-links if they mention Obsidian, Logseq, or Foam; default to standard markdown otherwise.

### Step 5 — Pick maintenance rules

Read `maintenance-rules.md` — it's a catalog of optional rules. Present each rule with its one-line description and ask the user which to include. Default selection (recommended for most users):

- R1: Cross-linking (required if using wiki-links, optional otherwise)
- R2: Conflict handling
- R3: "Off the record" protocol
- R4: Substantive session definition
- R5: End-of-session checkpoint
- R6: Archiving rules
- R7: Search-before-creating
- R8: Scale cross-session ritual to task

Advanced / situational (ask about these):
- R9: Productivity plugin deferral (only if user uses the `productivity` Claude plugin)
- R10: Auto-memory integration (only if user has an auto-memory system active)

### Step 6 — Scaffold

Once all questions are answered:

1. Create the top-level folder structure in the target location
2. Write the root `CLAUDE.md` from `templates/root-claude.md`, substituting:
   - `{{FLAVOR}}` — the chosen flavor name
   - `{{FOLDER_MAP}}` — generated from the final folder list
   - `{{LINK_STYLE}}` — chosen link style + example
   - `{{MAINTENANCE_RULES}}` — concatenated rule blocks from `maintenance-rules.md` for the selected rules
3. In each top-level folder, write a `CLAUDE.md` and `_guide.md` based on `templates/folder-claude.md` and `templates/folder-guide.md`, using folder-specific content from the flavor file where available
4. Copy all files from `templates/_templates/` into the vault's `_templates/` folder, adapting them to the chosen link style
5. Create today's Daily note (if Daily folder exists) as a working example, with a first session block logging the scaffold

### Step 7 — Confirm and show next steps

After scaffolding, summarize:
- What was created (folder count, templates installed, rules baked in)
- The four things the user should do next:
  1. Open the root `CLAUDE.md` and skim it
  2. Add the first person or project to test the flow
  3. Check back in a week and prune anything unused
  4. Share the skill with teammates if they'd benefit

## Maintenance mode

If invoked when a vault already exists (detect by finding a root `CLAUDE.md` with this skill's signature), switch to maintenance actions instead of scaffolding:
- Audit the vault for stale content
- Add a new folder or rule
- Regenerate templates
- Migrate to a different link style

Ask the user what they need.

## Important rules for Claude

- **Don't assume** — always ask the interactive questions, even if the user seems eager. The value of this skill is the thoughtful setup.
- **Don't scaffold over existing content** without explicit confirmation.
- **Preserve user customizations** on re-invocation — if the user has edited their root CLAUDE.md, don't overwrite it.
- **The rules in `maintenance-rules.md` are the canonical source** — if the user asks "what rules should my vault have", refer them there, don't invent new ones on the spot.
