# Perimeter Compute specs

How we operate our repositories and the organizations they run in, written as
specifications other teams can adopt. Each spec is normative and
tool-agnostic, and says in its Appendix A how this repository demonstrates it.

| Spec | What it specifies | Status | How this repository demonstrates it |
|---|---|---|---|
| [append-only-adr](append-only-adr/SPEC.md) | the human-ratified, append-only decision log for a repository that agents write | draft 1 | conforms at Level 2: its own decisions are records gated by the implementation it ships |
| [org-as-code](org-as-code/SPEC.md) | managing an organization's settings as code: adopted rather than recreated, every setting decided, and checked against live | draft 1 | governed: this repository is a resource of a private program at Level 2 |

## Adopting a spec

| Spec | What an adopter copies or builds |
|---|---|
| append-only-adr | five paths: the rules document [`docs/adr/README.md`](docs/adr/README.md), the registry [`docs/adr/adr-manifest/`](docs/adr/adr-manifest), the gate [`tools/adr-gate.sh`](tools/adr-gate.sh), and the workflows [`adr-gate.yml`](.github/workflows/adr-gate.yml) and [`adr-gate-trusted.yml`](.github/workflows/adr-gate-trusted.yml). Then require the trusted workflow from the default branch, so a pull request cannot rewrite the check that judges it |
| org-as-code | nothing to copy: the coverage gate reads each provider's own schema. Its §5 and Appendix A describe what to build |

## How a spec is written

Every spec has the same shape, so a reader who knows one can scan the next.

| Section | Carries |
|---|---|
| Status table | the edition, the conformance keywords (RFC 2119), and where the reference implementation lives |
| 1. The problem | what breaks without the spec, and the shape of the answer as a diagram |
| 2. Terms | the terms the requirements use, in one table |
| 3. Principles | the few rules that decide a case the requirements are silent on |
| Requirements | numbered sections of MUST and SHOULD, each with its reason |
| Enforcement | what a conforming gate rejects, one row per property |
| Conformance levels | named levels, each a set of sections, so an adopter can claim one honestly |
| Operational considerations | what happens in practice: upgrades, reverts, renames, redaction |
| Appendix A | the reference implementation, and how this repository demonstrates the spec |
| Appendix B | one deployment's counts |
| Appendix C | how the spec relates to existing practice |

The appendices are non-normative. Structure goes in a table or a diagram, and
prose carries what a visual cannot.

## What is published here

Mechanisms: how a thing is written down, gated, versioned or reviewed, stated
so another team can adopt it without learning what we decided. Never a
decision's content, and never the operating playbook. The test and its
reasoning are in the record
[`20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not`](docs/adr/20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not.md).

## Changing a spec

A change to a spec is a decision. It rides a pull request together with a new
record in [`docs/adr/`](docs/adr), which a human ratifies in their own words
before the pull request can merge. CI fails a pull request that changes a
`SPEC.md` without adding a record. This repository's decisions follow the
[append-only-adr](append-only-adr/SPEC.md) spec; its rules as applied here are
in [`docs/adr/README.md`](docs/adr/README.md).

## License

[MIT](LICENSE).
