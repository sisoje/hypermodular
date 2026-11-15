# Fixtures for mapcheck.py

- `clean/`: CoreFlowExample's maps as validated in
  `references/coreflow-example-validation.md`, with the two feature
  `@AppStorage` lines lifted to the root as a `settings` cylinder and
  written as dotted `$` lines (2026-11-09), and `SaveButton`'s stub
  holding its task in a slot, with the assignment declared in its
  block (2026-11-10, F37), and the whole-app diagram the checker
  draws with `--write` first in `APP-MAP.md` (2026-11-12), the node
  maps under `Maps/` and each evidence block a flow file of its own
  (2026-11-12, F61 and F63). Correct; usable as examples.
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
reads a cylinder, and a presence-condition arrow whose label names
nothing the node holds, and a flow called with no label line; with
the two planted stale labels that is nine code errors and one
warning. Four more warnings are planted for habits no map can show,
two `Task`s nobody holds and two lifecycle modifiers in a view. One
of the two tasks is made in a closure handed to `map`, on a line
whose only `=` is a default argument (F106).
`Furniture` also assigns a task through an optional's `map`, on one
line and on two. That task is held and raises nothing (F99).

`sh scripts/test.sh` asserts the clean fixture has zero errors and the
broken one reports exactly the planted list, nothing more, with and
without `--sources`.
