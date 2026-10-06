# Perimeter Compute specs

How we operate our repositories, written as specifications other teams can
adopt. Each spec is normative and tool-agnostic, and this repository is a
conforming implementation of every spec it publishes.

| Spec | One line | Status |
|---|---|---|
| [append-only-adr](append-only-adr/SPEC.md) | the human-ratified, append-only decision log for a repository that agents write | draft 1 |

## This repository conforms to its own specs

Its decisions are records in [`docs/adr/`](docs/adr), registered in
[`docs/adr/adr-manifest/`](docs/adr/adr-manifest) and gated by
[`tools/adr-gate.sh`](tools/adr-gate.sh) and
[`.github/workflows/adr-gate.yml`](.github/workflows/adr-gate.yml). The claim
is Level 2 of the append-only-adr spec. To adopt that spec, copy those three
paths and the rules document at [`docs/adr/README.md`](docs/adr/README.md).

## What is published here

Mechanisms: how a thing is written down, gated, versioned or reviewed, stated
so another team can adopt it without learning what we decided. Never a
decision's content, and never the operating playbook. The test and the
reasoning are the record
[`20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not`](docs/adr/20261006-mechanisms-are-published-decisions-and-the-operating-playbook-are-not.md).

## Changing a spec

A change to a spec is a decision. It rides a pull request together with a
record in `docs/adr/`, which a human ratifies in their own words before the
pull request can merge, and CI fails a pull request that changes a `SPEC.md`
without adding a record. The first record in this repository is the decision to
publish it.

## License

[MIT](LICENSE).
