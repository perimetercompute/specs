# Perimeter Compute specs

Specifications for repositories, and the organizations that own them, where AI
agents write most of the changes.

Each spec solves one problem. You can use a spec with the tools that you use
now. The specs use the RFC 2119 keywords MUST and SHOULD.

| Spec | Problem | Solution | Status |
|---|---|---|---|
| **[Append-only ADRs](append-only-adr/SPEC.md)** (Architecture Decision Records) | Agents change decisions that nobody wrote down. | Write each decision as a record in a log. A person approves each record in their own words. After the merge, CI does not let anyone change the record. | Draft 1 |
| **[Organizations as code](org-as-code/SPEC.md)** | Agents cannot safely change settings in a web console. | Keep the settings of the organization in code. Make a decision about each setting. On a schedule, compare the code with the live settings. | Draft 1 |

You can use one spec without the other.

## Adopt a spec

1. Read the spec.
2. Select a conformance level. Each spec has levels, so you can say which
   level you meet.
3. Build the spec with your own tools.

### Append-only ADRs

This repository has an implementation for GitHub Actions. To use it, do these
steps:

1. Make a pull request. Copy these files into it:
   - [`tools/adr-gate.sh`](tools/adr-gate.sh)
   - [`.github/workflows/adr-gate.yml`](.github/workflows/adr-gate.yml)
   - [`.github/workflows/adr-gate-trusted.yml`](.github/workflows/adr-gate-trusted.yml)
   - [`docs/adr/README.md`](docs/adr/README.md), which has the rules and the
     record template

   Do not copy our records or their manifest entries.
2. In the same pull request, write your first record from the template. Set
   `status: proposed`.
3. Add the hash of the record to the manifest:

   ```sh
   shasum -a 256 docs/adr/<id>.md > docs/adr/adr-manifest/<id>.txt
   ```

   The gate fails while the status is `proposed`. This is correct.
4. Ask a person to approve the record. Copy their words into the Human intent
   section.
5. Set `status: accepted`. Run the `shasum` command again. Merge the pull
   request.
6. Add an organization ruleset that requires `adr-gate-trusted`. This workflow
   runs the gate from your default branch, so a pull request cannot change the
   check.

If your default branch is not `main`, change the `push` trigger in
`adr-gate.yml`.

### Organizations as code

Our implementation is private, so you cannot copy it. Appendix A of the spec
shows its parts:

- A coverage file for each provider, made from the provider's schema.
- A gate that fails if a setting is not in code and has no written reason for
  its exclusion.
- A scheduled check that compares the code with the live settings.

## This repository uses its own specs

The decisions for this repository are records in [`docs/adr/`](docs/adr). The
gate above checks them in CI. Our org-as-code implementation manages the
GitHub settings of this repository. To see the live rules, run this command:

```sh
curl https://api.github.com/repos/perimetercompute/specs/rules/branches/main
```

## Change a spec

A change to a `SPEC.md` file is a decision. The pull request for the change
must add a new record to [`docs/adr/`](docs/adr) that tells why. CI fails if
there is no new record. CI also fails until the record has `status: accepted`.
Our rules let an author set `accepted` only after a maintainer approves the
record in their own words.

For the scope of this repository and the sections of a spec, see
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
