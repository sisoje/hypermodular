# AGENTS.md: hypermodular

This repo defines the hypermodular method (Top-Down Development).
`hypermodular/SKILL.md` is the source of truth for the maps and
`data-coupling/SKILL.md` for the code. This file is your working
summary. What wins, in order: a ruling recorded in `TODO.md`, then
the two skills, then this file, then the owner's articles the skills
were distilled from. Flag a disagreement, do not obey it. Any rule in
either skill may be broken whenever breaking it saves time or is the
more practical thing to do. Practicality outranks the rule. The break
is said out loud, with the rule and the reason. The skill's
`references/` hold the detail:
`architecting.md` (new app or feature), `reverse-engineering.md`
(legacy codebase), `notation.md` (the complete grammar and the
checker), `evidence.md` (declaring behavior as a log),
`coreflow-example-validation.md` (a worked run with every finding).

## What this repo is

A top-down app-making engine for agents, as two skills and a method,
and a third small skill, `xcode-project/`, for the one tool the engine
needs that agents do not know, Apple's `xcrun xcodeproj`, with which a
`generate.sh` writes an app's Xcode project.
`hypermodular/` models apps as depth-1
Mermaid maps (`APP-MAP.md` at the repo root, one directory per node
under `Maps/` holding its `MAP.md` and a file per flow). The maps are the architecture doc, the agent work fence, and
the review surface, all at once. `data-coupling/` is the code side: how
a SwiftUI node is written, cut into shell and core, tested by its
execution log, and how an app's modules meet through one data layer.
The maps describe what the code does. `data-coupling/SKILL.md` is the
authority on how the code looks. There is no build step. The
deliverable is the doctrine. The one piece of code is
`hypermodular/scripts/mapcheck.py`, the registry check, the maps alone
and with `--sources` the maps against the Swift, where it also warns
on a `Task` nobody holds (`scripts/test.sh` runs its fixtures).

## The three rules (follow them in any mapped repo)

1. **Build top-down.** Implement a node only after its parent exists.
   New features are drawn on the map before any code is written.
2. **Respect the map.** When working on a node, touch only that node's
   code and the capabilities named in its own label. Need something not
   on the map? Stop, propose a map change, get the diff agreed. The map
   diff is the design review.
3. **Evidence, not effects.** Declare a node's behavior as data before
   implementing: values in, ordered execution log out. Every
   source-of-truth write and every boundary call, sync or `async
   throws`, logs. Reads do not. A write logs iff it lands in a source
   of truth the node owns or was handed, whoever holds the pen. No mock
   object is written, and effects behind a boundary are not observed. A boundary in
   a spec is a logger. Checking a node is comparing two values.

## One law: depth 1, the cure for death by a thousand mocks

Boundaries log one step deep. Dependencies enter the flow only at the
root. Maps draw only one level. Every artifact describes one boundary,
its own.

## Notation cheat sheet

| Mark | Meaning |
|------|---------|
| `A --> B` | Data flow: parent hands facts, bindings, and callbacks down. Also root to Dependencies box (setting a value is normal data flow). |
| `A -->\|cond\| B` | A presence condition: the child exists while the labeled value holds. Arrows on the same deciding value are alternatives, on different values independent. Unlabeled arrows are composition (children coexist). |
| `Node["Name<br/>· @Query<br/>· dep.func()<br/>· dep.value<br/>· $sortByAuthor<br/>· onSave"]` | Label = name, then one contract line per line, each starting `· ` (the name is the text before the first `·`). Five kinds. `· @Source` materializes (`@` is the marker; a source of truth that outlives the node: store, scene storage, or focus, which the system owns and the node writes; reads log nothing, writes log like any write). `· dep.func()` calls a capability and logs; the parens are the mark. `· dismiss()`, a sealed action Apple sets, is a call with no cylinder. `· dep.value` reads a let or binding off a dependency and does not log. `· $path` writes a binding the node was handed, `$sortByAuthor` from the parent or `$settings.city` off a cylinder; the write logs and the checker reports a block that does not name it. Bare `· name` calls back a parent-supplied closure. A name-only label receives everything and calls nothing. |
| `svc[(svc)]` | Dependency cylinder. Named for the boundary, not the tech (`dbService`, not `swiftData`). |
| `subgraph Dependencies` | One solid unfilled box holding all cylinders, ordered top to bottom in the order the root sets them. Derived services list their ingredients, which sit above them. |
| `A ~~~ B` | Invisible link. Orders the dependency column. |
| `%% Root: X · Parent: Y (../MAP.md)` | First line of every mermaid block. Self-describing placement. |
| `%% Whole: X` | The whole app in one diagram, first in `APP-MAP.md`. `mapcheck.py --write` draws it by merging the depth-1 blocks on node names. Not written by hand. A stale one is a checker error. |
| `%% Evidence: X · Parent: Y (../MAP.md)` + `%% Given: …` + `sequenceDiagram` | Diagram 4, one per acceptance criterion whose log crosses the node's edge. In-arrows are the when (`User`, `System`, or a child's callback), out-arrows the log in order, dashed arrows supplied data, `loop` a count unnamed, `Note` silence. Targets are contract lines or stored properties (own state, materialized sources). Quote mermaid-reserved names (`"title"`). Lives in a flow file of its own, `Maps/<Node>/<Criterion>.md`, one block per file. Own-state-only criteria stay arrays in the test. |

Style: mermaid id = node name (the name is the merge key). No
colors, no fills (`fill:none` on the Dependencies box, the one
subgraph), no emoji, no status marks.

## Hard rules

- **Lift, whatever is being made, and keep the state apart from the
  behavior that mutates it.** State drives a node, and the driver is
  kept apart from it. The state goes out of the view to the node above
  that can own it, as open data. The mutating behavior goes out too,
  as closures the root sets, operating on bindings, or where it must
  hold a reference on an `@Observable` class it mutates, and as rules
  that run above the view. The two are kept apart, not one object
  holding both. "Logic" is not the word. A SwiftUI node is not a
  physical view the way a UIKit view is. It only transforms its
  dependencies, so there is nothing to attach a ViewModel to.
- **One tree per shipped `@main`** in `APP-MAP.md`; a test host is
  none. Names unique across the repo. Built-but-unmounted components go
  under `## Unmounted`.
- **No cross-feature arrows.** Navigation across features is a call to
  `navService` with a route and data. The caller does not know which node
  answers. A node's own sheet or stack is its own state, lifted only
  when another node must drive it. A system event the stack's owner
  subscribes to is not a cross-feature call.
- **Four keys decide a design: construction, usage, actions,
  mockability.** Whatever the root can name it builds and hands down
  as a projection, `@AppStorage` by its key, the container, the
  session; a node's own `@State` it could only invent, so that stays;
  a `@Query` is a read, a filtered projection of the store, placed
  where it is read. A feature receives what it uses, a fact, a binding, a
  closure.
  Behavior is closures the root sets, and a write or a call is the
  event. Every boundary is a value a scenario stands in for, so the
  test is the log.
- **Screen first.** A core is modeled directly from the screen, one
  property per thing it shows or accepts, a `let` for a label, a
  `@Binding` for a field, a closure for a button. What the design says
  the screen does, "if error then", is the core's logic and stays in
  it. Whether there is an error is decided above. One screen at a
  time, nothing generic. A screen is cheap and reads like a book.
- **No invented model in a feature.** A struct or an enum that groups
  facts exists because the data layer already defines it. A feature's
  state is loose fields, not a load-state enum. Loose fields are
  orthogonal, so they compose.
- **No `Task` nobody holds.** Work an event starts is a task assigned
  to an `@UnstructuredTask` slot, which cancels on replacement and on
  node removal. `.task` is the runtime's event, kept for appearance
  and for a value that already exists. Creation is not lifecycle, so
  a closure the root sets starts no `Task` either.
- **Dependencies are environment values**: plain structs composed of
  closures, lets, or bindings. Every dependency has two parts. How it
  is constructed is the app's knowledge, the inputs the root supplies.
  How it is used is its capabilities, the contract's members, and
  they are all a feature sees. No protocols, no classes, no reference
  types, with the three protocol cases and the two class cases, data
  that earns it and a framework delegate, the code skill names. Setting =
  putting a value into the environment at the root. A dependency that
  does I/O is its own package under `Packages/Dependencies/`, however
  small. It sees the data coupling layer and what it wraps, not a
  feature, not another dependency, and it exposes one public
  `inject` view modifier. The layer re-exports swift-core-flow and the
  features re-export the layer, so a feature file imports neither.
  Deriving = building a new value from values already there. No
  `.live`, `.preview`, or `.unimplemented` statics and no `+Live`
  files. The root builds the live value inline where it sets it. The
  default is the minimal no-op and serves previews and tests. Detail:
  `data-coupling/references/modules.md`.
- **Native materialization (`@Query`) gets no cylinder.** The root does
  not set it. It is facts arriving, tagged as `@` lines. The root's
  `@AppStorage` reaches features as bindings, through the init or a
  `settings` cylinder. Only consumption couples: a call logs, a read
  does not. `dbService` is writes only; a write may return a result, an
  id or an error.
- **A node is a collapsed subtree.** View furniture (rows, buttons,
  design-system pieces) does not get a node. The contract is what crosses
  the node's edge. A subtree splits out only when it joins the app
  lifecycle on its own (own outliving state, appearance work,
  navigation destination, own boundary call or callback).
- **Shell/core split is implementation detail** and is not drawn.
  The cut is by hand or with `@Shell`, judged per view, and
  `data-coupling/references/shell-core.md` says how.
- **Leaves get no structure map.** A map earns its existence by having
  arrows. A leaf's contract lives in its parent's map. A leaf whose
  evidence crosses its edge gets a directory of flow files and no
  `MAP.md`.
- **Contracts are duplicated on purpose** (parent's map and own map,
  identical). A mismatch between copies is an unreviewed design change.
  A contract change touches both maps in the same commit.

## Workflows

- **Mapping an existing codebase**: walk instantiation from the entry
  point (solid arrows), attribute each I/O call to the node that decides
  it, apply the cut rules while walking, extract shared types and
  services into the coupling diagram, verify values are set at the root
  only. Present the map plus the findings.
- **New app**: maps first, then evidence, then code laid out as
  `data-coupling/references/app-structure.md` gives it, the layer, the
  features, one package per dependency, the one-file app target under
  `App/`, the test host, and the UI-test bundle, the Xcode project
  written by `App/generate.sh` as `xcode-project/SKILL.md` teaches.
- **New feature in a mapped repo**: add nodes and arrows to the map
  first, agree the diff, then build root-down, evidence declared before
  code.
- **Converting an existing codebase**: map it first, then one node at
  a time. A view with its own wrappers gets `@Shell` as it stands. A
  view driven by an object is modeled again from its screen, and the
  object is taken apart by the table in
  `data-coupling/references/converting.md`. The service behind it is
  wrapped in a contract at the root and not rewritten.
- **Maintenance**: the map is code. Update affected maps (structure or
  evidence) in the same commit as the change, and run `mapcheck.py`
  with `--sources` on the code.
  Reverse-engineering does not invent evidence: draw a block only where a
  pinned log already exists. Read `APP-MAP.md` before reading code. If
  map and code disagree, say so. Do not work around it without saying.

## Prose

Every file here is doctrine an agent reads verbatim, so it is written
plainly. No em dashes. No colon joining two clauses into one sentence.
No figurative phrasing, no padding. A cleanup keeps every fact. Rewrite
the sentence, do not drop what it said. The clarity test for the code
skill is `data-coupling/scripts/comprehension-prompt.md`, and
`comprehension-prompt-2.md` covers the binding, networking, and layer
passages the first does not reach. The mapping skill's test is
`hypermodular/scripts/comprehension-prompt.md`. Hand any of them,
verbatim and with nothing else, to a model that has not read the skill
(`codex exec -C . -s read-only -m <model> - < that file`, or a fresh
subagent), then fix every sentence it misreads. Every wrong answer is
a sentence to improve, wherever the fault lies, a line the model did
not find included. A judgment the skill leaves to the core's need is
not an error. The engine run is `scripts/engine-run-prompt.md`: both
skills, a one-paragraph brief, an empty directory, and the agent
draws, checks, declares, and builds. Grade it by `mapcheck.py`, `swift
build`, and whether the declared arrays are the ones its scenarios
produce. `scripts/engine-run-prompt-coreflow.md` is the same brief cut
with `@Shell`, depending on the sibling `../CoreFlow` checkout.
`scripts/engine-run-prompt-garden.md` is a brief the method did not
shape, in the product's words, for finding what the rules cannot
express. `scripts/engine-run-prompt-address.md` is a validated form,
a brief that tempts a validator object. Those two are written as a
brief is given to a person: the skills to read, the app in the
product's words, the machine's limits, and what to report. They name
no architecture, no layout, no order of work, and no forbidden
pattern. All of that is the skills' to teach, and a run that needs it
in the prompt has found a gap in a skill. What a run finds goes into
a skill as the rule that holds for any app. The run's own names, its
targets, and its workarounds stay out. The
drift review is `scripts/drift-review-prompt.md`: export the first
five commits, hand the prompt to a fresh model, and read what it calls
lost, reversed, or contradictory. Run it after a stretch of rulings;
three readers ran it on 2026-11-09 and their findings are under F32 in
`TODO.md`.

## Related

- `data-coupling/` in this repo: what a node's implementation should
  look like. The model, the cut, the log, the layer.
- `sisoje/swift-core-flow`: the shell/core split and execution-log
  testing, mechanized as Swift macros.
