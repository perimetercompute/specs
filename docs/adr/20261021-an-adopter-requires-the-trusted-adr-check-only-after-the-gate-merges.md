---
schema: 1
status: proposed
date: 2026-10-21
deciders: [jacob-petterle]
scope: append-only-adr
supersedes: []
---

# An adopter requires the trusted ADR check only after the gate merges

## Context

As of 2026-10-21, Appendix A of the append-only-adr spec told an adopter to
copy five paths, require the trusted workflow from the default branch, then
write and register a first record. A cold read of the README, which gave the
same steps, checked them against the workflows and found two of them fail.

`adr-gate-trusted.yml` runs the default branch's `tools/adr-gate.sh`. Required
before the gate has merged, it finds no script there and fails every pull
request, the adopting one included. And the gate fails when
`docs/adr/adr-manifest/` is missing, which git cannot carry while it is
empty, so a change that copies the gate without a first record is red for a
reason the adopter did not cause. The workflows also name `main` as the push
branch, and the appendix did not say so.

## Decision

We will order Appendix A's adoption steps so each one can pass: copy the
script, both workflows and the rules document, and write and register the
first record, all in one change; ratify the record and merge; only then
require the trusted workflow from the default branch. The appendix names the
`main` push trigger an adopter with another default branch must edit.

| What | Decided |
|---|---|
| Appendix A, adoption paragraph | the order above, with the reason for each step that a reader would otherwise reverse |
| Normative text | unchanged: §8.1 already requires the check to run as the default branch defines it, and says nothing about the order of adoption |

### Options considered

| Option | Why it lost |
|---|---|
| Leave the appendix as written | An adopter who follows it gets a red check on every pull request, including the one that would fix it |
| Ship a placeholder manifest entry so the directory exists | The gate rejects an entry that registers no record, and a fake record would be the first thing frozen in the adopter's log |
| Fix only the README | The README points at the spec; an adopter who reads the appendix directly would still be misled |

## Human intent

> "are you certain there's no other places that need to be updated"

— Jacob ([@jacob-petterle](https://github.com/jacob-petterle)), pairing session (message, left as received), 2026-10-21

The search those words asked for found this paragraph.

Ratification: awaiting the decider's words on this pull request.

## Consequences

- An adopter can follow Appendix A in order and reach Level 2 without a
  check that fails for a reason they did not cause.
- No outside adopter is known, so no published claim changes.

## References

- Record-carrying PR: https://github.com/perimetercompute/specs/pull/9
- Implementing PR: https://github.com/perimetercompute/specs/pull/9
- https://github.com/perimetercompute/specs/pull/8
