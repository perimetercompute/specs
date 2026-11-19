---
schema: 1
status: proposed
date: 2026-11-19
deciders: [jacob-petterle]
scope: repo
supersedes: [20261016-organizations-as-code-is-published-and-this-repository-demonstrates-it-as-a-governed-resource]
---

# Operating a proactive agent is published as a mechanism, and its values stay private

## Context

As of 2026-11-19, Jacob had asked for a public spec on running a proactive
agent as a software engineer, and then for it to cover any proactive agent,
so that how-to posts on the company's main site could each implement it.

The record
[`20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not`](https://github.com/perimetercompute/specs/blob/c7fe8c772b179e8ff2dcdc167f4eac5d7e55b08a/docs/adr/20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not.md)
keeps the operating playbook out of this repository. It names decision tiers
and how agents are briefed, and it says an edge case earns its own record.
It also keeps vendors out, as a decision's content. As of 2026-11-19,
`CONTRIBUTING.md` gives "how we give work to agents" as an example of what a
spec does not include. A setup for one product fails that test. A general
shape for any proactive agent sits on the line: its five-level scale is a
form of decision tier, and its §8 lists the fields of a brief.

The record
[`20261016-organizations-as-code-is-published-and-this-repository-demonstrates-it-as-a-governed-resource`](https://github.com/perimetercompute/specs/blob/c7fe8c772b179e8ff2dcdc167f4eac5d7e55b08a/docs/adr/20261016-organizations-as-code-is-published-and-this-repository-demonstrates-it-as-a-governed-resource.md)
decided that each spec says in its Appendix A how this repository
demonstrates it, in one of two forms: an implementation the repository
ships, or a resource a conforming implementation governs. A repository cannot
run a proactive agent, and the reference implementation meets no
conformance level yet, so neither form fits.

The words that asked for this pull request include "We're building in public
here". The mechanisms record names one condition that would publish the
operating model: a deliberate choice to make it part of the public brand,
taken in a superseding record. This record reads those words as about where
the draft is reviewed, not as that choice.

## Decision

We will publish `proactive-agent/SPEC.md`, the shape of operating a proactive
agent, as a mechanism: outcome workspaces and their lifecycle, a
reversibility scale with a yes gate, the fields of a hand-off brief, and a
monthly review that moves authority on a record. Each level is defined by a
test (who sees the action, and whether it can be undone), never by a list of
actions. We will NOT publish the values an implementation chooses: which of
our actions sit at which level, our one-way-door and always-ask lists, our
workspaces and routines, our model routing, or what running agents costs us.
This decides an edge case under the mechanisms record and does not supersede
it. A scale's tests and a brief's fields are formats another team can adopt
without learning ours.

This record supersedes
[`20261016-organizations-as-code-is-published-and-this-repository-demonstrates-it-as-a-governed-resource`](https://github.com/perimetercompute/specs/blob/c7fe8c772b179e8ff2dcdc167f4eac5d7e55b08a/docs/adr/20261016-organizations-as-code-is-published-and-this-repository-demonstrates-it-as-a-governed-resource.md)
in part. Its clause "each spec says in its Appendix A how this repository
demonstrates it: as a conforming implementation the repository ships, or as
a resource a conforming implementation governs" gains a third form: for a
spec whose subject cannot run in a repository, what its reference
implementation does here. That record's other decisions stand.

| What | Decided |
|---|---|
| The scale's five levels, each defined by a test, and the rule that picks one | published |
| Which of our actions sit at each level, and our one-way-door and always-ask lists | never |
| The brief's fields, and why each exists | published |
| What our briefs say, which models build or review, and how our coding agents are dispatched | never |
| Product names | in Appendix A only: the publicly available products one person's setup runs on, not the company's infrastructure |
| The reference implementation | private, described by its shape; it claims no conformance level |
| Its gaps | stated plainly in Appendix A. They concern one person's agent setup and this repository's published gate, not the company's infrastructure |
| Delegation tokens | §10.1, marked draft; no conformance level requires it |
| How this repository demonstrates it | by what the reference implementation does here: its pull request arrives as a draft from a hand-off, and its required checks stay red until the record is ratified |
| How-to posts that implement the spec with one product | the company's main site, not this repository |

### Options considered

| Option | Why it lost |
|---|---|
| A how-to for one product in this repository | not tool-agnostic, and mostly playbook |
| Supersede the mechanisms record and publish the operating model | gives away the values, which are the edge, to show a shape |
| Supersede in part the mechanisms record's "decision tiers" and "briefed" clauses | those clauses still govern every value this spec leaves out. The mechanisms record asks for an edge-case record, not a retirement |
| Leave §8 out, because `CONTRIBUTING.md` names "how we give work to agents" | the brief is where a proactive agent most often fails a coding agent, and its fields carry no value of ours |
| Define each level by a list of actions | a list is what we put at a level, which is playbook; a test can be adopted without it |
| Keep the reference implementation's products out, as org-as-code does | a reader needs to see the shape run somewhere real, and these are one person's tools, not a decision about the company's infrastructure |
| Claim this repository as a governed resource, or the reference implementation at a conformance level | a repository is not where a proactive agent runs, and the setup does not meet conformance level 1; either claim would be false |
| Leave the gaps out, and say only that no conformance level is claimed | the spec is built in public, and a reader adopting it learns most from where the reference stops |
| Publish nothing | the shape is what readers can adopt, and the posts need a spec to point at |

## Human intent

> "Ah I see. Maybe we could generalize it to any proactive agent?
> Is that how to thin about it? Then our how to blogs could be on our
> main site and inplemt a sec?" "*spec"

— Jacob ([@jacob-petterle](https://github.com/jacob-petterle)), chat with his proactive agent (typed, two messages; typos left as typed), 2026-11-19

> "Can we revive the task for building the spec for a proactive agent real
> quick and just give first draft for a PR to the specs in perimeter?" "We
> can always publish as a draft right or adjust later? […]" "No it can open
> the pr. We're building in public here"

— Jacob ([@jacob-petterle](https://github.com/jacob-petterle)), chat with his proactive agent, relayed verbatim to the coding agent that drafted this record (typed; typos left as typed), 2026-11-19

([…] marks a sentence left out, and a fourth message is left out whole. Both
are about how the drafting agent was run, which the mechanisms record keeps
private.)

Ratification: waiting for the decider's own words on the pull request.

## Consequences

- A reader can adopt the shape with any agent product, and each post on the
  main site can implement one conformance level of it.
- The line needs judgement again at the edges. A level's test is a
  mechanism; what we put at a level is playbook. Every later edit to this
  spec takes the same test.
- `CONTRIBUTING.md` still names "how we give work to agents" as out of scope.
  Read with this record, that means what our briefs say, not the fields a
  brief carries.
- Appendix A names the products of the reference implementation and states
  its four gaps. A reader sees the shape run and how far the setup is from
  the spec it publishes. Anyone else learns where its controls stop.
- This repository demonstrates the spec only through what the reference
  implementation does here.
- §10.1 is untested design. Making any of it a requirement is a later
  record's decision.
- Appendix B stays empty until the first monthly review.

## References

- Record-carrying PR: none yet
- Implementing PR: the same pull request adds `proactive-agent/SPEC.md`
- [`20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not`](https://github.com/perimetercompute/specs/blob/c7fe8c772b179e8ff2dcdc167f4eac5d7e55b08a/docs/adr/20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not.md)
- [`20261016-organizations-as-code-is-published-and-this-repository-demonstrates-it-as-a-governed-resource`](https://github.com/perimetercompute/specs/blob/c7fe8c772b179e8ff2dcdc167f4eac5d7e55b08a/docs/adr/20261016-organizations-as-code-is-published-and-this-repository-demonstrates-it-as-a-governed-resource.md)
