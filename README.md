# Perimeter Compute specs

How Perimeter Compute builds and ships software with AI agents, written as
specs that you can adopt.

Each spec defines one mechanism: the problem it solves, what an
implementation must do, and how to check it. The specs are tool-agnostic, so
you can implement them with the tools you already use.

## Specs

| Spec | What it covers | Status |
|---|---|---|
| [append-only-adr](append-only-adr/SPEC.md) | Architecture decision records that a person approves and CI keeps from being edited | Draft 1 |
| [org-as-code](org-as-code/SPEC.md) | Organization settings as code, with every setting decided and checked against the live organization | Draft 1 |

## Using a spec

Every spec has the same layout. Section 1 states the problem. The
conformance levels let you adopt part of a spec and say which level you meet.
Appendix A describes the reference implementation and how to copy it, where
we publish one.

## This repository

We use these specs here. This repository's own decisions are records in
[`docs/adr/`](docs/adr), checked by the append-only-adr reference
implementation. Our org-as-code implementation manages its GitHub settings.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for what belongs here, how to change a
spec, and the layout every spec follows.

## License

[MIT](LICENSE)
