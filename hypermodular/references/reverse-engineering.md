# Reverse-engineering: mapping a codebase that already exists

The legacy job. Code exists, no map does. The first map of a codebase
is a free architecture review. Present it as one. `notation.md` has the
grammar. `coreflow-example-validation.md` is a complete worked run.

## The map cuts across the layers

A layered codebase (UI, ViewModel, service, repository, networking) has
a vertical axis, and it means existence: what had to be built before
what. The map's vertical means authority: who decides, and what they
ask of the world. The two will not line up, and the map must not be
bent to mirror the layers that happen to be in front of you. A feature
that is smeared across five layers, present everywhere and
constructible nowhere, becomes one node with an address, its contract
lines naming the I/O it decides, and the layers it was smeared across
become, at most, cylinders in the dependency box. Draw the decisions,
not the directories.

## The walk

Walk the instantiation graph from the entry point downward: every
`@main`, then what each constructs, then what those construct. Those
are the solid arrows. Apply the cut rules while walking, not after an
inventory. A subtree becomes its own node only when it joins the app
lifecycle on its own (own outliving state, appearance work, a
navigation destination, its own boundary call). Everything else
collapses into its parent as furniture.

Find every I/O touchpoint (network, storage, environment, timers,
notifications, launch arguments) and attribute each to the node that
decides it. That node gets the contract line. The service becomes a
cylinder, named for the boundary rather than the tech (`dbService`,
never `swiftData`). Native materialization (`@Query`)
becomes an `· @Source` line on the node that holds it, not a cylinder.

Collect shared models and service signatures into the coupling diagram
as you go. Then verify values are set at the root only. Every place a
service enters the environment below the root is a finding, not
something to draw around.

## Write the maps

Depth-1 blocks with identity headers, `APP-MAP.md` at the root, a
`MAP.md` beside every node with children. Run `scripts/mapcheck.py`
before presenting. A map that does not reconstruct is not finished.

**Evidence is not reverse-engineered.** Draw an evidence block only
where the code already carries a pinned log, an existing test that
asserts a sequence. Never invent acceptance criteria from code. A node
with calls on its label and no block is a finding to report, not a gap
to fill. The behavior of legacy code is what it does, not what someone
decided, and the map must not pretend otherwise.

## What legacy code will throw at the notation

Each of these was met mapping CoreFlowExample and is ruled in
`notation.md`. Expect them.

- **Several entry points over one library.** One tree per shipped
  `@main` in `APP-MAP.md`; a test host is none. Names unique across the
  repo.
- **Built but mounted nowhere.** Components that exist, are tested, and
  are composed by no root. They go under `## Unmounted` with their full
  label and no arrows, so the contract has a copy to compare against
  the day something mounts them.
- **A decision with no contract line naming its value.** Launch
  environment, process arguments: `· @ProcessInfo`.
- **Closures handed down by a parent.** `onSave`, `getUserName`: bare
  `· name` callback lines, not capabilities.
- **Modifiers that set values.** A `ViewModifier` with own state only is
  furniture. The modifier that assembles a capability and sets it into
  the environment is implementation detail. Neither is drawn.
- **A value set below the root.** The most common finding in a layered
  codebase, and the one most worth reporting first.

## What to present

First, the answer to the question the map exists to ask: where is the
feature? In a layered codebase the honest answer is that it had no
address until now, and the first map is the artifact that gives every
feature one. Say which nodes the user's features turned out to be, and
which of them had been spread across layers with nothing to construct.

Then the maps, plus the two or three most interesting things they
reveal. Typical candidates: a dependency box far larger than the
feature count suggests; modules that share so many types they are one
module in disguise; values set below the root; a decision that lives in
a surprising node; components nobody mounts. Say what each would take
to fix, and leave the ruling to the user.

## Worked example

`coreflow-example-validation.md` maps CoreFlowExample with the skill
as-is (two entry points, eight components, one cylinder) and records
where the notation creaked. Its findings F1 to F6 became the rulings
listed above. Its Part 2 transcribes the example's eight pinned logs as
evidence blocks, the one case where evidence can be reverse-engineered,
because the logs already existed.
