---
name: writing-a-spec
description: Write, rebuild or review a specification in this repository. Use when adding a spec, rewriting one a reader found hard, or checking a draft before its record is ratified. A runbook, not a rulebook: it gives the order of work and points at where each rule lives, and restates none of them.
---

# Writing a spec

A spec here is read cold, by someone outside the company, who will adopt it
without our tools. It is judged on one question: what does that reader take
away? This is draft 1 of the runbook. It is edited in the pull request that
teaches it something, never ahead of one.

## Where the rules live

| Question | Read |
|---|---|
| What shape every spec has | [README.md](../../../README.md), "How a spec is written" |
| What may be published, and what never | the record [`20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not`](../../../docs/adr/20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not.md) |
| How a requirement argues: a reason on every line, an exact enforcement table, a lifecycle as a diagram, shipped code in Appendix A | [append-only-adr/SPEC.md](../../../append-only-adr/SPEC.md) |
| How a spec reads: a rule in one sentence then one example, flat sections, short sentences, a problem stated for agents | [org-as-code/SPEC.md](../../../org-as-code/SPEC.md) |
| How a record rides the pull request, and the gate it must pass | [docs/adr/README.md](../../../docs/adr/README.md), "The proposed → accepted flow"; `tools/adr-gate.sh` |
| What the keywords mean | RFC 2119 |

## The order of work

1. **Name the problem and the takeaway first.** Who is the reader, what
   breaks for them without this, and what one or two ideas do they leave
   with. Write those as §1's opening and the one-line summary under the
   title before anything else. If they cannot be named, there is no spec yet.
   (2026-10-19: the first draft of org-as-code distilled six mechanisms, four
   of them practice its reader already knew, and buried the two that were
   new.)
2. **Map what runs, read-only.** A spec distills an implementation that
   exists. List what it does, with file-level proof, and the decisions that
   shaped it. Every MUST is checked against this list in step 6.
3. **Write to the shape.** Each requirement carries its reason. A section
   may open with its rule in one bold sentence and one example drawn from a
   public system (GitHub hosts this repository, so it is the safe one).
   Tool names appear only in terms and marked examples, never inside a
   requirement.
4. **Apply the publish test to every sentence.** A vendor, an account
   layout, a value we hold, a cadence, which organization lacks a control:
   out. A mechanism, and a count about the private deployment: in.
5. **Draft the record** with `status: proposed`, register its hash, run
   `tools/adr-gate.sh`, and pin every link to a commit that exists. The
   pull request is red by design until the decider ratifies.
6. **Review with readers who only read**, each a separate pass with its own
   brief:
   - *Cold read*: a competent engineer who has never seen the documents and
     has ten minutes, scored against the two published specs. Ask what they
     would take away and where they got lost.
   - *Claims*: each MUST and SHOULD against the map from step 2. A rule the
     implementation does not meet is reworded, or the claim in Appendix A is
     scoped to the part that does; it is never left standing.
   - *Leak*: the whole diff against the publish test.
   - *Second pass*: the fix diff alone, so a fix does not reopen a finding.
7. **Measure against both published specs**: words outside code fences,
   defined terms, cross-references, requirements carrying a reason, examples,
   average sentence length, mentions of the reader the spec serves. There is
   no target. Twice either spec on any one of them is a signal to cut.
8. **Mechanical checks**: no line over 80 characters outside tables, links
   and diagram nodes; a numbered list keeps its item count after a reflow;
   the file renders on the forge (`gh api -X POST /markdown`).
9. **Put the text in front of the decider** as the final text with each
   change marked in place and its reason beside it, and ask them to read.
   Ask for ratification only once they say they are ready.

## What to avoid

- Restating a rule that lives at a pointer above. A copy drifts.
- A requirement with no reason. The reader cannot tell a rule from a habit.
- Requiring what the implementation does not do. The claims pass catches
  it, at the cost of a rewrite.
- Hiding every familiar word to keep a tool choice private. Name two tools
  together in an example; the reader needs an anchor.
