---
name: data-room
description: >
  Build a structured working environment (data room) before any drafting or synthesis begins.
  Scans source materials, produces a source inventory, conflict log, missing context list, and
  duplicates report — the four artifacts that prevent structural hallucinations in serious
  knowledge work. Use when asked to "build a data room", "set up a project room", "organize
  my sources before we write", "inventory my files", or at the start of any complex
  deliverable involving multiple source documents. Also triggers on "data room", "source
  inventory", "before we draft", or "RPI research phase".
---

# Data Room Skill

Build the working environment before the work. The first prompt is never "do the thing."

## Mental Model

When an agent is handed a mess of source material and asked to produce a final artifact, it
does two jobs at once: figure out what the material is, and produce something from it. That
dual-job condition is where hallucinations emerge — the agent fills gaps by inventing, and
the prose reads confidently. You cannot patch this with a sharper prompt.

The fix is upstream: build a bounded, organized workspace first. Once the data room exists,
the drafting prompt becomes very short — because the agent already knows what the project
consists of and which sources are authoritative.

## Trigger Patterns

- "Build a data room for [project]"
- "Set up a project room"
- "Organize my sources before we write/draft/analyze"
- "Inventory my files for [deliverable]"
- "Research phase" / "RPI research step"
- Start of any complex deliverable where multiple source files are involved

## Workflow

### Step 1: Gather Context

Ask the user (concisely — one question block, not a lengthy interview):
- **What's the job?** One sentence describing the final deliverable.
- **Where are the sources?** Local path(s), URLs, files to upload, or connected tools to check.
- **Where should the data room live?** Default: `~/data-rooms/{project-slug}/` unless specified.

If the user has already provided this context in their request, skip the question and proceed.

### Step 2: Create Folder Structure

```
{data-room-path}/
├── inventory.md        ← source of truth for what's in the room
├── conflicts.md        ← disagreements between sources
├── missing.md          ← what's absent that the agent would invent around
├── duplicates/         ← suspected duplicate files, for human review
│   └── README.md       ← explains what's here and why
└── sources/            ← symlinks or copies of the actual source material (if needed)
```

Create this structure before scanning anything. Preserving originals is non-negotiable —
never modify source files.

### Step 3: Scan Sources

Walk the source path(s). For each file:
- Read or fetch the content
- Identify: file type, date (modified or created), apparent authority/purpose
- Note: is this current, superseded, or unknown?
- Summarize: what claims does it support? What are its limitations?

For URLs: fetch and summarize. For connected tools: query and summarize results.

Do not synthesize or draft anything during this step. Only observe and record.

### Step 4: Produce the Four Artifacts

#### inventory.md

The most important artifact. A table where every row is one source.

```markdown
# Source Inventory

| File / Source | Type | Date | Authority | Status | Claims Supported | Limitations | Usage |
|---|---|---|---|---|---|---|---|
| path/to/file.pdf | PDF | 2026-03 | High — approved final | Current | Q1 numbers, exec summary | No appendix data | Primary for financials |
| path/to/draft-v2.docx | Word | 2026-02 | Medium — working draft | Superseded by v3 | Background only | Stale assumptions | Background reference |
```

**Authority levels:** High (approved/official), Medium (working/draft), Low (informal/unknown)
**Status values:** Current, Superseded, Unknown

After the table, add a prose paragraph: "Based on this inventory, the agent's working
understanding of the project is: [summary]. The authoritative sources for [key claims] are
[sources]."

This paragraph makes the agent's judgment visible and legible before drafting begins.

#### conflicts.md

Explicit disagreements found between sources. Only real conflicts — not just differences
in emphasis or scope.

```markdown
# Conflict Log

## [Conflict 1 — short title]
**Sources in conflict:** [File A] vs [File B]
**The disagreement:** [File A] states X; [File B] states Y.
**Recommended resolution:** [which to trust and why, or "needs human input"]

## [Conflict 2 — short title]
...
```

If no conflicts: write "No conflicts detected." and stop. Do not invent conflicts.

#### missing.md

What the agent doesn't have that it would need to do the job well — and would otherwise
invent around.

```markdown
# Missing Context

## Critical (would significantly affect the output)
- [What's missing and why it matters]

## Important (would improve confidence)
- [What's missing and why it matters]

## Minor (nice to have)
- [What's missing and why it matters]
```

Be specific. "The current version of the operating plan" is useful. "More context" is not.

#### duplicates/README.md

A report of suspected duplicates found in the source set.

```markdown
# Suspected Duplicates

The agent found, named them, and moved them here. **You decide** which is authoritative.
Do not let the agent silently resolve these — the choice affects what claims the final
output can make.

## Version Family: [Name]
- `original-location/file-v1.pdf` — [date, why suspected duplicate]
- `original-location/file-v2.pdf` — [date, why suspected duplicate — likely supersedes v1]
- **Recommended:** treat v2 as current unless [condition]

## Version Family: [Name]
...
```

Move (do not delete) suspected duplicates into `duplicates/` for human review.

### Step 5: Present and Gate

Show the user:
1. The inventory table (inline in the response)
2. Any conflicts (summarized — full detail in conflicts.md)
3. Any critical missing items
4. Any duplicate families

Then **stop and wait**. Do not proceed to drafting. Say explicitly:

> "The data room is ready. Review the inventory above and let me know:
> - Any corrections to authority or status
> - Which source wins for any flagged conflicts
> - Whether any critical missing items can be supplied
>
> Once you're satisfied with the inventory, tell me what to draft and I'll proceed."

### Step 6: Draft (only after approval)

Once the user has reviewed and approved the inventory, the drafting prompt becomes short:

> "Use the reviewed source inventory. Treat [Source A] as authoritative for [topic],
> [Source B] as background only. Draft [deliverable]. Cite claims. Flag anything
> not supported by the inventory."

Do not re-scan or re-inventory. The room is already built.

## Artifact Formats

### inventory.md frontmatter

```markdown
---
project: "[project name]"
created: YYYY-MM-DD
deliverable: "[what we're building]"
sources-scanned: N
status: ready-for-review | approved | draft-in-progress
---
```

Update `status` to `approved` once the user signs off, and to `draft-in-progress` once
drafting begins.

## Edge Cases

- **No conflicts found:** write "No conflicts detected." in conflicts.md — still create the file
- **No duplicates:** skip the duplicates/ folder entirely
- **Single source:** still produce inventory.md — even one source needs its authority and limitations documented
- **Source is paywalled / inaccessible:** note in inventory.md as "Could not access — [reason]" and add to missing.md as Critical
- **User asks to draft before reviewing:** remind them the inventory review is the gate. "The data room is ready but hasn't been reviewed yet — take a look at the inventory first and let me know if the source authorities look right."
- **Very large source set (10+ files):** summarize in groups by type/date before building the full table. Flag if the scan is taking long and offer to proceed with what's been found so far.

## Relation to Other Skills

- **content-synthesis:** the data room is the Research phase of that skill made explicit. If a content-synthesis session starts with multiple sources, consider running this skill first.
- **topic-validator:** run after any topic doc update to catch concept-level drift. The data room catches source-level issues before drafting; the validator catches synthesis-level issues after.
- **RPI workflow (agent-design topic):** the data room IS the Research phase of RPI — the difference is that this skill makes it explicit, reusable, and folder-based rather than implicit.
