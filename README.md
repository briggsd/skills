# public-skills

A collection of Claude Code skills I've built or adapted from others and found useful enough to share. Skills sourced elsewhere are attributed in the list below.

Each skill lives in its own directory — a `SKILL.md` plus any supporting files. The directory *is* the skill.

## Skills

- [codebase-design](codebase-design/) — Shared vocabulary for designing deep modules: module, interface, depth, seam, adapter, leverage, locality, plus principles like the deletion test and "the interface is the test surface." Includes a design-it-twice parallel sub-agent pattern for exploring alternative interfaces. The vocabulary base the other engineering skills draw on. *(from [mattpocock/skills](https://github.com/mattpocock/skills))*
- [content-synthesis](content-synthesis/) — Turn consumed content (YouTube, articles, papers, podcasts, or files dropped in `_inbox`) into reusable knowledge. Extracts topics, methodology, and takeaways, then produces tiered output — quick capture, working synthesis, or full artifacts (slides, docs, briefings) — and drives a guided "research open questions" loop.
- [data-room](data-room/) — Build a structured working environment before drafting. Scans source materials and produces a source inventory, conflict log, missing-context list, and duplicates report — the four artifacts that prevent structural hallucinations in serious knowledge work.
- [delegate-implement](delegate-implement/) — Coordinator/implementer duo: Claude writes a tight spec and reviews, a delegated implementer (in-harness subagent — pick haiku/sonnet/opus to the task — or the Codex CLI) does the file-heavy typing, with an independent test gate and diff reconciliation. Ships a portable playbook, a spec scaffold, a Codex wrapper, and a fill-in-the-blanks per-repo overlay template.
- [diagnosing-bugs](diagnosing-bugs/) — A diagnosis discipline for hard bugs and performance regressions, built around constructing a tight pass/fail feedback loop before hypothesizing. Triggered by "diagnose"/"debug this" or reports of something broken or slow. Ships a human-in-the-loop bisection loop template. *(from [mattpocock/skills](https://github.com/mattpocock/skills))*
- [domain-modeling](domain-modeling/) — Build and sharpen a project's domain model: pin down ubiquitous-language terms in a `CONTEXT.md` and record architectural decisions as ADRs. Includes context and ADR format references. *(from [mattpocock/skills](https://github.com/mattpocock/skills))*
- [grill-me](grill-me/) — Interview the user relentlessly about a plan or design until reaching shared understanding, walking each branch of the decision tree one question at a time (with a recommended answer each), and exploring the codebase to self-answer where it can. Use to stress-test a plan before building. *(from [mattpocock/skills](https://github.com/mattpocock/skills))*
- [handoff](handoff/) — Compact the current conversation into a handoff document (saved to the OS temp dir) so a fresh agent can pick up the work, including a "suggested skills" section and references to existing artifacts rather than duplicated content. *(from [mattpocock/skills](https://github.com/mattpocock/skills))*
- [improve-codebase-architecture](improve-codebase-architecture/) — Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick. Uses the `codebase-design` vocabulary and keeps the `domain-modeling` docs current as decisions land. Includes an HTML report format reference. *(from [mattpocock/skills](https://github.com/mattpocock/skills))*
- [knowledge-vault](knowledge-vault/) — Interactive setup for a "second brain" markdown vault. Picks a flavor (personal/work/minimal), scaffolds folders and templates, and wires up opt-in maintenance rules.
- [topic-validator](topic-validator/) — Scan a vault topic doc for concept-level redundancy: sections making the same point under different headings, or insights appended rather than woven in. Runs after a topic distillation or on demand for existing docs.
- [writing-great-skills](writing-great-skills/) — Reference for writing and editing skills well: the vocabulary and principles that make a skill predictable, plus a glossary covering steps, completion criteria, premature completion, and the user-invoked vs. model-invoked tradeoff. Handy when authoring skills for this repo. *(from [mattpocock/skills](https://github.com/mattpocock/skills))*

## Installing a skill

Copy the skill's directory into `~/.claude/skills/` (available in every project) or into a
single repo's `.claude/skills/`. For example:

```bash
cp -r delegate-implement ~/.claude/skills/
```

The skill is picked up on the next Claude Code session.
