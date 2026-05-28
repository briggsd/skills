---
name: topic-validator
description: >
  Scan a vault topic doc for concept-level redundancy — sections that make the same point
  under different headings, or insights that got appended rather than woven in. Runs after
  every topic distillation (Step 5b in content-synthesis) and on demand for existing docs.
  Use when asked to "validate this topic", "check for redundancy in [topic]", "audit the
  topic doc", or automatically after distilling a capture into a topic doc.
---

# Topic Validator

Detect concept-level drift in vault topic docs before it compounds.

## The Problem

Topic docs are designed to synthesize across sources — not accumulate them. But as captures
are distilled in over time, the same concept can quietly appear under multiple headings:
once from an early capture, again from a later one with slightly different framing. Each
addition looks correct in isolation. The doc grows incoherent by accretion.

The validator catches this by reading the entire topic doc and identifying `###` sections
that are making the same point at concept level — not just sounding similar, but actually
covering the same territory that a reader would need to visit twice to get the full picture.

## Two Modes

**Inline (Step 5b in content-synthesis):** Runs automatically after a topic is updated
during distillation. Validates only the doc(s) that were just modified. Surfaces findings
before Step 6 (Confirm) so issues can be fixed while context is warm.

**Standalone:** Triggered manually — "validate agent-design.md" or "validate all topics".
Useful for auditing existing docs that predate the validator.

## Process

### 1. Read the topic doc in full

Load the complete file. Do not skim — concept-level redundancy often spans sections that
are far apart in the doc.

### 2. Extract and list all `###` concept sections

Build an internal map: section heading → key claims made in that section. One line per
claim is enough; you're building a comparison surface, not a summary.

### 3. Compare sections for concept-level overlap

For each pair of sections, ask: **if a reader needed to understand concept X, would they
get it from section A, section B, or both?** If the answer is "both cover this", that's
a redundancy candidate.

Distinguish carefully:
- **True redundancy** — the same principle stated twice. One section can be removed or
  folded into the other without losing anything.
- **Complementary coverage** — one section motivates the concept (the "why"), another
  implements it (the "how"). These look similar but are not redundant. Flag with lower
  confidence.
- **Same concept, different domain** — RPI workflow (coding) and data room pattern
  (knowledge work) share an upstream principle but apply it differently. Not redundant —
  but worth a cross-reference note.

### 4. Report findings

Only report genuine candidates — don't flag every pair that touches related topics.

**Output format:**

```
## Concept Redundancy Report — {topic-name}.md

### High confidence (consolidate)
- **"{Section A}"** and **"{Section B}"** — both establish [the shared claim].
  Section A covers [angle]; Section B covers [angle]. The [specific claim] appears
  in both at lines ~X and ~Y.
  → Recommend: fold [Section B's unique content] into [Section A], remove Section B.

### Medium confidence (review)
- **"{Section A}"** and **"{Section B}"** — share the [concept] but [distinction].
  → Recommend: add a one-liner in Section A pointing to Section B, or merge the
    overlapping passage.

### No action needed
Everything else is distinct. [Optional: note if the doc is approaching the ~200 line
warning threshold.]
```

If there are no candidates, say so in one sentence and stop: "No concept-level redundancy
detected."

### 5. Fix if approved

If the user approves a consolidation:
1. Read both sections in full
2. Merge: keep the stronger framing, fold in any unique claims from the weaker section,
   remove the duplicate passage
3. Update any cross-links that referenced the removed section heading
4. Re-run the validator on the updated doc to confirm the fix didn't introduce new drift

## Decision Rubric

| Finding | Action |
|---|---|
| Same claim, same domain, nothing unique in either section | Consolidate — fold unique bits, remove one |
| Same principle, one motivates / one implements | Keep both, add cross-reference sentence |
| Same concept, different domain or application | Keep both, note shared upstream principle |
| Similar names but genuinely different territory | No action, note distinction explicitly |

## Thresholds

- Flag any doc over **200 lines** as approaching the split-into-subtopics threshold,
  even if no redundancy is found.
- Only report pairs where the overlap is **specific and quotable** — not "these feel
  similar." If you can't name the exact shared claim, it's not a genuine finding.

## What Not to Flag

- Sources section duplication (the same source listed multiple times is expected and fine)
- Open Questions that appear in multiple topic docs (questions are not claims)
- Related concepts that share vocabulary but make different points
- Intentional repetition where a concept is stated briefly in one section and elaborated
  in another (this is cross-referencing, not redundancy)
