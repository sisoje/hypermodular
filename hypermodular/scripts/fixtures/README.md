# Fixtures for mapcheck.py

- `clean/`: CoreFlowExample's maps as validated in
  `references/coreflow-example-validation.md`. Correct; usable as examples.
- `broken/`: the same maps with thirteen errors and two warnings planted
  (depth-2 arrows, an orphan, a label mismatch, a missing cylinder, a
  reserved-word target, an unlabelled evidence call, a mis-ordered
  dependency column, a missing Given, a dashed arrow to the wrong
  participant …). Wrong on purpose, never an example of the notation.

`sh scripts/test.sh` asserts the clean fixture has zero errors and the
broken one reports exactly the planted list, nothing more.
