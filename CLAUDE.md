# CLAUDE.md — hypermodular

This repo defines the **hypermodular** method (Top-Down Development).
`hypermodular/SKILL.md` is the single source of truth; this file is your
working summary. When the two disagree, `SKILL.md` wins — flag the
disagreement.

## What this repo is

A method + agent skill for modeling apps as depth-1 Mermaid maps
(`APP-MAP.md` at a repo root, `MAP.md` beside each mapped subtree). The
maps are the architecture doc, the agent work fence, and the review
surface, all at once. There is no build step and no code here — the
deliverable is the doctrine.

## The three rules (follow them in any mapped repo)

1. **Build top-down.** Implement a node only after its parent exists. New
   features are drawn on the map before any code is written.
2. **Respect the map.** When working on a node, touch only that node's
   code and the capabilities named in its own label. Need something not
   on the map? Stop, propose a map change, get the diff agreed — the map
   diff IS the design review.
3. **Evidence, not effects.** Declare a node's behavior as data (values
   in → ordered evidence log out; every source-of-truth write and action
   call logs, reads never do) before implementing. Never mock, never
   observe effects behind a boundary. A boundary in a spec is a logger;
   checking a node is comparing two values.

## One law: depth 1

Boundaries log one step deep. Injection enters only at the root. Maps
draw only one level. Every artifact describes exactly one boundary — its
own.

## Notation cheat sheet

| Mark | Meaning |
|------|---------|
| `A --> B` | Data flow: parent hands facts/bindings/callbacks down. Also root → Dependencies box (injection is normal data flow). |
| `A -->\|cond\| B` | Decision alternative, labeled with the selecting value. Unlabeled arrows = composition (children coexist). |
| `Node["Name<br/>@Query<br/>dep.func"]` | Label = name, then one contract line per line. `@` lines materialize (native SOT; reads log nothing, writes log like any write). `dep.func` lines call (produce evidence). Name-only label = receives everything, calls nothing. |
| `svc[(svc)]` | Dependency cylinder. Named for the boundary, not the tech (`dbService`, never `swiftData`). |
| `subgraph Dependencies` | One solid unfilled box holding all cylinders, ordered top-to-bottom = injection order. Derived services list their ingredients, which must sit above them. |
| `A ~~~ B` | Invisible link — orders the dependency column. |
| `%% Root: X · Parent: Y (../MAP.md)` | First line of every mermaid block. Self-describing placement. |

Style: mermaid id = node name, always (the name is the merge key). No
colors, no fills (`fill:none` on every box), no emoji, no status marks.

## Hard rules

- **No cross-feature arrows.** Navigation is a call to `navService` with
  a route + data; the caller never knows which node answers.
- **Dependencies are environment values**: plain structs composed of
  closures, lets, or bindings. No protocols, no classes, no reference
  types. Injection = putting a value into the environment at the root.
  Deriving = building a new value from values already there.
- **Reads that materialize natively (`@Query`, `@AppStorage`) are not
  dependencies** — they're facts arriving, tagged as `@` lines. Only
  calls couple. `dbService` is writes only.
- **A node is a collapsed subtree.** View furniture (rows, buttons,
  design-system pieces) never gets a node — the contract is what crosses
  the node's edge. A subtree splits out only when it joins the app
  lifecycle independently (own outliving state, appearance work,
  navigation destination, own boundary call).
- **Shell/core split is implementation detail** (CoreFlow's job) and is
  never drawn.
- **Leaves get no map** — a map earns its existence by having arrows
  (flow to show). A leaf's contract lives in its parent's map.
- **Contracts are duplicated on purpose** (parent's map + own map,
  identical). Mismatch between copies = unreviewed design change; a
  contract change must touch both maps in the same commit.

## Workflows

- **Mapping an existing codebase**: walk instantiation from the entry
  point (solid arrows), attribute each I/O call to the node that decides
  it, apply the cut rules while walking, extract shared types/services
  into the coupling diagram, verify root-only injection. Present the map
  plus the 2–3 most interesting findings.
- **New feature in a mapped repo**: add nodes/arrows to the map first,
  agree the diff, then build root-down, evidence declared before code.
- **Maintenance**: map is code — update affected maps in the same commit
  as the change. Read `APP-MAP.md` before reading code. If map and code
  disagree, say so; never silently work around.

## Related repos

- `sisoje/swift-core-flow` — macros implementing shell/core + evidence
  logging in SwiftUI.
- `redhotbits/swiftui-mv-architecture` — the MV coding style for what a
  node's implementation should look like.
