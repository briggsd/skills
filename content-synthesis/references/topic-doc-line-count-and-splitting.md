# Topic-doc line counts, the 200-line flag, and when to split

Practical notes for the topic-validator's 200-line threshold (Step 5b) and split decisions.

## `wc -l` measures paragraphs, not prose length

Vault topic docs use **one-paragraph-per-line markdown** (each paragraph is a single physical
line that wraps in display). Therefore:

- `wc -l` counts hard newlines = headings + paragraph blocks + blank lines, **not** rendered/prose length.
- **Prose-tightening within a paragraph does NOT lower `wc -l`.** Compressing a wordy paragraph
  reduces `wc -w` / `wc -c` (real verbosity) but leaves the line count unchanged.
- The only way to drop `wc -l` is to remove whole lines: delete a section, merge paragraphs, or
  split the doc.

Implication: if the user wants the "200-line flag" number itself to clear, a tightening pass
won't do it — only a structural split (removing whole sections) will. Say this explicitly rather
than reporting "tightened" and leaving them to wonder why the count didn't move. Report both
`wc -l` (unchanged) and `wc -w`/`wc -c` (down) so the effect is visible.

## The 200-line flag is "look at it," not "split it"

Having looked, the real split test is: **are there 2+ independently-coherent topics a reader
would navigate separately, that split cleanly without severing load-bearing cross-references?**

Reasons NOT to split even when over 200 lines (both seen in practice):

- **Comparison tables are the synthesis.** If sections A and B exist mainly to contrast against
  section C (e.g. corpus-level + holdout-gate vs. the Karpathy loop, via side-by-side tables),
  splitting either duplicates C's summary into the new doc or destroys the contrast. Keep whole.
- **No clean fracture.** If the doc would split into thirds that each lean on the others
  (substrate/orchestration/tooling), there's no seam — leave it.

When a split IS warranted, identify the **most self-contained sub-cluster** as the seam, and
defer until it earns its own doc (rule of thumb: 2-3 more captures landing in that cluster).
Leave a one-paragraph stub + cross-link behind in the parent. Pre-staging a split before the
cluster has mass just creates a thin orphan doc.
