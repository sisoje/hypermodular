# Notation: the complete grammar

Everything `SKILL.md` states in short form, in full. Read this when
drawing or checking a map. The skill's own examples are enough for
reading one.

## Labels

**Mermaid id = node name, always.** Write
`BookShelf["BookShelf<br/>· onDelete"]`, never a short alias id. The
name is the join key that merges maps back into one tree. Ids that
differ from names break the merge with no error. Redundant to type,
free for an AI.

**Node label = name on the first line, then one contract line per
line**, using `<br/>`. Every contract line starts with `· ` (middle dot, space). The name is the text before the first `·`, so the merge
key stays unambiguous even where `<br/>` does not render. Four kinds of
contract line, distinguishable at a glance and by parser. `@`
materializes, parens call, a bare dot reads, a bare name calls back:

- `· @Source` lines **materialize**. The `@` is the materialize marker.
  The word is the source's own name: a property wrapper (`· @Query`,
  `· @AppStorage`, `· @FocusState`), or `· @ProcessInfo` for ambient
  launch input. Source name only, written once however many keys the
  node holds. What the node derives from it (an isLoggedIn computed off
  a token) is code's business, not the map's. A wrapper earns a line
  only when it binds the node to a source of truth that outlives the
  node: a store, defaults, system state such as focus. Machinery whose
  whole lifetime is the node's (own state, gesture transients, task
  handles) gets no line, whatever its spelling.
- `· <dep>.<func>()` lines **call** a capability from the dependency box
  (`· dbService.deleteBook()`). The parens are the mark. A call is an
  event, and it logs.
- `· <dep>.<value>` lines **read** a let or binding off a dependency
  (`· loginState.isLoggedIn`). Coupling without evidence. Reads never
  log, and a node whose dotted lines are all reads owes no evidence
  block. A decision node is usually this.
- `· name` lines (no `@`, no dot) **call back**: a closure the parent
  handed down as data (`· onSave`). It appears in the parent's map,
  where it is handed down, and in the node's own, like any contract
  line.

Calls and callbacks produce evidence. Reads, materialized or off a
dependency, do not, though a write to materialized storage is I/O and
logs like any write (see `evidence.md`). The lines under the name are
the node's entire outbound relationship with the world: everything it
materializes, calls, or calls back. A name-only label receives
everything and calls nothing. Nothing else ever goes in a label.

## Structure arrows (Diagram 1)

- **Solid arrow `-->`** is data flow. The parent hands the child its
  data, bindings, and callbacks. The child never reaches up or
  sideways. Cross-feature arrows are forbidden. Features communicate
  through data and capabilities. Navigation goes through `navService`,
  and which node answers a route is composed up the tree.
- **A node is a collapsed subtree.** The screen plus all its view
  furniture (rows, buttons, design-system pieces) is one node. Internal
  attribution is meaningless. The node's contract is what crosses its
  edge. A subtree becomes its own node only when it joins the app
  lifecycle on its own: own outliving state, appearance work, a
  navigation destination, or its own boundary call. View modifiers
  follow the same rule. A modifier is a node only if it carries
  contract lines. One with own state alone is furniture.
- **A decision marks its alternative arrows with the deciding value.**
  No diamonds, because deciding is what nodes do, but alternatives are
  structural. An agent must know whether children coexist or exclude
  each other. Unlabeled solid arrows are composition (children exist
  together). Labeled arrows are alternatives, labeled with the value
  that selects them (`-->|isLoggedIn|`, `-->|!isLoggedIn|`), which the
  node's contract line already names (`loginState.isLoggedIn`). The
  label states possibility, never sequence. What happens is the
  execution log's business.
- **Unbuilt nodes are bare leaves.** Mapped, reachable, empty. The map
  runs ahead of the code. A leaf with no insides is finished design.
- The shell/core split (imperative shell hosting the machinery, pure
  core taking values and closures) is implementation detail and never
  drawn.

Leaves get no structure map of their own. We are modeling data flow,
and a map earns its existence by having arrows, flow to show. A leaf
has no internal flow. Its contract lives in its parent's map, its only
structural appearance, and the day a leaf grows children, its structure
map is born together with them. A leaf whose evidence crosses its edge
does get a `MAP.md`, holding evidence blocks only. Those are arrows
too.

## The dependency column (Diagram 3)

- Cylinders are surfaces nodes must **call** or **read**: writes and
  commands (`dbService` is writes only), non-native fetches
  (`imageLoader`, `searchAPI`), capabilities (`navService`, closures
  over root-owned navigation state), root-owned facts (`loginState`).
  Native materialization (`@Query`, `@AppStorage`) gets no cylinder.
  The root does not set it. It is facts arriving, tagged in the node
  label. The masterclass calls that storage a dependency, a declared
  claim on the storage that supplies the value at creation, and a
  scenario supplies it as a value or a binding. On the map the word
  names the box, and the `@` line is the claim. How a capability's
  closure is assembled behind its cylinder (root-owned state, a derived
  service, listeners registered up the tree) is implementation detail
  and never drawn.
- **A dependency is an environment value: a plain struct composed of
  closures, lets, or bindings.** Pure value, no protocols, no classes,
  no reference-type service objects. Capabilities as closures, facts as
  lets, shared mutable state as bindings, mixed in one struct. Setting
  means putting a value into the environment at the root. Deriving
  means building a new value from values already there. Nothing else.
- **No `.live`, `.preview`, or `.unimplemented` statics, and no `+Live`
  files.** The root builds the live value inline, at the one place it
  sets it. The environment default is the minimal no-op and already
  serves previews and tests. A scenario builds the logger. A value that
  can be made with no inputs does not belong in the environment.
- Name the boundary, not the tech: `dbService`, not `swiftData`.
- Name a closure for what the caller means. A verb is a command
  (`showDetail`, `deleteBook`). A past-tense clause is a notification
  (`logoutHappened`). Never name it after the reaction.
- **Setting a value is normal data flow.** One solid arrow `-->` from
  the root into the Dependencies box. App hands values to the
  environment the same way a parent hands values to a child. A second
  arrow into the box means a value was set below the root.
- **The column is ordered. Top to bottom is the order the root sets
  them.** The invisible `~~~` chain is semantic, not layout. The root's
  modifiers are applied in sequence, and a later one may read services
  already in the environment and combine them into a new one. A derived service uses the node-label grammar: name on the first
  line, then one line per ingredient it reads,
  `syncService[("syncService<br/>· dbService<br/>· searchAPI")]`. Its
  ingredients must appear above it in the column. An ingredient below
  is an order violation you can see. The modifiers that set the values
  are implementation detail and never drawn.
- `fill:none` on every box. Stack cylinders with invisible `~~~` links.

## Identity rules: combining maps

Depth-1 maps must recombine into one tree mechanically. Any agent (or
script) must be able to answer "which node belongs where" from the files
alone.

- **One name, one node.** Node display names are globally unique across
  the whole app and identical everywhere the node appears, as a leaf in
  its parent's map and as the root of its own. The name is the join
  key.
- **One tree per entry point.** A repo with several `@main` targets
  holds one tree per target in `APP-MAP.md`, each with its own
  `%% Root:` block. Names are unique across the repo, not the tree. A
  component that is built but mounted by no root is listed under a
  `## Unmounted` heading in a block headed `%% Root: App · Unmounted`,
  name and full label, no arrows, so its contract has a copy to compare
  against the day it mounts.
- **Same contract everywhere, duplicated on purpose.** A node's full
  label (name plus contract lines) is identical as a child in its
  parent's map and as the root of its own. This is double-entry
  bookkeeping. The reconstruction check compares the copies, and any
  mismatch is a detected, unreviewed design change. Single-sourcing
  would have nothing to compare. Changing a contract therefore touches
  parent map and child map in the same commit, which is the design
  review.
- **A map exists only where there are arrows.** Nodes with children get
  a structure map. Leaves do not. A leaf's contract lives in its
  parent's map, its only structural appearance. (Label duplication
  applies only to nodes that appear twice. A leaf has one entry, so
  nothing to cross-check.) Evidence blocks are arrows as well. Any node
  with a required evidence block has a `MAP.md`, structure or not.
- **Every mermaid block declares its place** as its first line, inside
  the block: `%% Root: BookDetail · Parent: BookShelf (../MAP.md)` for
  structure, `%% Evidence: BookDetail · Parent: BookShelf (../MAP.md)`
  for evidence, `%% Root: App · Dependencies`, `· Coupling`, and
  `· Unmounted` for the three app-level blocks. The root map's comment
  is `%% Root: App`. The block stays self-contained when extracted.
  Following parent links upward reaches `APP-MAP.md`. Following names
  downward reaches any node.
- **Reconstruction check**: parent links form a single tree with no
  orphans, and every `MAP.md`, structure or evidence-only, is reachable.
  When maintaining maps, verify this before committing.

## Evidence blocks (Diagram 4)

One `sequenceDiagram` per acceptance criterion whose log crosses the
node's edge, meaning at least one entry is a boundary event: a call, a
callback, or a write into a source the node was handed or materializes.
A criterion whose log is own state only stays an array in the test and
is not drawn. The map shows edges, and behavior that cannot break a
contract has nothing to show on it. "Optional" means own state only,
never "skipped". A node with a call on its label and no evidence block
is a finding, like a label mismatch.

- **Two comment lines open the block.** `%% Evidence: <Node> · Parent:
  <Parent> (../MAP.md)` places it, the same parent link every block
  carries, so an evidence-only `MAP.md` is never an orphan (an unmounted
  node's parent is `Unmounted (../APP-MAP.md)`). `%% Given:
  <construction>` states the given: constructor arguments and stubs.
- **Arrows into the node are the *when***, and there are three kinds.
  `User->>Node: interaction` for input. `System->>Node: event` for
  lifecycle, scene phase, deep links. `Child->>Node: callback payload`
  for a child firing a callback the node handed it
  (`AddItem->>ShoppingList: onAdd eggs`). None is ever a log entry. The
  third is the only way an event reaches a parent from inside its own
  tree, and it is checkable: the named callback must be a `· name` line
  on that child's label, and the same event appears as an out-arrow in
  the child's own block (see `evidence.md`, one event two edges). A
  parent handing down a new value is not a stimulus. It is a new given,
  so start a second block. (The alternative reading, that an
  `.onChange(of:)` reaction makes it a genuine when, is open.
  `Parent->>Node` warns rather than errors until it is ruled.)
- **Arrows out of the node are the *then***. `Node->>target: payload`
  is one entry, `(target, payload)`, in order. The array the test
  asserts is exactly the ordered list of out-arrows, nothing else. In
  the array each entry is the target's own name without any `dep.`
  prefix, a space, and the payload; an empty payload leaves the bare
  name. `Search->>searchAPI.search: dune` is `"search dune"`, and
  `LoginScreen->>authService.logIn: ""` is `"logIn"`. The test compares
  the whole array with one equality, so a call the block did not name
  fails it. Where the requirement names no order, compare as a set.
  Where only the decision matters, assert the decision and skip the
  log. Never a subsequence.
- **Dashed arrows back are supplied data**: `target-->>Node: value` or
  `throws`, drawn only when it explains a later entry. Never an entry.
  The call is the event. What comes back is data.
- **Targets are the node's edge and nothing else**: a contract line (a
  capability call, named without its parens, or a callback) or a stored property of the node, meaning own state, a binding it was
  handed, or a materialized source being written. Any other target is a finding. A grandchild on a
  lifeline is depth 2, visible.
- **`loop` when the requirement names no count**, exactly as order is
  asserted only when the requirement names an order. The test then
  asserts the decision. A value the requirement does not pin is a symbolic payload (`max so far`), a separate choice. A loop can
  carry pinned payloads, and a single arrow can carry a symbolic one.
- **Silence is drawn.** A stimulus with no out-arrow asserts that
  nothing logged. `Note over Node: …` says why.
- **Quote a target whose name mermaid reserves**: `title`, `loop`,
  `end`, `note`, `over`, `and`, `off`, `option`, and the rest of the
  sequence-diagram vocabulary (`alt`, `opt`, `par`, `rect`, `box`,
  `break`, `critical`, `participant`, `actor`, `activate`,
  `deactivate`, `create`, `destroy`, `link`, `links`, `properties`,
  `details`, `autonumber`, `else`). Write `Node->>"title": Dune`. The
  name is the text inside the quotes, the same way it is the text
  before the first `·` on a label.

Blocks live in the node's own `MAP.md`, under `## Evidence`, after the
structure block if there is one. Evidence appears once. The parent's
map stays structure-only. The block is the source and the test is
written from it. The two are double-entry like a label and its copy.
Contracts are duplicated on purpose, and single-sourcing would have
nothing to compare. A diagram and a test array that disagree are an
unreviewed behavior change.

## The checker

`scripts/mapcheck.py <repo>` runs the reconstruction check and
everything else the maps alone can verify: id = name, the `·` grammar,
label double-entry, every call and read line naming a cylinder, the
order of the dependency column, evidence targets against labels,
reserved-word quoting, depth 1. It exits non-zero on any error.

What it cannot see is code, that is, whether every call in a node's
Swift is on its label and whether a bare evidence target is a real
stored property, and it says so (`UNVERIF`). `scripts/test.sh` runs its
fixtures: `fixtures/clean` (CoreFlowExample's validated maps, zero
errors) and `fixtures/broken` (the same with thirteen planted
violations, all caught; wrong on purpose, never an example).
