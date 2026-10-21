# Contributing

Send a pull request in these cases:

- A requirement is not clear.
- An implementation cannot meet a requirement.
- You find a gap when you adopt a spec.

## Scope

A spec in this repository describes a mechanism. A mechanism is how you write
down, check, version or review something. Another team must be able to use
the spec without information about our decisions.

A spec does not include:

- Our decisions, for example our architecture or our vendors.
- How our team operates, for example how we give work to agents.

The record
[`20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not`](docs/adr/20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not.md)
gives this rule and the reasons for it.

## Change a spec

1. In the pull request that changes the `SPEC.md` file, add a new record to
   [`docs/adr/`](docs/adr). Set `status: proposed`.
2. A maintainer approves the record in their own words.
3. The author copies those words into the record and sets
   `status: accepted`.

CI fails until the record has `status: accepted`. For the full procedure, see
"The proposed → accepted flow" in [`docs/adr/README.md`](docs/adr/README.md).
CI requires a new record only when a `SPEC.md` file changes.

## The sections of a spec

All specs have the same sections. If you know one spec, you can quickly find
information in the next one.

| Section | Contents |
|---|---|
| Status table | The edition, the RFC 2119 keywords, and the location of the reference implementation |
| 1. The problem | What fails without the spec. A diagram shows the solution. |
| 2. Terms | A table of all the terms that the requirements use |
| 3. Principles | Rules that tell you what to do when no requirement applies |
| Requirements | Numbered sections of MUST and SHOULD rules. Each rule has a reason. A section can start with its rule in bold and one example. Examples are not normative. |
| Enforcement | What a check rejects if it conforms to the spec, with one row for each property |
| The bridge to the decision log | How the spec's artifacts link to the decisions behind them. The highest conformance level requires this link. |
| Conformance levels | Named levels. Each level is a set of sections, so an adopter can say which level they meet. |
| Operational considerations | What occurs in practice: upgrades, reverts, renames and redaction |
| Appendix A | The reference implementation, and how this repository uses the spec |
| Appendix B | Numbers from one real deployment |
| Appendix C | How the spec compares with current practice |

The appendices are not normative. Use a table or a diagram to show structure.
Use text only for information that a table or a diagram cannot show. For the
procedure to write a new spec, see
[`.claude/skills/writing-a-spec/SKILL.md`](.claude/skills/writing-a-spec/SKILL.md).
