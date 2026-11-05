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

Two agent skills and a method. `hypermodular/` models apps as depth-1
Mermaid maps (`APP-MAP.md` at a repo root, `MAP.md` beside each mapped
subtree). The maps are the architecture doc, the agent work fence, and
the review surface, all at once. `data-coupling/` is the code side: how
a SwiftUI node is written, cut into shell and core, tested by its
execution log, and how an app's modules meet through one data layer.
The maps describe what the code does. `data-coupling/SKILL.md` is the
authority on how the code looks. There is no build step. The
deliverable is the doctrine. The one piece of code is
`hypermodular/scripts/mapcheck.py`, the map-side registry check
(`scripts/test.sh` runs its fixtures).

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
   of truth the node owns or was handed, whoever holds the pen. Never
   mock, never observe effects behind a boundary. A boundary in a spec
   is a logger. Checking a node is comparing two values.

## One law: depth 1, the cure for death by a thousand mocks

Boundaries log one step deep. Dependencies enter the flow only at the
root. Maps draw only one level. Every artifact describes one boundary,
its own.

## Notation cheat sheet

| Mark | Meaning |
|------|---------|
| `A --> B` | Data flow: parent hands facts, bindings, and callbacks down. Also root to Dependencies box (setting a value is normal data flow). |
| `A -->\|cond\| B` | Decision alternative, labeled with the selecting value. Unlabeled arrows are composition (children coexist). |
| `Node["Name<br/>· @Query<br/>· dep.func()<br/>· dep.value<br/>· onSave"]` | Label = name, then one contract line per line, each starting `· ` (the name is the text before the first `·`). Four kinds. `· @Source` materializes (`@` is the marker; a source of truth that outlives the node: store, defaults, focus; reads log nothing, writes log like any write). `· dep.func()` calls a capability and logs; the parens are the mark. `· dep.value` reads a let or binding off a dependency and never logs. Bare `· name` calls back a parent-supplied closure. A name-only label receives everything and calls nothing. |
| `svc[(svc)]` | Dependency cylinder. Named for the boundary, not the tech (`dbService`, never `swiftData`). |
| `subgraph Dependencies` | One solid unfilled box holding all cylinders, ordered top to bottom in the order the root sets them. Derived services list their ingredients, which must sit above them. |
| `A ~~~ B` | Invisible link. Orders the dependency column. |
| `%% Root: X · Parent: Y (../MAP.md)` | First line of every mermaid block. Self-describing placement. |
| `%% Evidence: X · Parent: Y (../MAP.md)` + `%% Given: …` + `sequenceDiagram` | Diagram 4, one per acceptance criterion whose log crosses the node's edge. In-arrows are the when (`User`, `System`, or a child's callback), out-arrows the log in order, dashed arrows supplied data, `loop` a count unnamed, `Note` silence. Targets are contract lines or stored properties (own state, materialized sources). Quote mermaid-reserved names (`"title"`). Lives in the node's own `MAP.md` under `## Evidence`. Own-state-only criteria stay arrays in the test. |

Style: mermaid id = node name, always (the name is the merge key). No
colors, no fills (`fill:none` on every box), no emoji, no status marks.

## Hard rules

- **One tree per `@main`** in `APP-MAP.md`. Names unique across the
  repo. Built-but-unmounted components go under `## Unmounted`.
- **No cross-feature arrows.** Navigation is a call to `navService`
  with a route and data. The caller never knows which node answers.
- **Dependencies are environment values**: plain structs composed of
  closures, lets, or bindings. No protocols, no classes, no reference
  types. Setting = putting a value into the environment at the root.
  Deriving = building a new value from values already there. No
  `.live`, `.preview`, or `.unimplemented` statics and no `+Live`
  files. The root builds the live value inline where it sets it. The
  default is the minimal no-op and serves previews and tests. Detail:
  `data-coupling/references/modules.md`.
- **Native materialization (`@Query`, `@AppStorage`) gets no cylinder.**
  The root does not set it. It is facts arriving, tagged as `@` lines.
  Only consumption couples: a call logs, a read does not. `dbService`
  is writes only.
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
  evidence) in the same commit as the change, and run `mapcheck.py`.
  Reverse-engineering never invents evidence: draw a block only where a
  pinned log already exists. Read `APP-MAP.md` before reading code. If
  map and code disagree, say so. Never work around it without saying.

## Related

- `data-coupling/` in this repo: what a node's implementation should
  look like. The model, the cut, the log, the layer.
- `sisoje/swift-core-flow`: the shell/core split and execution-log
  testing, mechanized as Swift macros.
