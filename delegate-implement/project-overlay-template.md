---
name: delegate-implement
description: Coordinator/implementer duo tuned for <PROJECT NAME> — Claude writes a tight spec and reviews, a delegated implementer (in-harness subagent by default, or the Codex gpt-5-codex CLI for cross-provider review / autonomous runs) does the typing. Review the diff, run `<GATE COMMAND>`, triage any auto-review findings, open/merge a PR. Use when delegating an issue/slice here ("use the duo", "have codex/sonnet do it", "delegate #NN").
---

# delegate-implement (<PROJECT NAME> overlay)

> **This is a template.** Copy it to `<your-repo>/.claude/skills/delegate-implement/SKILL.md`
> and replace every `<…>` placeholder with your repo's real values. Delete any section that
> doesn't apply, and add repo-specific gotchas as you discover them. Keep it short — this file
> *overrides* the portable playbook with concrete values; it doesn't restate the narrative.

This repo's pins for the **delegate-implement** workflow. The **full portable playbook** lives
in the installed skill (the two backends, the loop, failure modes, review-triage rubric,
stacked-PR mechanics) — read it for the narrative. This file overrides it with concrete repo
values. The shared `run-codex.sh` (Codex backend) and `spec-template.md` ship with that skill.

## Backend default here
In-harness **subagent** is the default implementer (lower friction, inspectable transcript).
Use **Codex (`gpt-5-codex`)** for an independent cross-provider review pass on risky changes,
or autonomous runs. Either way the coordinator gate + diff-reconciliation is mandatory.
<Note here if this repo has a non-deterministic auto-reviewer or a history of confabulation.>

## Repo pins
- **Gate (run yourself, every iteration):** `<GATE COMMAND, e.g. bun run check / npm test / make ci>`.
  <Static-analysis rules to respect, e.g. strict TS / no `any` / lint config.>
- **Runtime:** `<runtime + version, e.g. Bun >=1.3.0, no build step>`. Confirm deps are
  installed (`<node_modules / .venv / vendor>`) before launching the implementer.
- **Branch convention:** `<convention, e.g. <backend>/<issue#>-<short-slug>>`.
- **Commit footer (if required):** `<footer line>`. Tag the subject by backend
  (`[codex]` / `[sonnet]`); plain when the coordinator applied a fix.
- **PR label / metadata:** `<label or convention, e.g. note the backend in the PR body>`.
- **Tests** live in `<test dir>` (`<framework>`); fixtures in `<fixtures dir>`. Keep fake/no-network.
- **Test-infra index:** `<path to the doc, e.g. docs/extending.md>` is the capture-fake / fixture /
  where-to-assert reference — **cite it in every spec** (the #1 lever for clean completion).
  Delete this bullet if your repo has no such doc.

## Trust & safety to put in every spec (load-bearing)
<List the non-negotiable constraints unique to this repo that every implementer must honor.
Examples — keep only what applies:>
- <Telemetry/logging: what may and may not be recorded (counts/metadata only? no secrets?).>
- <Untrusted-input handling: what is untrusted, where it must be sanitized, the trusted source.>
- <Security gates that must never be weakened (auth, fork-safety, default-off flags).>

## Repo-specific gotchas
<Concrete traps that have bitten delegated runs here. Examples:>
- <Tooling quirks, e.g. a `gh`/CI command that errors and the workaround.>
- <Auto-review behavior: does this repo review its own PRs? how long? recurring false-positive
  patterns to hold the line on.>
- <Auth/setup notes, e.g. Codex API-key auth location and how to restore it afterward.>
- <Commit hygiene, e.g. "don't `git add -A` — it sweeps in <file>".>

## Planning & handoff
<How work is tracked here, e.g.: plan lives in `<roadmap file>`; status lives in GitHub issues;
each actionable slice = one issue. Update `<handoff file, e.g. continue.md>` before you stop.>
Delete this section if it doesn't apply.
