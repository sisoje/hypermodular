# Reverse-engineering — mapping a codebase that already exists

The legacy job: code exists, no map does. The first map of a codebase is
a free architecture review — present it as one. `notation.md` has the
grammar; `coreflow-example-validation.md` is a complete worked run.

## The walk

Walk the instantiation graph from the entry point downward — every
`@main`, then what each constructs, then what those construct. Those
are the solid arrows. Apply the cut rules *while walking*, not after an
inventory: a subtree becomes its own node only when it joins the app
lifecycle independently (own outliving state, appearance work, a
navigation destination, its own boundary call); everything else
collapses into its parent as furniture.

Find every I/O touchpoint — network, storage, DI/environment, timers,
notifications, launch arguments — and attribute each to the node that
**decides** it. That node gets the contract line; the service becomes a
cylinder, named for the boundary rather than the tech (`dbService`,
never `swiftData`). Native materialization (`@Query`, `@AppStorage`)
becomes an `· @Source` line on the node that holds it, not a cylinder.

Collect shared models and service signatures into the coupling diagram
as you go. Then verify injection happens only at the root: every place
a service enters the environment below the root is a finding, not
something to draw around.

## Write the maps

Depth-1 blocks with identity headers, `APP-MAP.md` at the root, a
`MAP.md` beside every node with children. Run `scripts/mapcheck.py`
before presenting — a map that doesn't reconstruct is not finished.

**Evidence is not reverse-engineered.** Draw an evidence block only
where the code already carries a pinned log — an existing test that
asserts a sequence. Never invent acceptance criteria from code: a node
with calls on its label and no block is a finding to report, not a gap
to fill. The behavior of legacy code is what it does, not what someone
decided, and the map must not pretend otherwise.

## What legacy code will throw at the notation

Each of these was met mapping CoreFlowExample and is ruled in
`notation.md`; expect them:

- **Several entry points over one library.** One tree per `@main` in
  `APP-MAP.md`; names unique across the repo.
- **Built but mounted nowhere.** Components that exist, are tested, and
  are composed by no root. They go under `## Unmounted` with their
  full label and no arrows — so the contract has a copy to compare
  against the day something mounts them.
- **A decision with no contract line naming its value.** Launch
  environment, process arguments: `· @ProcessInfo`.
- **Closures handed down by a parent.** `onSave`, `getUserName` — bare
  `· name` callback lines, not capabilities.
- **Modifiers and injectors.** A `ViewModifier` with own state only is
  furniture; the modifier that assembles a capability and injects it is
  implementation detail. Neither is drawn.
- **Injection below the root.** The most common finding in a layered
  codebase, and the one most worth reporting first.

## What to present

The maps, plus the two or three most interesting things they reveal.
Typical candidates: a dependency box far larger than the feature count
suggests; modules that share so many types they are secretly one;
injection leaking into the tree; a decision that lives in a
surprising node; components nobody mounts. Say what each would take to
fix, and leave the ruling to the user.

## Worked example

`coreflow-example-validation.md` maps CoreFlowExample with the skill
as-is — two entry points, eight components, one cylinder — and records
where the notation creaked. Its findings F1–F6 became the rulings
listed above; its Part 2 transcribes the example's eight pinned logs as
evidence blocks, the one case where evidence *can* be reverse-engineered
because the logs already existed.
