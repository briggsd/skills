---
name: delegate-implement
description: Coordinator/implementer duo — Claude writes a tight spec and reviews, a delegated implementer does the file-heavy typing, to keep the coordinator's context lean and the output verified. Two backends — an in-harness Claude subagent (default; pick the model haiku/sonnet/opus to the task) or the Codex CLI (gpt-5-codex, for cross-provider review or autonomous runs). Use when the user wants to offload implementation of a well-scoped task ("delegate this", "use the duo", "have haiku/sonnet/codex do it", "implement #NN with a subagent") and verify it with a test gate.
---

# delegate-implement — Claude coordinates, a delegated implementer types

You (Claude) stay the **coordinator**: spec quality, diff review, independent gating, finding
triage, PR/merge decisions. A **delegated implementer** does the file-heavy exploration and
edits. Goal: **leverage + lean context + verified output** — you read only the spec, the
implementer's summary, and the diff; never its full transcript/stream.

> **Repo overlay:** if a project-level `delegate-implement` skill exists
> (`.claude/skills/delegate-implement/SKILL.md`), read it too — it pins this repo's gate
> command, branch convention, and gotchas. On conflict, the project overlay wins. To create
> one for your repo, copy `project-overlay-template.md` (in this skill) into
> `<your-repo>/.claude/skills/delegate-implement/SKILL.md` and fill in the placeholders.

## Choose a backend

The coordinator discipline below is identical for both. The verdict from head-to-head use:

- **(A) In-harness Claude subagent — DEFAULT.** Spawn via the Agent/Task tool. Lowest friction
  (no external auth/process), and you can inspect its *actual* tool-call transcript, which
  shrinks the confabulation blind spot. Best for the normal implement loop. Pick the model to
  the task (see **Picking the subagent model** below) — `model: sonnet` is the safe default.
- **(B) Codex CLI (`gpt-5-codex`).** A *different provider* — use it as the **independent
  reviewer** on risky changes (decorrelated blind spots beat same-family review), or when you
  need an implementer with its own sandbox/gate-running **outside** a Claude harness. More
  friction (API-key auth, separate process) and it confabulated tests more readily in testing
  — so prefer it for review/autonomy, not as the default implementer.

**The implementer choice is second-order.** What makes either safe is the coordinator
discipline (independent gate + diff reconciliation), not which model typed. Don't drop the
checks for either.

### Picking the subagent model (backend A)

The spec carries the weight, not the model — so a cheaper/faster model is a real option when
the spec is tight and the edit is mechanical. Scale the model to the *judgment* the implementer
still has to exercise after reading the spec, not to the line count.

- **`haiku` (Haiku 4.5) — cheapest/fastest.** Use when the spec leaves little to decide: a clear
  precedent to mirror, exact `file:line` targets, named test infra, and a small edit surface.
  Mechanical plumbing, boilerplate, repetitive renames-with-logic, "mirror PR #NN here." Verify
  the gate + diff as always — Haiku is likelier to stop early or thin out tests if the spec is
  underspecified, so it raises the bar on spec quality rather than lowering it.
- **`sonnet` (Sonnet 4.6) — DEFAULT, the safe middle.** Use when the implementer must still make
  local design calls: choosing where to factor, navigating an unfamiliar subsystem, non-obvious
  test design, or a larger/multi-file surface. This is the right default when unsure.
- **`opus` — rarely.** Only when the task is genuinely hard to *specify* (you can't reduce it to
  a precedent + acceptance criteria) and the implementer's own reasoning is load-bearing. If
  you're reaching for Opus, first ask whether better specing would let Sonnet do it — usually yes.

Cost/latency ladder: `haiku` ≪ `sonnet` < `opus`. **Bias toward the cheapest model the spec can
support**, then let the gate catch the rest. If Haiku stops early or confabulates a test, the
fix is usually a sharper spec (precedent + test infra), then re-run — not an automatic step up
to Sonnet, though stepping up is the fallback when a second tightened spec still doesn't land.

## When to use / not
- **Use** for a well-scoped task you can specify precisely and verify with a test gate.
- **Don't** for conversational answers, trivial one-line edits (just do them), or work you
  can't review/verify.

## The loop

### 1. Scope + branch
One well-scoped task. Create the feature branch yourself (`<convention>/<issue#>-<slug>` — see
overlay); confirm a clean tree first.

### 2. Write the spec — the dominant lever (more than which backend)
Across runs, clean completion correlated with **spec quality**, not implementer identity; the
messy ones (early stops, confabulated tests) correlated with **thin test guidance**. Two
techniques carry most of the weight (copy `spec-template.md`):
1. **Point to a working precedent to mirror.** "The `X` field added in PR #NN is your
   template — find how it's plumbed and mirror it." A concrete example beats prose.
2. **Front-load the TEST infrastructure — the failure locus.** Name the capture fake / fixture
   loader / where-to-assert explicitly; cite a repo test-infra index (e.g. `docs/extending.md`)
   if one exists. Thin test guidance ⇒ skipped tests ⇒ a confabulated "tests added" summary.

Also include: acceptance criteria (verbatim), exact file:line locations, the hard constraints
(gate must pass, strict typing/no-`any`, trust boundaries, "keep the diff focused", "don't
touch X"), the **anti-yield directive** (below), and a "report with real output" section.
Spend coordinator effort here (an Explore pass / the repo extending-doc) — it pays back in
clean completion. **Keep delegations small** — confab risk scales with edit-site count.

### 3. Run the implementer
- **(A) Subagent:** Agent/Task tool, the spec as the prompt, `model:` chosen per **Picking the
  subagent model** above (`haiku` for tight mechanical specs, `sonnet` default, `opus` rarely).
  It returns a final report (its summary) and runs the gate itself. Background or foreground.
- **(B) Codex CLI:** `bash <skill-dir>/run-codex.sh <spec.md> <repo-dir> <out-prefix>` via Bash
  `run_in_background: true`. Produces `<prefix>-last.txt` (summary) + `<prefix>-stream.jsonl`.
  Peek `head -4 <prefix>-stream.jsonl` early to confirm it didn't error on auth/model.

### 4. Known failure modes (mostly backend B, but the detection applies to both)
- **Yield-after-exploration:** ends the turn with **zero edits** (`git status` clean) after a
  "pausing to note…" preamble. Fix: re-run fresh with a forceful "implement to completion"
  prompt. Baking the anti-yield directive in up front prevents it.
- **Confabulated completion (the dangerous one):** finishes the *easy* edits, then claims work
  it never did — most reliably **the tests** — with a **fake gate "tail" (no pass/fail
  counts)**. The empty gate output is the tell it truncated before verify. Risk rises with
  task size + unfamiliar test infra. **Don't re-delegate skipped tests — the implementer will
  skip them again; the coordinator owns them.**
- **Codex `resume`** rejects `-C`/`-s` (read-only) — prefer a fresh `exec`.

### 5. Review (coordinator) — summary + diff ONLY
**Reconcile the summary against `git status --short` / `git diff --stat`: every file claimed
must appear** (a claim with no matching diff is confabulation — most commonly absent `test/`
files). Then verify any load-bearing claim against the actual contracts (grep that the symbol
it used exists). Don't read the full subagent transcript / JSONL stream; don't take the
summary on faith.

### 6. Gate independently
Run the test gate **yourself** — never trust a pasted gate tail. **A passing gate ≠ tests
exist** (an implementer can satisfy it with zero new tests): confirm `git diff --stat` shows
the expected `test/` files and the **test count rose** vs baseline. If untested, write the
tests yourself.

### 7. Triage AI-review findings (if the repo auto-reviews PRs)
Sort each finding **real / hold / defer**. **Real** → fix. **Hold** → the reviewer is wrong
for this codebase (e.g. allowlist that breaks extensibility; a threat model that doesn't apply
to the input's trust level) — state the rationale; your codebase context beats the reviewer's.
**Defer** → pre-existing / premature → file a follow-up issue. **Noise-floor stop rule:**
reviewers are non-deterministic and trend "must-find-something" — fix the real ones, then
**stop**; don't loop review→fix→review chasing the asymptote once the PR is mergeable.

### 8. Commit, PR, merge
Honest author note (tag the backend; e.g. `[codex]` / `[sonnet]`). Gate `main` after each
merge. **Stacked PRs:** if PR B is based on branch A, merging A with `--delete-branch`
**auto-closes B** (and you can't retarget a closed PR) — retarget B onto `main` *before*
merging A (`gh api -X PATCH .../pulls/{B} -f base=main`), or merge A without `--delete-branch`.
**Parallel PRs on shared files conflict** after the first merges — rebase the second onto
`main`, resolve (usually additive), force-push, merge. After a force-push, GitHub lags
re-computing mergeability — retry the merge after a beat.

## Prerequisites
- **Backend B only:** `gpt-5-codex` needs OpenAI **API-key** auth (`codex login status` →
  "API key"); ChatGPT-account auth returns `400 ... not supported`. Back up + switch:
  `cp ~/.codex/auth.json ~/.codex/auth.json.bak-chatgpt`;
  `printenv OPENAI_API_KEY | codex login --with-api-key`.
- Deps installed so the implementer can run the gate offline (sandboxes restrict network).

## Quick-reference gotchas
- **Default backend = in-harness subagent; Codex = cross-provider review / autonomous.**
- **Spec quality > backend choice** — precedent-pointing + front-loaded test-infra.
- **Anti-yield directive** at the top of every spec.
- **Reconcile summary ⇆ `git diff`; gate yourself; confirm test count rose.**
- **Coordinator owns tests** for non-trivial infra; don't re-delegate skipped ones.
- **Stacked-merge order** / **parallel-PR rebase** / **post-force-push merge retry** (step 8).
- **Editing files with embedded control chars:** match a unique tail anchor or rewrite the file.

## Files in this skill
- `spec-template.md` — the implementer brief scaffold (anti-yield + test-infra sections).
- `run-codex.sh` — the Codex (backend B) `codex exec` invocation wrapper.
- `project-overlay-template.md` — fill-in-the-blanks template for a per-repo overlay; copy it
  to `<your-repo>/.claude/skills/delegate-implement/SKILL.md` and pin your gate/branch/gotchas.
