# Notation — the complete grammar

Everything `SKILL.md` states in short form, in full. Read this when
drawing or checking a map; the skill's own examples are enough for
reading one.

## Labels

**Mermaid id = node name, always.** Write
`BookShelf["BookShelf<br/>· onDelete"]`, never a short alias id. The
name is the join key that merges maps back into one tree; ids that
differ from names break the merge silently. Redundant to type, free for
an AI.

**Node label = name on the first line, then one contract line per
line**, using `<br/>`. **Every contract line starts with `· `** (middle
dot, space): the name is the text before the first `·`, so the merge key
stays unambiguous even where `<br/>` doesn't render. Four kinds of
contract line, distinguishable at a glance and by parser — `@`
materializes, parens call, a bare dot reads, a bare name calls back:

- `· @Source` lines **materialize**. The `@` is the materialize marker;
  the word is the source's own name — a property wrapper (`· @Query`,
  `· @AppStorage`, `· @FocusState`), or `· @ProcessInfo` for ambient
  launch input. Source name only, written once however many keys the
  node holds; what the node derives from it (an isLoggedIn computed off
  a token) is code's business, not the map's. A wrapper earns a line
  only when it binds the node to a source of truth that **outlives the
  node** — a store, defaults, system state such as focus. Machinery
  whose whole lifetime is the node's — own state, gesture transients,
  task handles — gets no line, whatever its spelling.
- `· <dep>.<func>()` lines **call** a capability from the dependency box
  (`· dbService.deleteBook()`). The parens are the mark: a call is an
  event, and it logs.
- `· <dep>.<value>` lines **read** a let or binding off a dependency
  (`· loginState.isLoggedIn`). Coupling without evidence: reads never
  log, and a node whose dotted lines are all reads owes no evidence
  block. A decision node is usually this.
- `· name` lines (no `@`, no dot) **call back**: a closure the parent
  handed down as data (`· onSave`). It appears in the parent's map,
  where it is handed down, and in the node's own — like any contract
  line.

Calls and callbacks produce evidence; reads — materialized or off a
dependency — don't, though a write to materialized storage is I/O and
logs like any write (see `evidence.md`). The lines under the name are
the node's entire outbound relationship with the world: everything it
materializes, calls, or calls back. A name-only label receives
everything and calls nothing. Nothing else ever goes in a label.

## Structure arrows (Diagram 1)

- **Solid arrow `-->`** = data flow. Parent hands the child its data,
  bindings, and callbacks; the child never reaches up or sideways.
  Cross-feature arrows are forbidden — features communicate through
  data and capabilities (navigation goes through `navService`; which
  node answers a route is composed up the tree).
- **A node is a collapsed subtree.** The screen plus all its view
  furniture (rows, buttons, design-system pieces) is one node; internal
  attribution is meaningless — the node's contract is what crosses its
  edge. A subtree becomes its own node only when it joins the app
  lifecycle independently: own outliving state, appearance work,
  navigation destination, or its own boundary call. View modifiers
  follow the same rule: a modifier is a node only if it carries
  contract lines; one with own state alone is furniture.
- **A decision marks its alternative arrows with the deciding value.**
  No diamonds — deciding is what nodes do — but alternatives are
  structural: an agent must know whether children coexist or exclude
  each other. Unlabeled solid arrows = composition (children exist
  together); labeled arrows = alternatives, labeled with the value that
  selects them (`-->|isLoggedIn|`, `-->|!isLoggedIn|`), which the
  node's contract line already names (`loginState.isLoggedIn`). The
  label states possibility, never sequence — what happens is the
  evidence log's business.
- **Unbuilt nodes are bare leaves** — mapped, reachable, empty. The map
  runs ahead of the code; a leaf with no insides is finished design.
- Shell/core split (imperative shell hosting the machinery, pure core
  taking values and closures) is implementation detail and never drawn.

Leaves get no structure map of their own — we are modeling data flow,
and a map earns its existence by having arrows: flow to show. A leaf
has no internal flow; its contract lives in its parent's map (its only
structural appearance), and the day a leaf grows children, its
structure map is born together with them. A leaf whose evidence crosses
its edge does get a `MAP.md` — holding evidence blocks only; those are
arrows too.

## The dependency column (Diagram 3)

- Cylinders are surfaces nodes must **call** or **read**: writes and
  commands (`dbService` is writes only), non-native fetches
  (`imageLoader`, `searchAPI`), capabilities (`navService` — closures
  over root-owned navigation state), root-owned facts (`loginState`).
  Native materialization (`@Query`, `@AppStorage`) is not a dependency:
  it's facts arriving, tagged in the node label. How a capability's
  closure is assembled behind its cylinder — root-owned state, a derived
  service, listeners registered up the tree — is implementation detail
  and never drawn.
- **A dependency is an environment value: a plain struct composed of
  closures, lets, or bindings.** Pure value, no protocols, no classes,
  no reference-type service objects — capabilities as closures, facts
  as lets, shared mutable state as bindings, mixed freely in one
  struct. The live implementation, the preview stub, and the logging
  spec host are just different member sets of the same struct.
  Injection means putting a value into the environment; deriving means
  building a new value from values already there. Nothing else.
- Name the boundary, not the tech: `dbService`, not `swiftData`.
- **Injection is normal data flow.** One solid arrow `-->` from the
  root into the Dependencies box: App hands values to the environment,
  the same way a parent hands values to a child. A second arrow into
  the box means injection leaked into the tree.
- **The column is ordered: top to bottom is injection order.** The
  invisible `~~~` chain is semantic, not layout — injectors are
  typically view modifiers applied in sequence, and a later injector
  may read services already in the environment and combine them into a
  new one. A **derived service** uses the node-label grammar: name on
  the first line, then one line per ingredient it reads —
  `syncService[("syncService<br/>· dbService<br/>· searchAPI")]`. Its
  ingredients must appear **above it** in the column; an ingredient
  below is an order violation you can see. The injector modifiers
  themselves are implementation detail and never drawn.
- `fill:none` on every box; stack cylinders with invisible `~~~` links.

## Identity rules — combining maps

Depth-1 maps must recombine into one tree mechanically. Any agent (or
script) must be able to answer "which node belongs where" from the files
alone:

- **One name, one node.** Node display names are globally unique across
  the whole app and identical everywhere the node appears: as a leaf in
  its parent's map and as the root of its own. The name is the join key.
- **One tree per entry point.** A repo with several `@main` targets
  holds one tree per target in `APP-MAP.md`, each with its own
  `%% Root:` block; names are unique across the repo, not the tree. A
  component that is built but mounted by no root is listed under a
  `## Unmounted` heading in a block headed `%% Root: App · Unmounted` —
  name and full label, no arrows — so its contract has a copy to
  compare against the day it mounts.
- **Same contract everywhere — deliberately duplicated.** A node's full
  label (name + contract lines) is identical as a child in its parent's
  map and as the root of its own. This is double-entry bookkeeping: the
  reconstruction check compares the copies, and any mismatch is a
  detected, unreviewed design change — single-sourcing would have
  nothing to compare. Changing a contract therefore touches parent map
  and child map in the same commit, which is exactly the design review.
- **A map exists only where there are arrows.** Nodes with children get
  a structure map; leaves don't — a leaf's contract lives in its
  parent's map, its only structural appearance. (Label duplication
  applies only to nodes that appear twice; a leaf has one entry, so
  nothing to cross-check.) Evidence blocks are arrows as well: any node
  with a required evidence block has a `MAP.md`, structure or not.
- **Every mermaid block declares its place** as its first line, inside
  the block: `%% Root: BookDetail · Parent: BookShelf (../MAP.md)` for
  structure, `%% Evidence: BookDetail · Parent: BookShelf (../MAP.md)`
  for evidence, `%% Root: App · Dependencies`, `· Coupling`, and
  `· Unmounted` for the three app-level blocks. The root map's comment
  is `%% Root: App`. The block stays self-contained when extracted;
  following parent links upward reaches `APP-MAP.md`, following names
  downward reaches any node.
- **Reconstruction check**: parent links form a single tree with no
  orphans, and every `MAP.md` — structure or evidence-only — is
  reachable. When maintaining maps, verify this before committing.

## Evidence blocks (Diagram 4)

One `sequenceDiagram` per acceptance criterion whose log crosses the
node's edge — at least one entry targets a contract line. A criterion
whose log is own state only stays an array in the test and is not
drawn: the map shows edges, and behavior that cannot break a contract
has nothing to show on it. "Optional" means *own state only*, never
"skipped" — a node with a call on its label and no evidence block is a
finding, like a label mismatch.

- **Two comment lines open the block.** `%% Evidence: <Node> · Parent:
  <Parent> (../MAP.md)` places it — the same parent link every block
  carries, so an evidence-only `MAP.md` is never an orphan (an unmounted
  node's parent is `Unmounted (../APP-MAP.md)`). `%% Given:
  <construction>` states the given: constructor arguments and stubs.
- **Arrows into the node are the *when***: `User->>Node: interaction`
  for input, `System->>Node: event` for lifecycle, scene phase, deep
  links. Never a log entry. A parent handing down a new value is a new
  *given*, not a stimulus — start a second block. (The alternative
  reading, that an `.onChange(of:)` reaction makes it a genuine *when*,
  is open; `Parent->>Node` warns rather than errors until it is ruled.)
- **Arrows out of the node are the *then***: `Node->>target: payload`
  is one entry, `(target, payload)`, in order. The array the test
  asserts is exactly the ordered list of out-arrows, nothing else.
- **Dashed arrows back are supplied data**: `target-->>Node: value` or
  `throws` — drawn only when it explains a later entry. Never an entry.
  The call is the event; what comes back is data.
- **Targets are the node's edge and nothing else**: a contract line (a
  capability call, named without its parens, or a callback) or a stored
  property of the node — own state, or a materialized source being
  written. Any other target is a finding — a grandchild on a lifeline
  is depth 2, visible.
- **`loop` when the requirement names no count**, exactly as order is
  asserted only when the requirement names an order; the test then
  asserts the decision. A value the requirement doesn't pin is a
  **symbolic payload** (`max so far`) — a separate choice; a loop can
  carry pinned payloads, and a single arrow can carry a symbolic one.
- **Silence is drawn**: a stimulus with no out-arrow asserts that
  nothing logged; `Note over Node: …` says why.
- **Quote a target whose name mermaid reserves** — `title`, `loop`,
  `end`, `note`, `over`, `and`, `off`, `option`, and the rest of the
  sequence-diagram vocabulary (`alt`, `opt`, `par`, `rect`, `box`,
  `break`, `critical`, `participant`, `actor`, `activate`,
  `deactivate`, `create`, `destroy`, `link`, `links`, `properties`,
  `details`, `autonumber`, `else`): `Node->>"title": Dune`. The name is
  the text inside the quotes, the same way it is the text before the
  first `·` on a label.

Blocks live in the node's own `MAP.md`, under `## Evidence`, after the
structure block if there is one. Evidence appears once — the parent's
map stays structure-only. The block is the source and the test is
written from it; the two are double-entry like a label and its copy:
contracts are duplicated on purpose, and single-sourcing would have
nothing to compare. A diagram and a test array that disagree are an
unreviewed behavior change.

## The checker

`scripts/mapcheck.py <repo>` runs the reconstruction check and
everything else the maps alone can verify: id = name, the `·` grammar,
label double-entry, every call and read line naming a cylinder,
injection order, evidence targets against labels, reserved-word
quoting, depth 1. It exits non-zero on any error.

What it cannot see is code — whether every call in a node's Swift is on
its label, and whether a bare evidence target is a real stored property
— and it says so (`UNVERIF`). `scripts/test.sh` runs its fixtures:
`fixtures/clean` (CoreFlowExample's validated maps, zero errors) and
`fixtures/broken` (the same with thirteen planted violations, all
caught — deliberately wrong, never an example).
