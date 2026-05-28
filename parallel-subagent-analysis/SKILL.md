---
name: parallel-subagent-analysis
description: >
  Fan out a repeated analysis task across multiple inputs using parallel claude CLI
  sub-agents, then synthesize their outputs. Use when you need to run the same
  analysis (validation, audit, review, extraction) against N files and want results
  fast without serializing. Triggers on "run this on all the docs", "validate all
  topics", "audit these files in parallel", "fan out to sub-agents", or any task
  where the same self-contained prompt applies to multiple inputs independently.
---

# Parallel Sub-Agent Analysis

Run the same analysis across N inputs simultaneously using `claude` CLI sub-agents,
then synthesize their findings into a single actionable report.

## When to Use

- The same prompt applies to every input independently (no cross-input reasoning needed)
- Inputs are self-contained files or text chunks
- Serial execution would be slow or tedious
- You want findings synthesized into one report, not N separate ones

**Not for:** tasks where sub-agents need each other's output or shared session state.

## Choosing a Sub-Agent Backend

Two CLIs are available, with meaningfully different properties:

| | `claude -p "prompt"` | `codex exec "prompt"` |
|---|---|---|
| Tools / shell access | ✗ — pure LLM, stdout only | ✓ — full agentic, can read files, run commands |
| Prompt must be self-contained | ✓ — embed everything | ✗ — can point at paths, let it read |
| Model family | Claude (Anthropic) | OpenAI (o3, o4-mini, etc.) |
| Good for | Pure reasoning / analysis tasks | Tasks needing file nav, edits, or shell commands |
| Safety | Higher — no side effects | Lower — can write files; use sandbox flags if needed |

**Rule of thumb:**
- Content fits in a prompt string → `claude -p` (simpler, faster, no side-effect risk)
- Sub-agent needs to navigate a repo, run tests, or produce file edits → `codex exec`
- Want a second model family's perspective on the same task → use both and compare

## The Pattern

### 1. Build a self-contained prompt

Sub-agents start cold — no shared context, no tools, stdout only. Everything they need
must be in the prompt string:

```
PROMPT="You are a [role]. Your job is to [task].

Here is the full [rubric/criteria/instructions]:
---
[paste full rubric here — don't reference external files]
---

Now [task] this input. Follow the output format exactly.

INPUT: [filename or label]

[paste full file content here]"
```

Key: the prompt must be fully self-sufficient. If the sub-agent would need to read a
file, ask a question, or call a tool — collapse that into the prompt string first.

### 2. Fan out in parallel

```bash
# With claude -p (self-contained prompt, no tools)
claude -p "$PROMPT1" > /tmp/out-file1.txt 2>&1 &
claude -p "$PROMPT2" > /tmp/out-file2.txt 2>&1 &
wait; echo "All done."

# With codex exec (agentic — can read files, run commands)
codex exec "$PROMPT1" > /tmp/out-file1.txt 2>&1 &
codex exec "$PROMPT2" > /tmp/out-file2.txt 2>&1 &
wait; echo "All done."
```

Use `/tmp/out-<label>.txt` naming so outputs are easy to collect. The `&` + `wait`
pattern is identical regardless of backend.

### 3. Collect and synthesize

```bash
echo "=== file1 ===" && cat /tmp/out-file1.txt
echo "=== file2 ===" && cat /tmp/out-file2.txt
# ...
```

Read all outputs, then synthesize:
- Group findings by severity / type across all inputs
- Surface patterns that appear in multiple outputs
- Prioritize: what needs action now vs. later vs. no action
- Note any sub-agent that errored or returned unexpected output

## Practical Notes

- **Prompt size matters.** Each sub-agent call includes the full rubric + full doc.
  For large rubrics + large docs, watch for context limits. Test with one before
  fanning out to N.
- **Timeouts.** `wait` blocks indefinitely. For large batches add a timeout wrapper
  or check PIDs manually if a run seems stuck.
- **Errors land in stdout too** (via `2>&1`). If output looks garbled, check whether
  the sub-agent errored rather than produced a bad analysis.
- **Output format discipline.** Ask sub-agents to follow a strict output format —
  structured headings, labeled sections. Makes synthesis dramatically easier.
- **Batch size.** No hard limit, but >10 parallel calls can saturate API rate limits.
  For large batches, consider two waves.

## Worked Example — Topic Validator across vault docs

```bash
RUBRIC=$(cat ~/.pi/skills/topic-validator/SKILL.md)

for DOC_PATH in ~/vault/Intelligence/topics/*.md; do
  LABEL=$(basename "$DOC_PATH")
  CONTENT=$(cat "$DOC_PATH")

  PROMPT="You are a topic validator scanning for concept-level redundancy.

Full rubric:
---
$RUBRIC
---

Validate this doc. Follow the output format from the rubric exactly.

DOC: $LABEL

$CONTENT"

  claude -p "$PROMPT" > "/tmp/validator-$LABEL" 2>&1 &
  echo "Launched: $LABEL (PID $!)"
done

wait
echo "All done."
```

Then collect:
```bash
for f in /tmp/validator-*.md; do
  echo "========== $(basename $f) =========="
  cat "$f"
  echo ""
done
```

## Synthesis Checklist

After collecting all outputs:
- [ ] Any high-confidence findings? → action queue
- [ ] Medium-confidence findings? → review queue
- [ ] Any docs over the length threshold? → split candidates
- [ ] Patterns appearing across multiple docs? → systemic issue, not just one-off
- [ ] Any sub-agent outputs that look wrong / errored? → re-run those individually
