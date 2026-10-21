# Perimeter Compute specs

Specifications for running a repository, and the organization around it, when
AI agents write most of the changes.

Each spec takes one thing that breaks once agents do the work and defines the
mechanism that stops it. The specs use RFC 2119 keywords (MUST, SHOULD) and
assume no particular tool, so you can implement one with the tools you
already run.

| Spec | The problem it solves | Status |
|---|---|---|
| **[Append-only ADRs](append-only-adr/SPEC.md)** (Architecture Decision Records) | Agents undo decisions nobody wrote down. Record each decision in a log that a human ratifies in their own words and that CI won't let anyone edit afterwards. | Draft 1 |
| **[Organizations as code](org-as-code/SPEC.md)** | Agents can't safely change settings that live in web consoles. Manage the organization as code, decide every setting the provider offers, and check the code against what is live. | Draft 1 |

The specs stand alone. Used together, a setting that trades something away,
such as letting a bot merge without review, links to the ADR where a person
chose it (org-as-code §8).

## Adopting a spec

Read the spec, choose a conformance level, and build it however suits you.
Each spec defines its levels so you can say exactly which one you meet, for
example "Level 2: CI enforces the log".

### Append-only ADRs

This repository ships a working implementation for GitHub Actions. To use it:

1. In one pull request, copy [`tools/adr-gate.sh`](tools/adr-gate.sh), the
   two workflows [`adr-gate.yml`](.github/workflows/adr-gate.yml) and
   [`adr-gate-trusted.yml`](.github/workflows/adr-gate-trusted.yml), and the
   rules and template in [`docs/adr/README.md`](docs/adr/README.md). Leave our
   records and their manifest entries behind.
2. In the same pull request, write your first record from the template with
   `status: proposed` and register it:
   `shasum -a 256 docs/adr/<id>.md > docs/adr/adr-manifest/<id>.txt`.
   The gate stays red while the record is `proposed`.
3. A human approves the record in their own words. Quote them under Human
   intent, set `status: accepted`, re-run the `shasum` line, and merge.
4. Now require `adr-gate-trusted` with an organization ruleset. It runs the
   gate as your default branch has it, so a pull request can't rewrite the
   check that judges it.

The workflows assume your default branch is `main`; change the `push` trigger
in `adr-gate.yml` if yours isn't.

### Organizations as code

There is nothing to copy: our implementation is private. Appendix A of the
spec describes its shape:
a coverage file per provider built from the provider's own schema, a gate
that fails on any setting neither set nor excluded with a reason, and a
scheduled check against the live settings.

## This repository uses its own specs

Its decisions are records in [`docs/adr/`](docs/adr), checked in CI by
the implementation above. Its GitHub settings and rulesets are managed
by our org-as-code implementation, and you can read the live rules yourself:

```sh
curl https://api.github.com/repos/perimetercompute/specs/rules/branches/main
```

## Changing a spec

A change to a `SPEC.md` is a decision, so its pull request adds a new record
to [`docs/adr/`](docs/adr) saying why. CI fails a spec change that adds no
record, and keeps the pull request red until the record is `accepted`, which
our rules allow only after a maintainer approves it in their own words. [CONTRIBUTING.md](CONTRIBUTING.md) covers what belongs
here and how a spec is laid out.

## License

[MIT](LICENSE)
