# Perimeter Compute specs

How Perimeter Compute builds and ships software with AI agents, written as
specs that you can adopt.

Each spec defines one mechanism: the problem it solves, what an
implementation must do, and how to check it. The specs are tool-agnostic, so
you can implement them with the tools you already use.

## Specs

| Spec | Problem | Solution | Status |
|---|---|---|---|
| [Append-only ADRs](append-only-adr/SPEC.md) | Agents undo decisions that nobody wrote down. | Each decision is a record that a person approves in their own words. CI blocks any edit to it after merge. | Draft 1 |
| [Organizations as code](org-as-code/SPEC.md) | Agents cannot safely change settings in a web console, and nobody notices a setting left at its default. | Keep the organization's settings in code. Decide every setting, and check the code against the live organization. | Draft 1 |

## Using a spec

Every spec has the same layout. Section 1 states the problem. The
conformance levels let you adopt part of a spec and say which level you meet.
Appendix A describes the reference implementation and how to copy it, where
we publish one.

## This repository

We use these specs here. This repository's own decisions are records in
[`docs/adr/`](docs/adr), checked by the append-only-adr reference
implementation. Its GitHub settings are code in our private monorepo, managed
under the org-as-code spec.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for what belongs here, how to change a
spec, and the layout every spec follows.

## License

[MIT](LICENSE)
