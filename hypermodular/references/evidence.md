# Evidence — declaring a node's behavior as data

`SKILL.md` rule 3 in full. Read this when declaring or reviewing a
node's evidence; the skill's two example logs are enough for reading
one.

## The log

A node's declared behavior is one value: the evidence log — the ordered
`(name, payload)` record of its I/O. Two kinds of entry, nothing else:

- **A source-of-truth mutation logs** under the property's name: a
  binding write, an external-storage write, the node's own state write.
  Evidence is wider than the map contract — own state never appears on
  a map, but its writes are I/O, and I/O logs.
- **A boundary call logs** under the closure's name, with its
  arguments — whatever the closure's shape: a fire-and-forget command,
  an `async throws` fetch, a returning query to the world. Impurity is
  visible in the signature (Wlaschin): `async` and `throws` mark the
  world-crossing that makes a closure a boundary rather than a pure
  helper. The call is the event; what comes back — a value or a thrown
  error — is supplied data, not evidence.

**Reads never log.** A query's answer is data handed in, and getters
fire on the render scheduler's timing, not the node's — one
nondeterministic line poisons an exact-sequence assertion. Binding
getters, view-builder closures, any helper evaluated during rendering:
none of it is evidence.

## Whose source of truth

The test for a write is **whose source of truth it lands in**, never
who holds the pen. A write into state the node owns or was handed — own
state, a binding, external storage — is the node's I/O and logs, even
when the system performs it on the user's behalf: a text field writing
`title` through its binding logs every keystroke; a toggle writing
`sortDescending` into storage logs. State the system owns and the node
merely views — focus — is not the node's source of truth: the system
moving focus is data arriving, no entry; the node setting `isFocused`
is asking the system for something, a boundary call wearing a
property's name, and it logs as one.

(The earlier formulation — "who fired it" — predicted the focus case
and got the other two wrong. Both counter-examples are pinned logs in
CoreFlowExample; see `coreflow-example-validation.md`, F7.)

## Transcribing a criterion

A declaration is an acceptance criterion transcribed into the log's
vocabulary: *given* names constructor arguments, *when* names an
interaction, *then* names the log. "Given no connection, when the user
searches, then it reports offline and writes no books" is a
construction, a stimulus, and one equality check:

```
["isLoading true", "search dune", "isLoading false", "error offline"]
```

The simplest case is the shelf: given one book, when the user flips the
sort and swipes delete, then `["sortByAuthor true", "delete Dune"]` —
a binding write and a callback, nothing behind either.

When the log crosses the node's edge, the declaration is drawn (Diagram
4, grammar in `notation.md`) and the array is its test form; when it
touches own state only, the array in the test is the whole
declaration. The block is the source and the test is written from it.

## Discipline that keeps the log honest

- Assert order only when the requirement names an order; interchangeable
  events are a set; if only the final decision matters, assert the
  decision.
- `loop` in a block when the requirement names no count; the test then
  asserts the decision. A value the requirement doesn't pin is a
  symbolic payload — a separate choice from the count.
- Silence is evidence — no `books` entry means the failure wrote
  nothing. In a block, a stimulus with no out-arrow says so.
- Payloads are deterministic: when a value's description isn't
  snapshot-stable, declare a symbolic payload for it.
- Pin the material as-is: a text field that writes its binding twice
  per keystroke logs twice per keystroke. Evidence records what
  happens, not an idealization.
- A workflow is a rule: when a later step consumes an earlier step's
  result, or a failure needs compensation, model that protocol as its
  own node — a flat happy-path log is not it.
- Unexpected calls need no rule: the whole dependency struct is
  loggers in a spec, so a call the declaration didn't name appears in
  the log and fails the equality. It poisons the snapshot instead of
  vanishing into an inert stub.

## One event, two edges

A parent and its child each declare evidence, and the same physical
event appears in both — at different edges. The user flips the shelf's
sort toggle: in BookShelf's block that is `BookShelf->>sortByAuthor`,
a write into a binding it was handed; in Library's block it is
`Library->>sortByAuthor`, a write into the storage it materializes. The
swipe is `BookShelf->>onDelete` one level down and
`Library->>dbService.deleteBook` at the parent's edge. Both blocks are
correct under whose-source-of-truth — the child owns the binding it
was handed, the parent owns the storage — and they are separate tests
of separate nodes, not double-counting. A parent's evidence names what
crosses *its* edge; the child is furniture from there, however many
lines the child's own block has. Nothing in one block references the
other, and depth stays one in each.

## What an evidence log is not

A mockist interaction test and an evidence log have the same shape:
both are ordered sequences of calls. What separates them is depth, not
form. An evidence log names only what crosses the node's own edge — its
contract lines and its own stored properties — and nothing that happens
behind them. The moment a log names how two things *inside* the
boundary talk to each other, it has stopped describing what the node
does and started describing how its objects talk to one another, and a
harmless refactor will turn it red. That is the failure the targets
rule exists to prevent: a grandchild on a lifeline is depth 2, and depth
2 is where the thousand mocks begin.

## Why the log is complete, and why it is the contract

The log is complete by construction: a node's write is the last thing
it ever does — it dies in the wave it triggers, and the result arrives
as its successor's creation inputs. The network is reactive so the
nodes don't have to be.

Refactor the node and the log cannot change; only a changed requirement
can. That is why the log, not the structure, is the contract: it is the
one artifact coupled to requirements rather than to how the code is
arranged, so a harmless refactor can never turn it red.

One integration test per cylinder, at the shell, written once, owns
each boundary's real implementation. A node's evidence proves only the
decision to cross the boundary — never what lies behind it.

## Worked material

The eight pinned logs of CoreFlowExample — a text field's double write
per keystroke, a system focus move that logs nothing, an `async throws`
call whose thrown error never appears, a deliberately unpinned gesture —
are transcribed as evidence blocks in `coreflow-example-validation.md`,
Part 2. They are the ground truth every sentence above was checked
against.
