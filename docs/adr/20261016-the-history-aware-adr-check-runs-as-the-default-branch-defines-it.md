---
schema: 1
status: proposed
date: 2026-10-16
deciders: [jacob-petterle]
scope: append-only-adr
supersedes: []
---

# The history-aware ADR check runs as the default branch defines it

## Context

As of 2026-10-06, §8.1 of the append-only-adr spec required a history-aware
check "which nothing inside the change can forge", and said nothing about
where the check's own definition comes from. This repository's
[`adr-gate.yml`](https://github.com/perimetercompute/specs/blob/1698a6be701d863f2ebffd7b4accf317816ec101/.github/workflows/adr-gate.yml)
runs the copy of the workflow and the script that a pull request carries, so
a pull request that rewrites either one can report a passing check about
itself.

[Pull request #2](https://github.com/perimetercompute/specs/pull/2) added
`adr-gate-trusted.yml`, which runs the default branch's script against the
pull request's tree, and an organization ruleset requires it as it stands on
the default branch. [Pull request #5](https://github.com/perimetercompute/specs/pull/5)
tested it on 2026-10-07: one commit edited a byte of a merged record and
replaced that branch's copy of the trusted workflow with `exit 0`, and
`adr-gate-trusted` still failed. The spec did not change. Its header and
Appendix A named only `adr-gate.yml`, and told an adopter to copy "those three
paths", so an adopter following the spec got the copy a pull request can
rewrite.

## Decision

We will require, in §8.1, that the history-aware check run as the default
branch defines it: both the script and the workflow that runs it come from
the default branch. The spec's header and
Appendix A name the trusted workflow, and Appendix A tells an adopter to copy
five paths and require that workflow from the default branch.

| What | Decided |
|---|---|
| §8.1 | adds: "The history-aware check MUST run as the default branch defines it: both the script and the workflow that runs it come from the default branch, never from the change, because a check whose definition the change carries can be rewritten by the change it judges." |
| §10, Level 2 | the history-aware check runs "as the default branch defines it" |
| Appendix A | a row for `adr-gate-trusted.yml`; `adr-gate.yml` described as the change's own copy, the push leg and the comment; "those three paths" becomes "those five paths", plus requiring the trusted workflow |
| `docs/adr/README.md` | its Enforcement section names both workflows and why both exist |
| `adr-gate.yml` | resolves the default branch by its full ref, as `adr-gate-trusted.yml` already does, and its header says it is the copy a pull request can rewrite |

### Options considered

| Option | Why it lost |
|---|---|
| Leave §8.1 as written | A repository could claim Level 2 with a check that every pull request can rewrite, which is the forgery §8.1 exists to stop |
| Require review of any change to the gate files instead | A review is not a check, and a repository that requires no approvals has none |
| Fix only Appendix A, which is non-normative | The appendix would then demand what the normative text does not, and an adopter reading only the requirements would still be exposed |

## Human intent

> "id' like to add a new spec for distilling how we do all our infra as code
> but i think primiarly focused on the non-normal infra as code things like
> the orgnaiztions and things like that. we may need to revise the readme and
> also id' recommend revising the readme and reviewing everyting for
> readableing and pattern adhere to our specs that already exist."

— Jacob ([@jacob-petterle](https://github.com/jacob-petterle)), pairing session (typed message; typos left as typed), 2026-10-16

The review those words asked for found this gap. Ratification: awaiting the
decider's own words on the pull request.

## Consequences

- A Level 2 claim now means what §8.1 always said: nothing inside a change can
  forge the check that judges it.
- An adopter whose forge cannot require a check from the default branch must
  run the check from somewhere a change cannot reach, or claim Level 1.
- The spec is in draft, and no outside adopter is known, so no published
  claim falls a level. Had one existed, it would have.

## References

- Record-carrying PR: https://github.com/perimetercompute/specs/pull/7
- Implementing PR: https://github.com/perimetercompute/specs/pull/7
- https://github.com/perimetercompute/specs/pull/2
- https://github.com/perimetercompute/specs/pull/5
