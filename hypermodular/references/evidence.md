# Evidence: declaring a node's behavior as data

`SKILL.md` rule 3 in full. Read this when declaring or reviewing a
node's evidence. The skill's two example logs are enough for reading
one.

## The log

A node's declared behavior is one value, the execution log: the
ordered `(name, payload)` record of its boundary events, every write
and every call with its payload. Two kinds of entry, nothing else.

- **A source-of-truth mutation logs** under the property's name: a
  binding write, an external-storage write, the node's own state write.
  Evidence is wider than the map contract. Own state never appears on
  a structure map, but its writes are I/O, and I/O logs, so it appears
  as a target in evidence.
- **A boundary call logs** under the closure's name, with its
  arguments, whatever the closure's shape: a fire-and-forget command,
  an `async throws` fetch, a returning query to the world. Impurity is
  visible in the signature (Wlaschin). `async` and `throws` mark the
  world-crossing that makes a closure a boundary rather than a pure
  helper. The call is the event. What comes back, a value or a thrown
  error, is supplied data, not evidence.

**Reads never log.** A query's answer is data handed in, and getters
fire on the render scheduler's timing, not the node's. One
nondeterministic line poisons an exact-sequence assertion. Binding
getters, view-builder closures, any helper evaluated during rendering:
none of it is evidence.

## Whose source of truth

The test for a write is whose source of truth it lands in, never who
holds the pen. A write into state the node owns or was handed (own
state, a binding, external storage) is the node's I/O and logs, even
when the system performs it on the user's behalf. A text field writing
`title` through its binding logs every keystroke. A toggle writing
`sortDescending` into storage logs. State the system owns and the node
only views, such as focus, is not the node's source of truth. The
system moving focus is data arriving, no entry. The node setting
`isFocused` is asking the system for something, a boundary call wearing
a property's name, and it logs as one.

(The earlier formulation, "who fired it", predicted the focus case and
got the other two wrong. Both counter-examples are pinned logs in
CoreFlowExample. See `coreflow-example-validation.md`, F7.)

## Transcribing a criterion

A declaration is an acceptance criterion transcribed into the log's
vocabulary. *Given* names constructor arguments and stubs. *When* names an
interaction. *Then* names the log. "Given no connection, when the user
searches, then it reports offline and writes no books" is a
construction, a stimulus, and one equality check:

```
["isLoading true", "search dune", "isLoading false", "error offline"]
```

The simplest case is the shelf. Given one book, when the user flips the
sort and swipes delete, then `["sortByAuthor true", "delete Dune"]`: a
binding write and a callback, nothing behind either.

When the log crosses the node's edge, the declaration is drawn (Diagram
4, grammar in `notation.md`) and the array is its test form. When it
touches own state only, the array in the test is the whole declaration.
The block is the source and the test is written from it.

## Discipline that keeps the log honest

- Assert order only when the requirement names an order. For
  interchangeable events the test sorts them into one fixed order
  before comparing, duplicates kept, and the block shows that order.
- `loop` in a block when the requirement names no count. The test then
  asserts the decision. A value the requirement does not pin is a
  symbolic payload, a separate choice from the count.
- Silence is evidence. No `books` entry means the failure wrote nothing.
  In a block, a stimulus with no out-arrow says so.
- Payloads are deterministic. When a value's description is not
  snapshot-stable, declare a symbolic payload for it.
- Record the behavior as-is. A text field that writes its binding twice
  per keystroke logs twice per keystroke. Evidence records what
  happens, not an idealization.
- A workflow is a rule. When a later call consumes an earlier call's
  result, or a failure triggers a compensating call, the node that
  decides the later call declares both in one block: the result is a
  dashed arrow back, the compensation the next out-arrow. A flat
  happy-path block is not it. A multi-step protocol is a node of its
  own exactly when the node rule makes it one.
- Unexpected calls are caught twice. A logged boundary called when the
  block did not say so, or twice, appears in the log and fails the
  equality; the whole log is compared, never a subsequence. A boundary
  the label does not name has no logger in the scenario, so that call
  is the checker's finding, `mapcheck.py --sources`, a call in the
  Swift with no line on the label.

## One event, two edges

A parent and its child each declare evidence, and the same physical
event appears in both, at different edges. The user swipes a book away.
In BookShelf's block that is `BookShelf->>onDelete`, a callback it was
handed. In Library's block it is `Library->>dbService.deleteBook`, a
call at the parent's edge. Both blocks are correct under
whose-source-of-truth. The child owns its callback, the parent owns the
call, and they are separate tests of separate nodes, not
double-counting. A parent's evidence names what
crosses its edge. The child is furniture from there, however many lines
the child's own block has. Nothing in one block references the other,
and depth stays one in each.

The callback is where the two edges meet. In the child's block it is an out-arrow,
`AddItem->>onAdd: eggs`, the child's own I/O. In the parent's block the
same call is the stimulus, `AddItem->>ShoppingList: onAdd eggs`, and
what the parent does about it is that block's evidence. One event, two
edges again, and the direction flips because the callback is the one
sanctioned upward path in the tree.

## What an execution log is not

A mockist interaction test and an execution log have the same shape.
Both are ordered sequences of calls. What separates them is depth, not
form. An execution log names only what crosses the node's own edge, its
contract lines and its own stored properties, and nothing that happens
behind them. The moment a log names how two things inside the boundary
talk to each other, it has stopped describing what the node does and
started describing how its objects talk to one another, and a harmless
refactor will turn it red. That is the failure the targets rule exists
to prevent. A grandchild on a lifeline is depth 2, and depth 2 is where
the thousand mocks begin.

This is Cooper's rule, test the public interface because internals have
no refactoring-stable contract, inherited and not refuted. Data
coupling gives every node such a contract, its initializer and its
boundary events, so the rule applies at every node, and none is tested
through its internals.

## Why the log is complete, and why it is the contract

The log is exhaustive by construction. A core captures nothing it was
not handed, so its parameters are its only channel outward. Instrument
them all and no effect escapes unlogged. A write re-creates the node.
The value that wrote dies in the wave it triggers, while an action it
started runs on, and the writes after its awaits land in the successor's
storage. So a write's consequence never comes back to the value that
made it. The result arrives as a successor's creation inputs, because
the network is reactive so the nodes do not have to be.

Refactor the node and the log cannot change. Only a changed requirement
can. Moving state across the core's edge, into or out of furniture, is
not a refactor; it changes what the node declares. That is why the log, not the structure, is the contract. It is the
one artifact coupled to requirements rather than to how the code is
arranged, so a harmless refactor can never turn it red.

One integration test per cylinder, at the shell, written once, owns
each boundary's real implementation. A node's evidence proves only the
decision to cross the boundary, never what lies behind it.

## Worked material

The eight pinned logs of CoreFlowExample (a text field's double write
per keystroke, a system focus move that logs nothing, an `async throws`
call whose thrown error never appears, a gesture left unpinned on
purpose) are transcribed as evidence blocks in
`coreflow-example-validation.md`, Part 2. They are the ground truth
every sentence above was checked against. The example has since left
CoreFlow, and the transcription is the record.
