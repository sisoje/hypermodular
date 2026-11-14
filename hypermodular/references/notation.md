# Notation: the complete grammar

Everything `SKILL.md` states in short form, in full. Read this when
drawing or checking a map. The skill's own examples are enough for
reading one.

## Labels

**Mermaid id = node name.** Write
`BookShelf["BookShelf<br/>· onDelete"]`, not a short alias id. The
name is the join key that merges maps back into one tree. Ids that
differ from names break the merge, and the checker reports them. Redundant to type,
free for an AI.

**Node label = name on the first line, then one contract line per
line**, using `<br/>`. Every contract line starts with `· ` (middle dot, space). The name is the text before the first `·`, so the merge
key stays unambiguous even where `<br/>` does not render. Five kinds of
contract line, distinguishable at a glance and by parser. `@`
materializes, parens call, a bare dot reads, `$` writes a handed
binding, a bare name calls back:

- `· @Source` lines **materialize**. The `@` is the materialize marker.
  The word is the source's own name: a property wrapper (`· @Query`,
  `· @SceneStorage`, `· @FocusState`), or `· @ProcessInfo` for ambient
  launch input. `@AppStorage` is the root's and reaches a node as a
  binding, a `$` line. Source name only, written once however many keys the
  node holds. What the node derives from it (an isLoggedIn computed off
  a token) is code's business, not the map's. A wrapper earns a line
  only when it binds the node to a source of truth that outlives the
  node: a store, defaults, or system state such as focus, which the
  system owns and the node writes, so the node's write logs and the
  system's move does not. Machinery whose
  whole lifetime is the node's (own state, gesture transients, task
  handles) gets no line, whatever its spelling.
- `· <dep>.<func>()` lines **call** a capability from the dependency box
  (`· dbService.deleteBook()`). The parens are the mark. A call is an
  event, and it logs. A sealed action Apple sets, `· dismiss()`,
  `· openURL()`, is a call with no dependency and no cylinder, and it
  logs under its own name. A flow the node calls, `· deeplink()`, is
  written the same way, a call with no cylinder, and the checker
  reports a flow called in the Swift with no such line.
- `· <dep>.<value>` lines **read** a let or binding off a dependency
  (`· loginState.isLoggedIn`). Coupling without evidence. Reads do not
  log, and a node whose dotted lines are all reads owes no evidence
  block. A decision node is usually this.
- `· $<path>` lines **write** a binding the node was handed, by its
  parent (`· $sortByAuthor`) or inside a dependency (`· $settings.city`,
  and `settings` is then a cylinder). In the Swift such a binding is a
  value read off the dependency and handed on with no `$`,
  `TextField("City", text: settings.city)`. The write logs under the
  property's name, the evidence names it as the label spells it
  (`BookShelf->>sortByAuthor: true`, `Settings->>settings.city: Lisbon`),
  and the checker reports a `$` line no block writes. The line is what
  turns a `let` becoming a writable binding into a map diff.
- `· name` lines (no `@`, no dot) **call back**: a closure the parent
  handed down as data (`· onSave`). It appears in the parent's map,
  where it is handed down, and in the node's own, like any contract
  line.

Calls, callbacks, and binding writes produce evidence. Reads, materialized or off a
dependency, do not, though a write to materialized storage is I/O and
logs like any write (see `evidence.md`). The lines under the name are
the node's entire outbound relationship with the world: everything it
materializes, calls, or calls back. A name-only label receives
everything and calls nothing. Nothing else goes in a label.

## Structure arrows (Diagram 1)

- **Solid arrow `-->`** is data flow. The parent hands the child its
  data, bindings, and callbacks. The child does not reach up or
  sideways. Cross-feature arrows are forbidden. Features communicate
  through data and capabilities. Navigation across features goes
  through `navService`, and which node answers a route is composed up
  the tree. A node's own sheet or stack is its own state.
- **A node is a collapsed subtree.** The screen plus all its view
  furniture (rows, buttons, design-system pieces) is one node. Internal
  attribution is meaningless. The node's contract is what crosses its
  edge. A subtree becomes its own node only when it joins the app
  lifecycle on its own: own outliving state, appearance work, a
  navigation destination, or its own boundary call or callback. View modifiers
  follow the same rule. A modifier is a node only if it carries
  contract lines. One with own state alone is furniture.
- **A decision marks its alternative arrows with the deciding value.**
  No diamonds, because deciding is what nodes do, but alternatives are
  structural. An agent needs to know whether children coexist or exclude
  each other. Unlabeled solid arrows are composition (children exist
  together). A labeled arrow is a presence condition: the child exists
  while the value holds (`-->|isAdding|`). Arrows labeled with the same
  deciding value are alternatives (`-->|isLoggedIn|`, `-->|!isLoggedIn|`;
  three arrows on one enum are a switch), and the node's contract lines
  name that value (`loginState.isLoggedIn`) or receive it. Arrows on
  different values are independent and may coexist. The label states
  possibility, not sequence. What happens is the
  execution log's business.
- **Unbuilt nodes are bare leaves.** Mapped, reachable, empty. The map
  runs ahead of the code. A leaf with no insides is finished design.
- The shell/core split (imperative shell hosting the machinery, pure
  core taking values and closures) is implementation detail and not
  drawn.

Leaves get no structure map of their own. We are modeling data flow,
and a map earns its existence by having arrows, flow to show. A leaf
has no internal flow. Its contract lives in its parent's map, its only
structural appearance, and the day a leaf grows children, its structure
map is born together with them. A leaf whose evidence crosses its edge
gets a directory of flow files and no `MAP.md`. Those blocks are
arrows too.

## The dependency column (Diagram 3)

- Cylinders are surfaces nodes **call** or **read**: writes and
  commands (`dbService` is writes only; a write may return a result), non-native fetches
  (`imageLoader`, `searchAPI`), capabilities (`navService`, closures
  over root-owned navigation state), root-owned facts (`loginState`),
  root-owned storage as bindings (`settings`). Native materialization
  (`@Query`) gets no cylinder.
  The root does not set it. It is facts arriving, tagged in the node
  label. The masterclass calls that storage a dependency, a declared
  claim on the storage that supplies the value at creation, and a
  scenario supplies it as a value or a binding. On the map the word
  names the box, and the `@` line is the claim. How a capability's
  closure is assembled behind its cylinder (root-owned state, a derived
  service, listeners registered up the tree) is implementation detail
  and not drawn.
- **A dependency is an environment value: a plain struct composed of
  closures, lets, or bindings.** Pure value, no protocols, no classes,
  no reference-type service objects, the code skill's three protocol
  cases excepted. Capabilities as closures, facts as
  lets, shared mutable state as bindings, mixed in one struct. Setting
  means putting a value into the environment at the root. Deriving
  means building a new value from values already there. Nothing else.
- **No `.live`, `.preview`, or `.unimplemented` statics, and no `+Live`
  files.** The root builds the live value inline, at the one place it
  sets it. The environment default is the minimal no-op and already
  serves previews and tests. A scenario builds the logger. A pure value
  that can be made with no inputs does not belong in the environment;
  I/O with no inputs still does.
- Name the boundary, not the tech: `dbService`, not `swiftData`.
- Name a closure for what the caller means. A verb is a command
  (`showDetail`, `deleteBook`). A past-tense clause is a notification
  (`logoutHappened`). Do not name it after the reaction.
- **Setting a value is normal data flow.** One solid arrow `-->` from
  the root into the Dependencies box. App hands values to the
  environment the same way a parent hands values to a child. A second
  arrow into the box means a value was set below the root.
- **The column is ordered. Top to bottom is the order the root sets
  them.** The invisible `~~~` chain is semantic, not layout: it is the
  order the root sets them, which constrains a derived service's place
  and nothing else. The root's
  modifiers are applied in sequence, and a later one may read services
  already in the environment and combine them into a new one. A derived service uses the node-label grammar: name on the first
  line, then one line per ingredient it reads,
  `syncService[("syncService<br/>· dbService<br/>· searchAPI")]`. Its
  ingredients appear above it in the column. An ingredient below
  is an order violation you can see. The modifiers that set the values
  are implementation detail and not drawn.
- `fill:none` on the Dependencies box, the one subgraph. Nodes keep the
  renderer's default. Stack cylinders with invisible `~~~` links.

## Identity rules: combining maps

Depth-1 maps recombine into one tree mechanically. Any agent (or
script) can answer "which node belongs where" from the files
alone.

- **One name, one node.** Node display names are globally unique across
  the whole app and identical everywhere the node appears, as a leaf in
  its parent's map and as the root of its own. The name is the join
  key.
- **One tree per shipped entry point.** A repo with several shipped
  `@main` targets holds one tree per target in `APP-MAP.md`, each with
  its own `%% Root:` block. A test host that renders scenarios is not
  a tree; it is drawn nowhere. Names are unique across the repo, not the tree. A
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
  with a required evidence block has a directory under `Maps/`, with a
  `MAP.md` in it only when it has children.
- **Every mermaid block declares its place** as its first line, inside
  the block: `%% Root: BookDetail · Parent: BookShelf (../MAP.md)` for
  structure, `%% Evidence: BookDetail · Parent: BookShelf (../MAP.md)`
  for evidence, `%% Root: App · Dependencies`, `· Coupling`, and
  `· Unmounted` for the three app-level blocks. The root map's comment
  is `%% Root: <Root>`, the root named for the `@main` type or for the
  view a package exports as its root; the examples call it `App`. The
  block stays self-contained when extracted.
  Following parent links upward reaches `APP-MAP.md`. Following names
  downward reaches any node.
- **Reconstruction check**: parent links form a single tree with no
  orphans, and every map file, a `MAP.md` or a flow file, is reachable.
  When maintaining maps, verify this before committing.

## Evidence blocks (Diagram 4)

One `sequenceDiagram` per acceptance criterion whose log crosses the
node's edge, meaning at least one entry is a boundary event: a call, a
callback, or a write into a source the node was handed or materializes.
A criterion whose log is own state only stays an array in the test and
is not drawn. The map shows edges, and behavior that cannot break a
contract has nothing to show on it. A silence on a contract line,
Save tapped and nothing handed on, is an edge event, so that criterion
is drawn with its `Note`. "Optional" means own state only,
not "skipped". A node with a call on its label and no evidence block
is a finding, like a label mismatch.

- **Two comment lines open the block.** `%% Evidence: <Node> · Parent:
  <Parent> (../MAP.md)` places it, the same parent link every block
  carries, so a flow file is not an orphan (an unmounted node's parent
  is `Unmounted (../../APP-MAP.md)`). `%% Given:
  <construction>` states the given: constructor arguments and stubs.
- **Arrows into the node are the *when***, and there are three kinds.
  `User->>Node: interaction` for input. One stimulus may be followed
  by several entries. Typed text is one arrow, `User->>AddressForm:
  type 123 in postal code`, and one out-arrow for every write it
  causes, a keystroke at a time. `System->>Node: event` for
  lifecycle, scene phase, deep links. A scenario produces a scene
  phase change or a deep link by calling the flow that the root's
  modifier forwards the system's event into. A flow's event reaches a
  listening node from outside its own tree, so in the listener's
  block it is a `System` stimulus, whoever emitted it, and listening
  adds no line to the label. A call the node makes on
  appearance, a `.task` over `reminderService.taps()`, is in every
  block of that node after `System->>Node: appears`, since the
  scenario mounts the node each time and the whole log is compared. `Child->>Node: callback payload`
  for a child firing a callback the node handed it
  (`AddItem->>ShoppingList: onAdd eggs`). None is a log entry. The
  third is the only stimulus from inside the node's own tree, and it is
  checkable: the named callback is a `· name` line on that child's
  label, and the same event appears as an out-arrow in the child's own
  block (see `evidence.md`, one event two edges). The test produces
  that stimulus by driving the real child, which is the child's own
  host under the scenario. A child writing a
  binding the node handed it is not a stimulus; at the node's edge it
  is the node's own out-arrow, `Node->>name: value`, the other way one
  event has two edges. A
  parent handing down a new value is not a stimulus. It is a new given,
  so start a second block. A node that answers the new value by
  writing its own state, an `.onChange(of:)` that fills a seeded copy
  again, has no when in it either. That write is a repair, and the
  code skill's `data-flow.md`, "A value built from an input", says
  what replaces it. A node does not answer a parent's new value with
  a call either. The value changed by a write, the write is an action,
  and the node that handles it makes the call, in its handler or in
  the setter of the binding it hands down. So `Parent->>Node` is not a
  stimulus, and the checker warns on it. A value the app's code does
  not control, one the system supplies, changes as a `System`
  stimulus.
- **Arrows out of the node are the *then***. `Node->>target: payload`
  is one entry, `(target, payload)`, in order. The names the test
  asserts are exactly the ordered list of out-arrows, nothing else, and
  each value is asserted as the test's author sees fit. In
  the array each entry is the target's own name without any `dep.`
  prefix, a space, and the payload; an empty payload leaves the bare
  name. `Search->>searchAPI.search: dune` is `"search dune"`, and
  `LoginScreen->>authService.logIn: ""` is `"logIn"`. The test compares
  the names whole with one equality, so a call the block did not name
  fails it, and each value as the author spells it, a deterministic
  spelling, symbolic where a description is not stable. The block
  writes a payload as the criterion names it, `Required`, `nil`, an
  address by its fields. A macro logs the value's description, so the
  test asserts `Optional("Required")` or the model's printed form. The
  two spellings name one value and are no mismatch. Where the requirement names no order, the test sorts those
  entries into one fixed order before comparing, by name and then by
  value, duplicates kept, and the block shows that order. Not a subsequence.
- **Dashed arrows back are supplied data**: `target-->>Node: value` or
  `throws`, drawn only when it explains a later entry. Not an entry.
  The call is the event. What comes back is data.
- **Targets are the node's edge and nothing else**: a contract line (a
  capability call, named without its parens, or a callback) or a stored property of the node, meaning own state, a binding it was
  handed, bare or dotted as its `$` line spells it, or a materialized
  source being written. Any other target is a finding. A grandchild on a
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

Each block is a flow file of its own, in the node's directory under
`Maps/` beside its `MAP.md`, named for the criterion it declares,
`Maps/Search/Offline.md`, and holding that one block and nothing
else. A leaf's directory holds its flow files and no `MAP.md`. The
file's parent link is the one its node's `MAP.md` carries, since the
two sit in one directory. Evidence appears once. The parent's map
stays structure-only. The block is the source and the test is
written from it. The two are double-entry like a label and its copy.
Contracts are duplicated on purpose, and single-sourcing would have
nothing to compare. A diagram and a test array that disagree are an
unreviewed behavior change.

## The checker

`scripts/mapcheck.py <repo>` reads `APP-MAP.md`, every `MAP.md`, and
every other `.md` under `Maps/`, the flow files, and warns on an
evidence block left inside a `MAP.md`. With `--write` it draws the
whole app. It merges
every structure block on the node names and puts one `flowchart TD`
first in `APP-MAP.md`, headed `%% Whole: <Root>`, between two HTML
comments that say it is drawn and not written by hand. It holds
every node with its full label, every arrow with its condition, the
`Unmounted` nodes and the `Dependencies` box as subgraphs, and a
dotted arrow `Node -.-> dep` for each dependency a label names. The
blocks it is merged from stay depth 1. Without `--write` the checker
compares what is there with what it would draw. A stale diagram is an
error and a missing one a warning. A second `--write` changes nothing.

`scripts/mapcheck.py <repo>` runs the reconstruction check and
everything else the maps alone can verify: id = name, the `·` grammar,
label double-entry, every call, read, and dotted `$` line naming a
cylinder, the order of the dependency column, evidence targets against labels,
reserved-word quoting, depth 1. It exits non-zero on any error.

Without the code it cannot see whether a bare evidence target is a
real stored property, and it says so (`UNVERIF`). With
`--sources <dir> [<dir> ...]` it reads the Swift and closes the
registry: each mapped node is matched to the type of its name, the
label is derived from the type's body, and the two are compared both
ways. A call, a dependency read, a `@Binding` write, a callback call,
or a `@Query`, `@SceneStorage`, `@FocusState` in the Swift with no
line on the label is an error, the fence breach. A label line with
nothing behind it in the Swift is an error, stale. A bare evidence
target that is no stored property of the type is an error, so the
evidence vocabulary is closed again. A presence-condition arrow whose
label names nothing the node holds or reads is an error, so a renamed
state leaves no stale arrow. `@AppStorage` in any type but the
root is an error (F32). A `View` on no map that reads a cylinder is a
warning, furniture doing a node's work. A root modifier that reads one
cylinder to derive another, the ingredient of the cylinder it sets, is
the root's composition and raises nothing. One rule of the code skill
that no map can show is a warning too. A `Task` nobody holds is a
`Task` expression that is not assigned, returned, or awaited (F37). It
is a warning and not an error, since a rule may be broken on purpose,
and a run reports each one it leaves standing with the reason. A
`QueryView` in a node's Swift is the same materialization as `@Query`
and takes the same `· @Query` line. The reading is textual, the
code is written by the method, so its forms are few. `scripts/test.sh`
runs the fixtures: `fixtures/clean` (CoreFlowExample's validated maps
with Swift stubs, zero errors, nothing unverified) and
`fixtures/broken` (the same with fourteen map violations, eight code
findings, and one habit warning planted, all caught; wrong on
purpose, not an example). The clean fixture carries its whole-app
diagram, and the test changes one of its maps to see the diagram
reported stale and then redrawn.
