#!/usr/bin/env bash
# run-codex.sh — standard non-interactive Codex (gpt-5-codex) invocation for the
# codex-delegate skill. Launch this with Claude's Bash run_in_background: true.
#
# Usage:   run-codex.sh <spec-file> [repo-dir] [out-prefix] [model]
#   <spec-file>   path to the markdown spec (piped to codex as the prompt)
#   [repo-dir]    working root for codex (default: current dir)
#   [out-prefix]  output path prefix (default: /tmp/codex-<spec-basename>)
#   [model]       model override (default: gpt-5-codex)
#
# Produces:
#   <out-prefix>-last.txt     codex's final message (the summary you review)
#   <out-prefix>-stream.jsonl the full JSONL event stream (peek only; don't read whole)
#
# Notes:
#   - gpt-5-codex requires OpenAI platform API-key auth (codex login status -> "API key").
#   - workspace-write lets codex edit files + run the gate; network is restricted, so
#     ensure deps are installed before launching.
set -euo pipefail

SPEC="${1:?spec file required}"
REPO="${2:-$PWD}"
PREFIX="${3:-/tmp/codex-$(basename "${SPEC%.md}")}"
MODEL="${4:-gpt-5-codex}"

if [[ ! -f "$SPEC" ]]; then
  echo "spec file not found: $SPEC" >&2
  exit 1
fi

codex exec \
  -C "$REPO" \
  -m "$MODEL" \
  -s workspace-write \
  --json \
  -o "${PREFIX}-last.txt" \
  - < "$SPEC" > "${PREFIX}-stream.jsonl" 2>&1

echo "EXIT=$?  last=${PREFIX}-last.txt  stream=${PREFIX}-stream.jsonl"
