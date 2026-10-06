#!/usr/bin/env bash
# adr-gate.sh — the append-only decision log's gate. Two modes, one script.
#
# Hermetic mode (default): runs anywhere, needs no git. Hashes every record
# against its manifest entry and validates the record schema, so it catches
# ACCIDENTS — an edited byte, a deleted record, an unregistered file — on a
# laptop before a PR exists. A `status: proposed` record is REPORTED, not
# failed: proposed is the state the drafting flow requires on a branch.
#
# Git mode (ADR_GATE_GIT_MODE=1; CI runs it on pull_request, merge_group and
# push): the same assertions, plus `status: proposed` FAILS. That one split
# assertion keeps a draft off main while leaving the laptop run green.
#
# Neither mode can stop an edit that also rewrites its manifest entry. The
# git-diff step in .github/workflows/adr-gate.yml is the unforgeable layer.
#
# Two constraints on every assertion here, because records are frozen:
# 1. INTRINSIC ONLY — never assert anything about the world outside a
#    record's bytes (a path exists, a URL resolves): the world moves, the
#    record cannot follow, and the gate would redden with no legal fix.
# 2. VERSIONED — a tightened rule applies only to records declaring the new
#    `schema:` version; old records are judged by their own version forever.
#
# Every failure message teaches the fix.
set -euo pipefail

GIT_MODE="${ADR_GATE_GIT_MODE:-}"
MANIFEST=docs/adr/adr-manifest
fail=0

gate() { echo "── $1"; }
violation() {
  echo "  ✗ $1"
  fail=1
}

# macOS ships shasum, Linux ships sha256sum — same digest either way.
if command -v sha256sum > /dev/null 2>&1; then
  hash_file() { sha256sum "$1" | awk '{print $1}'; }
else
  hash_file() { shasum -a 256 "$1" | awk '{print $1}'; }
fi

# Stops at the second fence, so a markdown '---' rule in the body never
# reopens front matter.
front_matter() { awk '/^---$/{n++; next} n==1{print} n>=2{exit}' "$1"; }

# Every ADR dir in the tree: the central docs/adr/ plus any package's own
# <pkg>/docs/adr/. Vendored and generated trees are never a record home.
find_adr_dirs() {
  find . \( -name node_modules -o -name .git -o -path './third_party' \) -prune \
    -o -type d -path '*/docs/adr' -print | sed 's|^\./||' | sort
}

gate "the rules doc every failure message cites exists"
[ -f docs/adr/README.md ] ||
  violation "docs/adr/README.md is missing — it carries the rules and the template every message below cites"

gate "manifest: a directory of one-line entry files, each named for the record it registers"
# A directory of entries, not one shared file: two PRs registering two
# different records add two different files, so they can never conflict.
if [ ! -d "$MANIFEST" ]; then
  violation "$MANIFEST/ is missing — it is the append-only registry: one <record-id>.txt per record, holding its 'shasum -a 256 <path>' line written from repo root"
else
  while IFS= read -r e; do
    [ -n "$e" ] || continue
    base=$(basename "$e")
    case "$base" in
      *.txt) ;;
      *)
        violation "$e is not a .txt entry — $MANIFEST/ holds one <record-id>.txt per record and nothing else"
        continue
        ;;
    esac
    if [ ! -f "$e" ] || [ -L "$e" ]; then
      violation "$e is not a plain file — an entry is one '<sha256>  <path>' line"
      continue
    fi
    [ "$(wc -l < "$e" | tr -d ' ')" = "1" ] ||
      violation "$e is not exactly one line — one record per entry file; write it with 'shasum -a 256 <path> > $e'"
    line=$(head -n 1 "$e")
    if ! grep -Eq '^[0-9a-f]{64}  ([a-z0-9_.-]+/)*docs/adr/2[0-9]{7}-[a-z0-9][a-z0-9-]*\.md$' <<< "$line"; then
      violation "$e is malformed — want '<sha256>  <path>/docs/adr/YYYYMMDD-slug.md' (two spaces, repo-root-relative), the exact output of 'shasum -a 256 <path>' from repo root: $line"
      continue
    fi
    path=${line#*  }
    [ "$base" = "$(basename "$path" .md).txt" ] ||
      violation "$e is misnamed — the entry file's name is the record's id; rename it to $MANIFEST/$(basename "$path" .md).txt"
  done < <(find "$MANIFEST" -mindepth 1 -maxdepth 1 | sort)
fi

gate "append-only: every registered record exists and its bytes match its hash"
if [ -d "$MANIFEST" ]; then
  while IFS= read -r e; do
    [ -n "$e" ] || continue
    want=$(awk '{print $1; exit}' "$e")
    path=$(awk '{print $2; exit}' "$e")
    [ -n "$path" ] || continue
    if [ ! -f "$path" ]; then
      violation "$path is registered but missing — merged records are never deleted or renamed; restore it. A change of mind is a NEW record carrying 'supersedes: [$(basename "$path" .md)]'"
      continue
    fi
    [ "$(hash_file "$path")" = "$want" ] ||
      violation "$path differs from its registered hash — merged records are immutable: revert the edit and write a NEW record with 'supersedes: [$(basename "$path" .md)]'. (A record still on its own branch is a draft: re-hash it with 'shasum -a 256 $path > $e'.)"
  done < <(find "$MANIFEST" -mindepth 1 -maxdepth 1 -type f -name '*.txt' | sort)
fi

gate "every ADR dir holds only records (YYYYMMDD-slug.md), each registered"
record_files=""
while IFS= read -r dir; do
  [ -n "$dir" ] || continue
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    case "$f" in
      docs/adr/README.md | docs/adr/adr-manifest | docs/adr/adr-manifest/*) continue ;;
    esac
    if [ -d "$f" ] || [ "$(dirname "$f")" != "$dir" ]; then
      violation "$f is nested inside $dir/ — records live DIRECTLY in a docs/adr/ dir; a nested file is invisible to parts of the enforcement and fails open"
      continue
    fi
    base=$(basename "$f")
    if ! grep -Eq '^2[0-9]{7}-[a-z0-9][a-z0-9-]*\.md$' <<< "$base"; then
      violation "$f is not a record (YYYYMMDD-slug.md) — an ADR dir holds records and nothing else; an index or a diagram lives elsewhere, because everything here freezes on merge"
      continue
    fi
    entry="$MANIFEST/$(basename "$f" .md).txt"
    awk -v p="$f" '$2 == p {found=1} END {exit !found}' "$entry" 2> /dev/null ||
      violation "$f is not registered — from repo root: shasum -a 256 $f > $entry"
    record_files="${record_files}${f}"$'\n'
  done < <(find "$dir" -mindepth 1 | sort)
done < <(find_adr_dirs)

gate "records: front matter is complete, each key exactly once"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  fm=$(front_matter "$f")
  if [ -z "$fm" ]; then
    violation "$f has no front-matter block (--- fences) — copy the template in docs/adr/README.md"
    continue
  fi
  # Exactly once: every reader below takes the FIRST match, while a human
  # reads whichever line they scroll to.
  for key in schema status date deciders scope supersedes; do
    n=$(grep -Ec "^$key:" <<< "$fm" || true)
    if [ "$n" -eq 0 ]; then
      violation "$f front matter is missing '$key:' — the template in docs/adr/README.md lists every required key"
    elif [ "$n" -gt 1 ]; then
      violation "$f declares '$key:' $n times — the gate reads the first and a human reads whichever they scroll to; keep one"
    fi
  done
  grep -Eq '^schema: 1([[:space:]]|$)' <<< "$fm" ||
    violation "$f declares an unknown 'schema:' — known versions: 1. The version pins which rules judge this record forever"
  grep -Eq '^date: [0-9]{4}-[0-9]{2}-[0-9]{2}([[:space:]]|$)' <<< "$fm" ||
    violation "$f 'date:' is not YYYY-MM-DD — the day the human ratified, not the day an agent drafted"
  grep -Eq '^supersedes: \[[^]]*\]' <<< "$fm" ||
    violation "$f 'supersedes:' must be an inline list — '[]' for a new decision, '[<id>]' for a revision"
  grep -Eq '^deciders: \[[A-Za-z0-9][A-Za-z0-9-]*([[:space:]]*,[[:space:]]*[A-Za-z0-9][A-Za-z0-9-]*)*\]' <<< "$fm" ||
    violation "$f 'deciders:' must be a non-empty inline list of bare GitHub handles, e.g. '[jane-doe]' — humans only; an agent is never a decider"
done <<< "$record_files"

gate "records: Human intent quotes the decider verbatim, with attribution"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if ! grep -q '^## Human intent$' "$f"; then
    violation "$f is missing '## Human intent' — the decider's exact words; a decision without them is an assumption"
    continue
  fi
  intent=$(awk '/^## Human intent$/{f=1; next} /^## /{f=0} f' "$f")
  grep -q '^> ' <<< "$intent" ||
    violation "$f Human intent has no '>' blockquote — quote the decider verbatim; a paraphrase never substitutes"
  grep -Eq '^— .*\[@[A-Za-z0-9-]+\]\(https://github\.com/[A-Za-z0-9-]+/?\).*, .*[0-9]{4}-[0-9]{2}-[0-9]{2}' <<< "$intent" ||
    violation "$f Human intent needs an attribution line — '— Name ([@handle](https://github.com/handle)), <source>, YYYY-MM-DD'"
done <<< "$record_files"

gate "records: status is accepted|deprecated — 'proposed' never reaches main"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  status=$(front_matter "$f" | awk '/^status:/{sub(/^status:[[:space:]]*/, ""); sub(/[[:space:]]*#.*$/, ""); sub(/[[:space:]]+$/, ""); print; exit}')
  case "$status" in
    accepted | deprecated) ;;
    proposed)
      if [ -n "$GIT_MODE" ]; then
        violation "$f is 'status: proposed' — legal on a branch, never on main. The decider's ratifying words land verbatim in Human intent, status flips to accepted in the same PR, the manifest entry is re-hashed, and this goes green. A red PR here is the flow working."
      else
        echo "  · $f is 'status: proposed' — legal on a branch, so this mode only reports it; CI's git mode blocks the merge until the decider ratifies."
      fi
      ;;
    *)
      violation "$f has status '${status:-<missing>}' — allowed: accepted | deprecated. Superseded-ness is derived from a NEWER record's 'supersedes:'; it is never written back into the old record"
      ;;
  esac
done <<< "$record_files"

gate "record ids are unique across every ADR dir"
dupes=$(while IFS= read -r f; do [ -z "$f" ] || basename "$f"; done <<< "$record_files" | sort | uniq -d)
[ -z "$dupes" ] ||
  violation "duplicate record id(s): $(tr '\n' ' ' <<< "$dupes")— the filename stem is the record's global id; re-slug the newer record"

gate "references: supersedes ids resolve and move forward in time; links are commit-SHA permalinks"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  this_date=$(front_matter "$f" | awk '/^date:/{print $2; exit}')
  ids=$(front_matter "$f" | sed -n 's/^supersedes:[[:space:]]*\[\([^]]*\)\].*$/\1/p' | tr ',' ' ')
  for id in $ids; do
    if [ "$(basename "$f" .md)" = "$id" ]; then
      violation "$f supersedes itself — a revision supersedes the OLD record's id"
      continue
    fi
    sup=$(awk -v want="$id.md" -F/ '$NF == want {print; exit}' <<< "$record_files")
    if [ -z "$sup" ]; then
      violation "$f supersedes '$id' but no record with that id exists — the id is the filename stem of an existing record"
      continue
    fi
    sup_date=$(front_matter "$sup" | awk '/^date:/{print $2; exit}')
    if [[ "$sup_date" > "$this_date" ]]; then
      violation "$f (date: $this_date) supersedes '$id' (date: $sup_date), which is NEWER — a supersede chain moves forward in time, or 'what is current' becomes unanswerable"
    fi
  done
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    grep -Eq 'github\.com/[^/]+/[^/]+/blob/[0-9a-f]{40}(/|$)' <<< "$link" ||
      violation "$f links a blob URL by branch name — branch links rot as the branch moves; pin a commit SHA (press 'y' on GitHub): $link"
  done < <(grep -Eoh 'https://github\.com/[^/[:space:]]+/[^/[:space:]]+/blob/[^[:space:])]+' "$f" || true)
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    violation "$f carries a relative link ($rel) — records get pasted outside the repo; use a commit-SHA permalink with the id as link text"
  done < <(grep -Eoh '\]\((\./|\.\./|docs/)[^)]*\)' "$f" || true)
done <<< "$record_files"

if [ "$fail" -ne 0 ]; then
  echo
  echo "ADR gate violations (above) — rules and the supersede flow: docs/adr/README.md"
  exit 1
fi
echo "ADR log OK"
