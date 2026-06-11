# Extraction & Edit Gotchas

Hard-won fixes for running the content-synthesis pipeline. Check here when a script or an edit fails.

## YouTube transcript script must run under `uv run`

`scripts/get_transcript.py` declares its dependency (`youtube-transcript-api`) inline via
PEP-723 script metadata. Running it with `python scripts/get_transcript.py URL` fails with
`ModuleNotFoundError: No module named 'youtube_transcript_api'`.

**Correct invocation:**
```bash
uv run scripts/get_transcript.py "https://www.youtube.com/watch?v=VIDEO_ID"
```

`notebooklm_extract.py` returns `{"fallback": true}` when `notebooklm-py` isn't installed —
expected; fall back to the direct path (`uv run get_transcript.py`) gracefully, no error to the user.

Redirect to a file for long transcripts so you can page through:
```bash
uv run scripts/get_transcript.py "URL" > /tmp/transcript.txt 2>&1; wc -w /tmp/transcript.txt
```

## `edit` tool: never add `oldText2` / `newText2` keys

When making several disjoint changes to one file, put each change as a SEPARATE object in the
`edits[]` array, each with exactly `oldText` + `newText`. Do NOT pack a second change into one
object with `oldText2`/`newText2` — the schema rejects extra properties:

```
Validation failed: edits.N must not have additional properties
```

Wrong (rejected):
```
{"oldText": "...", "newText": "...", "oldText2": "", "newText2": ""}
```

Right (one object per disjoint edit):
```
[{"oldText": "A", "newText": "A'"}, {"oldText": "B", "newText": "B'"}]
```

This bites repeatedly during multi-section topic-doc distillation. If an edit batch fails
validation, scan for stray numbered keys first.
