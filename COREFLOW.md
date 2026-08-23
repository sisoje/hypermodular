# CoreFlow — reference notes

What `sisoje/swift-core-flow` is, what it has actually verified, and what
that means for the doctrine in this repo. Companion to `HYPERLAMBDA.md`:
background, not doctrine. The skill never names CoreFlow's wrappers — it
describes the *shape* they implement — so this file is where the
specifics live.

Read-only source: `~/dev/CoreFlow` at `d065fd7` (README, CLAUDE.md,
CHRONICLE.md, TODO.md, FLOWUP-PLAN.md, `CoreFlowExample/SPEC.md`).
Retrieved 2026-08-23.

## 1. What it is

A Swift macro package — one library, one dependency — whose headline is:

> Make any SwiftUI project testable. One line, one macro is all you need.

The argument underneath is the one this whole trilogy rests on. A SwiftUI
view is not UI: `body` draws nothing, it computes a description from data,
actions included. It is hard to test because of the *runtime around it*
(`@State` needs a render host, `body` won't evaluate outside one, wrapper
behavior can't hide behind a protocol), not because of how it is written.
The standard cure — move logic into a ViewModel — "does not separate logic
from UI; it separates logic from logic, imposing an architecture to
compensate for a tooling gap."

CoreFlow's answer: leave the view exactly as written and generate a
**runnable twin** whose runtime boundaries are observable or injectable.
The twin is the seam. Adoption is one view at a time, no migration —
*provided the view is plain SwiftUI*. An `ObservableObject` ViewModel has
no node boundary to substitute, so it gets nothing.

## 2. The mechanics

### `@Shell` → `Core`

A member macro on a view, modifier, `App`, or `Scene`. It generates a
nested, always-internal `Core` struct: the same `body` and helpers
**copied as text**, with stored properties rewritten by a whitelist:

| Host | Core | What it buys |
|---|---|---|
| `@State` | `@TestState` (private, sealed out of init) | every write logs, at the write site |
| `@FocusState` | `@TestFocusState` | programmatic writes log; a real `FocusState` underneath, so hosted focus stays live |
| `@AppStorage` / `@SceneStorage` | `@Binding` | external storage becomes an injected backing; keys vanish |
| `@Query` | `@QueryCore` | the fetched array is a bare init parameter; no SwiftData stack |
| everything else | copied verbatim | `@Environment`, `@GestureState(reset:)`, `@Binding`, `@ViewBuilder`, custom wrappers — byte for byte, arguments included |

Verbatim copying is load-bearing: reconstructing `@GestureState(reset:)`
could silently drop a custom closure; a copy cannot. The whitelist ends
where a substitution stops buying a log, an injectable boundary, or a bare
value. `@StateObject`/`@ObservedObject` are *deliberately* unmapped — they
are ViewModel-shaped, the source of truth sits behind a shared reference,
and there is no value boundary to instrument.

Facts verified against the real compiler and recorded in their docs:
`Core` must be nominal (tuples can't conform to `View`); it is always
internal and **release builds ship zero bytes of it** (dead-stripped by
the compiler, no `#if DEBUG` needed); `#Preview` cannot name
macro-generated code, so every preview goes through a hand-written
*scenario* view; Swift emits no coverage instrumentation inside macro
expansions (reproducer posted to the Swift forums).

### The logging family

- **`@TestState`** — a drop-in `@State` that logs every mutation. Real
  `State` storage behind a generated accessor; the setter is the single
  logging point; `$name` routes through the property, so binding writes
  and direct writes log identically.
- **`@TestAction`** — an action closure where *reading the property is the
  logged action*: each call logs an arity-shaped payload, then forwards,
  carrying `return`/`try`/`await` exactly as the declared type needs. Two
  locals captured, never `self`.
- **`@UnstructuredTask`** — a view-owned slot for a cancellable `Task`:
  replacing cancels the previous, teardown cancels the live one, every
  mutation logs `task`/`nil`.
- **`@TestFocusState`** — "the property logs, the projection wires."
- **`testLog { name, value in … }`** — one sink, installed once on the
  root; default is a no-op, so hosts behave normally anywhere else. The
  sink is `@MainActor (String, String) -> Void`; payloads are
  `String(describing:)` frozen at the call site; async action wrappers
  `await` the log in order before forwarding — no fire-and-forget `Task`
  that could reorder lines against synchronous writes.

The one-paragraph justification, from the README, is the best statement of
the evidence doctrine anywhere in the corpus:

> How would Apple test `Button`? Its entire contract is "a physical tap
> calls the action closure" — there is nothing inside to inspect. And that
> contract can silently rot … Exactly one test catches it: hand the button
> an action that *logs*, tap it for real, check the log. … Every `Core` has
> `Button`'s shape: its whole behavior is state writes and calls to
> injected closures.

### `@FlowUp` — closures flowing up

`@Entry` drops a value down the environment. `@FlowUp` is the yoyo:
listeners registered below (`.onFlow(\.name)`) are thrown *up* a
preference channel, an accumulator (`.collectFlow(\.name)`) catches them
and spools one combined closure back *down* the environment, and any
descendant reads a real closure out of `@Environment` and calls it. One
declaration line is a complete deeplinking system. Scoped to the subtree
under its accumulator; subscription is view identity, so unmounting
unregisters. Their own warning: a `.collectFlow` for everything at the app
root "is the global bus you were supposed to be avoiding."

Naming rule worth keeping: a **verb** declares a command (legitimate only
when the listeners *are* the implementation — `deeplink`); a **past-tense
clause** declares a notification (`logoutHappened`) when a service owns the
verb. Never name a flow after the reaction.

### The rest

`@Flowable` (memberwise init at the type's own access level, plus a
`makeFlow` tuple factory), `@Capability` (bundles computed members into a
capability tuple), `#pick` (keypath tuple projection), `Reflector` (field
names off a type). Useful, peripheral to this repo.

## 3. The example app — the ground truth

`CoreFlowExample` is deliberately **collapsed into `SPEC.md`** (490 lines);
`generate.sh` deletes every Swift file and regenerates them headlessly via
the `claude` CLI; `test.sh` runs eight XCUITest suites on a simulator.
Each test launches one *scenario* (selected by a `SCENARIO` launch
variable), drives real taps and typing, waits for the log's names to match,
then asserts the values with one equality.

The eight pinned logs, verbatim from the spec:

| Node | Names | Values |
|---|---|---|
| AddBookField | `title`×10, `insert`, `title` | `"", "", D, D, Du, Du, Dun, Dun, Dune, Dune, Dune, ""` |
| BookList | `sortDescending`, `delete` | `true`, `Anathem` |
| Dimmer | `isDimmed`, `isDimmed` | `true`, `false` |
| SaveButton | `onSave`, `getUserName`, `userName` | `draft`, `42`, `Error fetching user` |
| DragCard | — (timing-dependent; behavior asserts only) | — |
| TrickyDragCard | `resetsSeen` | `1` |
| DownloadButton | `download`, `download`, `cancelsSeen` | `task`, `nil`, `1` |
| FocusField | `isFocused`, `toggleCount` (and `[]` after the system focus move) | `false`, `1` |

This table is the most verified material in the whole corpus. The maps in
`hypermodular/references/coreflow-example-validation.md` were checked
against it twice — structure grammar first, evidence grammar second — and
it is what produced findings F1–F14. Its generated sources are **not on
disk** (gitignored; the chronicle records a failed generator run wiped
them), which is why the code-side half of the registry check has no test
bed yet.

## 4. What CoreFlow has verified that the doctrine leans on

Each of these is a sentence in `SKILL.md` whose backing is a pinned test
or a compiler probe in CoreFlow, not an opinion:

1. **"Pin the material as-is."** TextField writes its binding twice per
   keystroke plus two focus writes. Pinned, not idealized.
2. **"Whose source of truth."** `title` (own state) and `sortDescending`
   (external storage) log when the system writes them; focus does not.
   The first formulation — "who fired it" — was wrong, and this table is
   what showed it (F7).
3. **"The call is the event; what comes back is data."** SaveButton's
   `getUserName` logs `42` (its argument) and the thrown error never
   appears — the fallback lands as the node's own `userName` write.
4. **"Assert order only when the requirement names it."** DragCard gets
   behavior asserts and no log; DownloadButton's cancel order is pinned
   because it is deterministic, and the spec explains *why* it is
   (cancellation inside the action, resumption scheduled later).
5. **"Effects log; getters don't."** Stated in their `testLog` section with
   the same nondeterminism argument the skill uses.
6. **"A boundary in a spec is a logger."** The scenario installs the
   *whole* `BookStore` as logging mocks, `delete` included on a component
   that never deletes — "an unexpected call must poison the log snapshot,
   not vanish into an inert stub." The skill's equality assertion covers
   this without a rule; CoreFlow's practice confirms it.
7. **Dependencies as plain structs of closures.** `BookStore` is
   `struct { var insert; var delete }` with a no-op `@Entry` default and
   an always-equal `Equatable`; the live implementation lives in the app
   beside the SwiftData it wires. Exactly the skill's "environment value."

## 5. Where CoreFlow and the skill deliberately differ

These are answers to different questions, not contradictions — but an
agent holding both documents will trip on them, so they are named.

- **"Dependency."** CoreFlow calls `@AppStorage` external storage and
  injects it as a `@Binding` in tests. The skill says native
  materialization is *not* a dependency — it's facts arriving, tagged
  `· @AppStorage` on the label. Both true: on the map, a source of truth
  that outlives the node; in the scenario, an injected backing. (F5,
  vocabulary table still pending.)
- **Scenarios are not nodes.** `TestApp` selects nine scenarios by launch
  variable; the skill's validation mapped it as a decision node and found
  the decider (`ProcessInfo`) had no label form — now `· @ProcessInfo`
  (F2). The scenarios themselves are test furniture and never get nodes.
- **Own state.** CoreFlow logs every `@State` write; the map never shows
  own state. Reconciled by "evidence is wider than the map contract": own
  writes log, they just don't earn a label line — and under Diagram 4 an
  own-state-only criterion isn't drawn at all.
- **`@FlowUp` is not drawn.** The skill draws a `navService` cylinder and
  says how its closure is assembled — root-owned state, a derived
  service, listeners registered up the tree — is implementation detail.
  `@FlowUp` is one such implementation, the listeners-up-the-tree one. The
  skill must never name it; this file may.
- **Shell/core is never drawn.** The macro *is* the shell/core split; the
  map shows neither. A node on the map is the host; `Core` is how its
  evidence gets checked.

## 6. Conclusions for this repo

1. **The evidence chapter is borrowed from verified practice, not
   invented.** Every discipline bullet in "Declaring evidence" has a
   pinned log behind it (§4). That is the half of the skill to trust most.
2. **The map grammar is the half that was never tested against code** —
   which is why both validation rounds were run, and why the remaining
   risk is prospective use, not retrospective fit.
3. **The code-side registry check needs generated sources.** They exist
   only after `generate.sh` runs in CoreFlow. That is CoreFlow's business,
   not this repo's; this repo's `mapcheck.py` stops at the map edge and
   says so (`UNVERIF`).
4. **The regeneration pipeline is the proof mechanism, if ever wanted.**
   `SPEC.md` → `generate.sh` → `test.sh` is a description-becomes-app loop
   with an automated oracle — the Hyperlambda property, in English. The
   open question this repo cares about is whether maps plus evidence
   blocks can replace the *behavioral* half of that spec and still pass
   the eight suites. Recorded here as the experiment; not run, and not to
   be run from this repo.
5. **The chronicle's unpublished doctrine belongs in the skill already:**
   "the network is reactive so the nodes don't have to be" is in
   Declaring evidence; "material, not reactivity, bounds the method" and
   "Ian Cooper inherited, not refuted" are not, and would fit a
   *why-this-works* reference file when one is written.
6. **Their README's `Button` paragraph is the best one-paragraph pitch for
   rule 3 that exists.** Worth quoting, with attribution, wherever rule 3
   needs defending.

## Sources

- `~/dev/CoreFlow/README.md` — the per-macro reference (10.5k words, every
  sample compiled, every diagnostic capture-matched)
- `~/dev/CoreFlow/CLAUDE.md` — the self-sufficient spec, including rejected
  designs and an 11-item accepted-loss registry
- `~/dev/CoreFlow/CHRONICLE.md` — session history, Jul 30 – Aug 10 2026
- `~/dev/CoreFlow/CoreFlowExample/SPEC.md` — the regeneration spec and the
  eight pinned logs
- `~/dev/CoreFlow/FLOWUP-PLAN.md` — the `@FlowUp` design plan
- [swift-core-flow on GitHub](https://github.com/sisoje/swift-core-flow)
- [SwiftUI Data Flow Masterclass](https://medium.com/@redhotbits/swiftui-data-flow-masterclass-099f0768f776)
  — the conceptual model the macros mechanize
