# AGENTS.md: hypermodular

This repo defines the hypermodular method (Top-Down Development).
`hypermodular/SKILL.md` is the source of truth for the maps and
`data-coupling/SKILL.md` for the code. This file is your working
summary. When the two disagree, `SKILL.md` wins. Flag the
disagreement. The skill's `references/` hold the detail:
`architecting.md` (new app or feature), `reverse-engineering.md`
(legacy codebase), `notation.md` (the complete grammar and the
checker), `evidence.md` (declaring behavior as a log),
`coreflow-example-validation.md` (a worked run with every finding).

## What this repo is

A top-down app-making engine for agents, as two skills and a method.
`hypermodular/` models apps as depth-1
Mermaid maps (`APP-MAP.md` at a repo root, `MAP.md` beside each mapped
subtree). The maps are the architecture doc, the agent work fence, and
the review surface, all at once. `data-coupling/` is the code side: how
a SwiftUI node is written, cut into shell and core, tested by its
execution log, and how an app's modules meet through one data layer.
The maps describe what the code does. `data-coupling/SKILL.md` is the
authority on how the code looks. There is no build step. The
deliverable is the doctrine. The one piece of code is
`hypermodular/scripts/mapcheck.py`, the registry check, the maps alone
and with `--sources` the maps against the Swift (`scripts/test.sh`
runs its fixtures).

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
   throws`, logs. Reads never do. A write logs iff it lands in a source
   of truth the node owns or was handed, whoever holds the pen. Never a
   mock object, never observe effects behind a boundary. A boundary in
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
| `Node["Name<br/>· @Query<br/>· dep.func()<br/>· dep.value<br/>· $sortByAuthor<br/>· onSave"]` | Label = name, then one contract line per line, each starting `· ` (the name is the text before the first `·`). Five kinds. `· @Source` materializes (`@` is the marker; a source of truth that outlives the node: store, scene storage, focus; reads log nothing, writes log like any write). `· dep.func()` calls a capability and logs; the parens are the mark. `· dismiss()`, a sealed action Apple sets, is a call with no cylinder. `· dep.value` reads a let or binding off a dependency and never logs. `· $path` writes a binding the node was handed, `$sortByAuthor` from the parent or `$settings.city` off a cylinder; the write logs and some block must name it. Bare `· name` calls back a parent-supplied closure. A name-only label receives everything and calls nothing. |
| `svc[(svc)]` | Dependency cylinder. Named for the boundary, not the tech (`dbService`, never `swiftData`). |
| `subgraph Dependencies` | One solid unfilled box holding all cylinders, ordered top to bottom in the order the root sets them. Derived services list their ingredients, which must sit above them. |
| `A ~~~ B` | Invisible link. Orders the dependency column. |
| `%% Root: X · Parent: Y (../MAP.md)` | First line of every mermaid block. Self-describing placement. |
| `%% Evidence: X · Parent: Y (../MAP.md)` + `%% Given: …` + `sequenceDiagram` | Diagram 4, one per acceptance criterion whose log crosses the node's edge. In-arrows are the when (`User`, `System`, or a child's callback), out-arrows the log in order, dashed arrows supplied data, `loop` a count unnamed, `Note` silence. Targets are contract lines or stored properties (own state, materialized sources). Quote mermaid-reserved names (`"title"`). Lives in the node's own `MAP.md` under `## Evidence`. Own-state-only criteria stay arrays in the test. |

Style: mermaid id = node name, always (the name is the merge key). No
colors, no fills (`fill:none` on the Dependencies box, the one
subgraph), no emoji, no status marks.

## Hard rules

- **One tree per shipped `@main`** in `APP-MAP.md`; a test host is
  none. Names unique across the repo. Built-but-unmounted components go
  under `## Unmounted`.
- **No cross-feature arrows.** Navigation across features is a call to
  `navService` with a route and data. The caller never knows which node
  answers. A node's own sheet or stack is its own state, lifted only
  when another node must drive it.
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
- **Dependencies are environment values**: plain structs composed of
  closures, lets, or bindings. No protocols, no classes, no reference
  types. Setting = putting a value into the environment at the root.
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
  design-system pieces) never gets a node. The contract is what crosses
  the node's edge. A subtree splits out only when it joins the app
  lifecycle on its own (own outliving state, appearance work,
  navigation destination, own boundary call).
- **Shell/core split is implementation detail** and is never drawn.
  How to cut, by hand or with `@Shell`:
  `data-coupling/references/shell-core.md`.
- **Leaves get no structure map.** A map earns its existence by having
  arrows. A leaf's contract lives in its parent's map. A leaf whose
  evidence crosses its edge gets a `MAP.md` of evidence only.
- **Contracts are duplicated on purpose** (parent's map and own map,
  identical). A mismatch between copies is an unreviewed design change.
  A contract change must touch both maps in the same commit.

## Workflows

- **Mapping an existing codebase**: walk instantiation from the entry
  point (solid arrows), attribute each I/O call to the node that decides
  it, apply the cut rules while walking, extract shared types and
  services into the coupling diagram, verify values are set at the root
  only. Present the map plus the two or three most interesting findings.
- **New feature in a mapped repo**: add nodes and arrows to the map
  first, agree the diff, then build root-down, evidence declared before
  code.
- **Maintenance**: the map is code. Update affected maps (structure or
  evidence) in the same commit as the change, and run `mapcheck.py`
  with `--sources` on the code.
  Reverse-engineering never invents evidence: draw a block only where a
  pinned log already exists. Read `APP-MAP.md` before reading code. If
  map and code disagree, say so. Never work around it without saying.

## Prose

Every file here is doctrine an agent reads verbatim, so it is written
plainly. No em dashes. No colon joining two clauses into one sentence.
No figurative phrasing, no padding. A cleanup keeps every fact. Rewrite
the sentence, never drop what it said. The clarity test for the code
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
skills, a one-paragraph brief, an empty directory, and the agent must
draw, check, declare, and build. Grade it by `mapcheck.py`, `swift
build`, and whether the declared arrays are the ones its scenarios
produce. `scripts/engine-run-prompt-coreflow.md` is the same brief cut
with `@Shell`, depending on the sibling `../CoreFlow` checkout.
`scripts/engine-run-prompt-garden.md` is a brief the method did not
shape, in the product's words, for finding what the rules cannot
express.

## Related

- `data-coupling/` in this repo: what a node's implementation should
  look like. The model, the cut, the log, the layer.
- `sisoje/swift-core-flow`: the shell/core split and execution-log
  testing, mechanized as Swift macros.
