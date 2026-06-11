# Maintenance Rules Catalog

This is the canonical list of rules that can be installed into a knowledge vault. Each rule is self-contained and gets copy-pasted into the vault's root `CLAUDE.md` when selected during setup.

When running the skill interactively, read this file and present each rule's **name + one-line description** to the user. Let them opt in or out of each. The `body` field is what gets written into the vault.

---

## R1 — Cross-linking

**One-liner:** Connect related files with `[[wiki-links]]` or `[markdown](paths)` to build a graph, not a stack of docs.

**Body:**
```
## Cross-linking

This vault is a graph, not a stack of isolated docs. Link between related files using {{LINK_STYLE}}.

**When writing any note, cross-link to:**
- Every person mentioned → their People/Team file
- Every project mentioned → its project folder
- Every decision referenced → its decision log entry (if one exists)
- Upstream Context → strategy/marketing/product docs that informed the thinking

**When updating a file, check the reverse direction.** If Project X now involves Person Y, make sure Y's file lists Project X too. Links should be bidirectional whenever practical.

**Don't force links.** If a file genuinely has no related files, don't invent connections.
```

---

## R2 — Conflict handling

**One-liner:** When the vault, auto-memory, and conversation disagree, stop and ask — don't silently pick one.

**Body:**
```
## Conflict handling

The vault is usually right, but not always. When you notice a conflict between (a) what the vault says, (b) what the user says, and (c) what current tool output shows:

1. **Stop and flag it.** Don't silently pick one source.
2. **Once the user resolves it, update the stale source** so the conflict doesn't recur.
3. **If the user isn't reachable:** most recent timestamped source wins, but log the conflict in today's Daily note for later reconciliation.
```

---

## R3 — "Off the record" protocol

**One-liner:** If the user says "don't log this" or "off the record", skip all vault writes for that topic.

**Body:**
```
## "Off the record" protocol

If the user says "off the record", "don't log this", "don't remember this", or similar — skip all vault writes for that topic, skip any auto-memory updates, and skip the Daily session block entry. Honor this even if other rules would normally trigger a write.
```

---

## R4 — Substantive session definition

**One-liner:** Define which sessions trigger logging and state updates, so you don't log every "what time is it" exchange.

**Body:**
```
## What counts as a "substantive session"

Several rules trigger only on substantive sessions. A session is substantive if ANY of these happened:

- You created, edited, or deleted a file in the vault
- A decision was made or a plan changed
- New people, tools, projects, or external references came up
- The user asked you to remember something

Pure Q&A, single lookups, or "what time is it"-style exchanges don't count and don't need logging.
```

---

## R5 — End-of-session checkpoint

**One-liner:** At the end of substantive sessions, update project state files and append a session block to today's Daily note.

**Body:**
```
## End-of-session checkpoint

Before ending any substantive session:
1. Review what changed
2. Update `project_current_state.md` inside the relevant project folder (if one exists)
3. Append a `### Session — HH:MM` block to today's Daily entry with:
   - Focus (one line)
   - What was worked on
   - Decisions made
   - Open items for next time
   - Files touched
```

---

## R6 — Archiving stale content

**One-liner:** Move wound-down projects to archive and tag departed people, instead of leaving clutter.

**Body:**
```
## Archiving stale content

The vault should mirror active work, not accumulate dead weight.

- **Projects:** When a project wraps, move the folder to `Resources/archive/projects/<project-name>/`. Leave a 1-line breadcrumb at the old path if other files still link to it.
- **People:** When a relationship ends or goes dormant, add `**Archived:** YYYY-MM-DD` at the top of their file. Don't delete.
- **Docs:** If superseded, add `**Superseded by:** [[link]]` at the top.
- **Stale info noticed mid-session:** update or remove on the spot.
```

---

## R7 — Search before creating

**One-liner:** Grep the vault for existing notes on a topic before creating a new file — edit instead of duplicating.

**Body:**
```
## Search before creating

Before making a new file on a topic, grep the vault for existing notes on that topic. If a match exists:
- Edit the existing file instead of creating a new one, OR
- At minimum, link the new file back to the existing one

Don't create parallel notes on the same subject. Duplication fragments the graph.
```

---

## R8 — Scale cross-session ritual to task

**One-liner:** Don't read 3 daily notes before every trivial lookup. Match the ritual to the task.

**Body:**
```
## Cross-session continuity

Scale the entry ritual to the task.

**Quick lookup / simple question:** Open the one file that answers it. No ritual.

**Picking up active work on a project:**
1. Read `Projects/<project>/CLAUDE.md`.
2. Read `Projects/<project>/project_current_state.md` (if it exists).
3. Skim the most recent 1–2 Daily notes only if the work is time-sensitive or coordination-heavy.
4. Then act.

**Starting something cross-cutting or strategic:**
1. Scan root `CLAUDE.md` + relevant `Context/` docs.
2. Skim today's Daily note for in-flight threads.
3. Then act.
```

---

## R9 — Productivity plugin deferral (advanced / situational)

**One-liner:** If the user has the `productivity` plugin installed, defer task management to it instead of maintaining a parallel Tasks folder.

**Body:**
```
## Productivity plugin deferral

If the `productivity` plugin is installed and active (check for its `task-management` skill), defer entirely to the plugin's `TASKS.md` workflow — don't write tasks into the vault's `Tasks/` folder. The plugin owns the authoritative task list.

If you notice duplicated task content in both places, flag it and ask the user which is authoritative — don't silently merge.
```

---

## R10 — Auto-memory integration (advanced / situational)

**One-liner:** Tell Claude how the vault relates to a separate auto-memory system, so they don't duplicate.

**Body:**
```
## Auto-memory integration

This vault is the intended source of truth for long-lived context. Any auto-memory system should point *into* the vault rather than duplicate it. Save decisions, state changes, people, tools, and feedback to the appropriate vault folder — not to auto-memory.

Auto-memory's job is to be a lightweight pointer so future sessions know where to look in the vault.
```
