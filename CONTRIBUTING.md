# Contributing

Pull requests are welcome: a requirement that is unclear, one an
implementation cannot meet, or a gap you hit while adopting a spec.

## What belongs here

A spec here describes a mechanism: how something is written down, gated,
versioned or reviewed, stated so another team can adopt it without knowing
what we decided. It leaves out the decisions themselves, such as our
architecture or vendors, and how our team runs, such as how we route work
between agents. The record
[`20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not`](docs/adr/20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not.md)
sets this test and gives its reasons.

## Changing a spec

A change to any `SPEC.md` needs a new record in [`docs/adr/`](docs/adr) that
says why. Draft it with `status: proposed` in the same pull request. The pull
request stays red until the record is `accepted`, which happens only after a
maintainer ratifies it in their own words; the steps are in [`docs/adr/README.md`](docs/adr/README.md), under "The
proposed → accepted flow". CI asks for a record only when a `SPEC.md`
changes.

## How a spec is laid out

Every spec has the same sections, so a reader who knows one can scan the
next.

| Section | What it holds |
|---|---|
| Status table | the edition, the RFC 2119 keywords, and where the reference implementation lives |
| 1. The problem | what breaks without the spec, and the shape of the answer as a diagram |
| 2. Terms | every term the requirements use, in one table |
| 3. Principles | the few rules that decide a case the requirements don't cover |
| Requirements | numbered sections of MUST and SHOULD, each with its reason. A section may open with its rule in one bold sentence and a non-normative example |
| Enforcement | what a conforming check rejects, one row per property |
| The bridge to the decision log | how the spec's artifacts cite the decisions behind them; the top conformance level requires it |
| Conformance levels | named levels, each a set of sections, so an adopter can claim one accurately |
| Operational considerations | what happens in practice: upgrades, reverts, renames, redaction |
| Appendix A | the reference implementation, and how this repository uses the spec |
| Appendix B | numbers from one real deployment |
| Appendix C | how the spec relates to existing practice |

The appendices are non-normative. Put structure in a table or a diagram, and
use prose for what a visual can't carry. The order of work for writing a new
spec is in
[`.claude/skills/writing-a-spec/SKILL.md`](.claude/skills/writing-a-spec/SKILL.md).
