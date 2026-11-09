# Fixtures for mapcheck.py

- `clean/`: CoreFlowExample's maps as validated in
  `references/coreflow-example-validation.md`, with the two feature
  `@AppStorage` lines lifted to the root as a `settings` cylinder and
  written as dotted `$` lines (2026-11-09). Correct; usable as examples.
- `broken/`: the same maps with fourteen errors and two warnings planted
  (depth-2 arrows, an orphan, a label mismatch, a missing cylinder, a
  reserved-word target, an unlabelled evidence call, a dotted `$` line
  with no cylinder, a mis-ordered
  dependency column, a missing Given, a dashed arrow to the wrong
  participant …). Wrong on purpose, never an example of the notation.

Each fixture has a `Sources/` of Swift stubs, never compiled, for the
code-side half (`--sources`). The clean stubs verify every bare
evidence target; the broken ones plant a call with no label line, an
`@AppStorage` below the root, a label line with no code behind it, an
evidence target that is no stored property, and a view on no map that
reads a cylinder.

`sh scripts/test.sh` asserts the clean fixture has zero errors and the
broken one reports exactly the planted list, nothing more, with and
without `--sources`.
