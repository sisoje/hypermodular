# Architecting: a new app or feature, top-down

The forward job. Nothing exists yet, or a feature is being added to a
mapped repo. Read this before drawing. `notation.md` has the grammar,
`evidence.md` the declaration rules.

## Who decides

An app is a tree of behavior that someone with authority decided: the
product owner, the designer, whoever owns what the thing is. It is not
an object graph and not a backlog. The map makes that decision explicit
and therefore reviewable. The owner decides the structure, the
structure dictates the signatures, the implementations satisfy them. A
change of mind at the top has one place to land, and everything below
it that no longer fits stops compiling instead of drifting.

Draw with the user. Iterating on a diagram is cheap, which is the
point, so offer alternatives, label the decisions, and get the tree
agreed before anything is built.

The alternative is the one everybody knows. Build from the bottom, and
you never know when a layer is finished. Nothing above it exists yet to
ask it for anything, so its shape is a guess, and the guess is checked
only when the screen finally runs. Top-down inverts that. Each
implementation arrives to find its consumer, and its consumer's
evidence, already written, so it is finished the moment that evidence
holds.

## The order of work

1. **Draw the structure.** `APP-MAP.md` with the root tree, the
   dependency column, the coupling diagram. A `MAP.md` beside every
   node that has children. Every node carries its full label. Every
   block declares its place. Unbuilt leaves are finished design. A leaf
   with no insides is mapped, reachable, and empty, and that is
   correct.
2. **Declare the evidence.** For every node whose log crosses its edge,
   one evidence block per acceptance criterion, in the node's own
   `MAP.md`, before any code. Own-state-only criteria are written as
   arrays in the test, also before code. A node with calls on its label
   and no block is not ready to build.
3. **Run the checker.** `scripts/mapcheck.py` on the repo: zero errors,
   and every warning understood. The map is now the work fence.
4. **Build root-down.** Implement a node only after its parent exists.
   For each node, its evidence holds (the test compares two values and
   passes) before the next node is started. Hand it literals for data
   and loggers for closures. Nothing beneath it needs to exist.
5. **Satisfy the cylinders last.** Fetch, storage, service: all
   eventually. Each live closure arrives to find its consumers and
   their evidence already written, and is tested once, for real, in
   one integration test at the shell.

The feature inherits nothing and decides everything. Each
implementation arrives to find its consumer's tests already written.

## A feature in a mapped repo

New features enter the map first. Add the nodes and arrows, name the
capabilities, update every label copy in the same diff, and agree that
diff before code. The map diff is the design review. It shows where a
decision moved, what a node now asks of the world, and which existing
contracts changed. Needing a capability that is not on the map means
stopping and proposing a map change, not reaching for it.

Then the same order: evidence for the new or changed nodes, checker,
root-down build, cylinders last.

## What to present

The maps, rendered. The decisions the tree encodes; every labeled
alternative arrow is one. The dependency box, because its size is a
health metric on its own. And the open questions: a cut you were unsure
of, a capability that might be two, a node that might be furniture.
Those are the user's to rule on, and the map is the cheapest place to
rule.
