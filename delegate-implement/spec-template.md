# Task: <one-line task title + issue ref>

You are implementing one well-scoped slice in <project name> (<stack: e.g. Bun +
TypeScript, ESNext, type: module, no build step>). Read the repo's agent-onboarding doc
(e.g. CLAUDE.md / AGENTS.md / README) first for conventions, then implement the acceptance
criteria below.

## CRITICAL — do not stop after exploration

Do NOT pause, summarize, or yield until the task is fully implemented AND the test gate
passes. Make every edit, add tests, run the gate, fix failures, then stop. Yielding after
only exploring (with zero file changes) is a failure — implement end-to-end in this run.

## Acceptance criteria

<paste the issue's acceptance criteria verbatim; number them>
1. ...
2. ...

## Where to look (known locations + precedent to mirror)

<list the exact files/functions involved, and — most valuable — a WORKING PRECEDENT to copy:
"the X feature added in PR #NN is your template; find how it's plumbed and mirror it." A
concrete example beats prose. e.g. "the X event is built in src/.../foo.ts → buildX() ~LNN.">

## Test infrastructure (how to test this — the hard part, do not skip)

<name the exact test harness so the implementer doesn't rediscover it: which capture fake /
fixture loader / where to assert. e.g. "assert prompts via FakePiProcessRunner.calls[].prompt
(test/foo.test.ts); load fixtures with loadFixture(...); module-private funcs -> test
end-to-end, don't export." If the repo has a test-infra index (e.g. docs/extending.md), cite
it. Thin guidance here is the #1 cause of skipped/confabulated tests.>

## Hard constraints (do NOT violate)

- **The test gate must pass** (`<gate command, e.g. bun run check>`). Run it yourself before
  finishing and paste the tail of its output.
- Strict typing rules: <e.g. noUncheckedIndexedAccess, exactOptionalPropertyTypes,
  verbatimModuleSyntax; no `any`>.
- Trust/safety boundaries: <e.g. counts/metadata only in telemetry; untrusted input
  sanitized; no secrets in X>.
- No change to <the hot path / unrelated areas>. Keep the diff focused on this task.
- Do NOT touch <files to leave alone>. Do NOT do unrelated refactors.
- Match the surrounding code style (naming, comment density, idiom).
- Add/extend tests in <test dir>; keep them fake/no-network.

## Out of scope (do NOT build)

<adjacent issues / future phases that must not be pulled in>

## When done — report precisely (with REAL command output)

Before reporting, RUN and paste the ACTUAL output of: `git status --short`, `git diff --stat`,
and the full test-gate tail (with pass/fail counts). **Do not describe any change you cannot
point to in `git diff`** — a coordinator reconciles your summary against the diff, and a
claimed-but-absent change (especially tests) is a failure. If you could not finish a
criterion (commonly: the tests), SAY SO explicitly rather than claiming it done.

Then: (1) files changed and why; (2) non-obvious design choices + where shared helpers live;
(3) how the tests exercise the change (and confirm `test/` files appear in `git diff --stat`);
(4) anything you could NOT satisfy and why. Be precise; do not overstate completion.
