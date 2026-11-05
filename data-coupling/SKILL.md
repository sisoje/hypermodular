---
name: data-coupling
description: >
  How a SwiftUI node is written, the data-coupled way. A view is a node:
  data in at creation, boundary events out. State is decoupled from
  behavior: open data drives the view, closures act on it. State and
  services are lifted so every feature is constructible from literals.
  Dependencies are structs of closures that flow through the
  environment. A view is cut into shell and core, by hand or with
  swift-core-flow's @Shell, and a test reads the execution log. Use
  whenever writing, reviewing, refactoring, or designing SwiftUI code;
  deciding where state lives; adding a service, capability, environment
  value, or @Entry; making a view testable or previewable; laying out
  packages and modules; or whenever ViewModels, MVVM, @StateObject, TCA,
  reducers, DI containers, protocols for mocking, or .live/.preview
  statics come up. The hypermodular skill beside this one draws the
  maps. This skill writes the code the maps describe.
---

# data-coupling: writing the node

A SwiftUI `View` is not a view. It is a node in a network, a plain
value carrying everything its subtree will show and do. Data enters a
node at one moment, its creation. Everything else it does, a write or a
call, is a boundary event. That is the whole model, and everything in
this skill is that model applied: to where state lives, to what a
service is, to how a view is cut and tested, and to how the modules of
an app meet.

Three sources, in order of authority. When this file and a source
disagree, the source wins. Flag the disagreement.

- [SwiftUI Data Flow Masterclass](https://medium.com/@redhotbits/swiftui-data-flow-masterclass-099f0768f776),
  the model: nodes, identity, waves, boundary events, the shell/core
  cut, testing as reading the execution log.
- [TDD Is Dead. Long Live TDD.](https://medium.com/@redhotbits/tdd-is-dead-long-live-tdd-f85b4b9eacbd),
  the method: lift state and services, lock the core with its log, plug
  in the shell, delegate the detail.
- [swift-core-flow](https://github.com/sisoje/swift-core-flow), the
  mechanics: the cut and the log as macros, and a hosted UI-test host
  that asserts the log.

Four references hold the detail, one per job: `references/data-flow.md`
(the runtime model), `references/shell-core.md` (cutting a view),
`references/testing.md` (the execution log and the test host),
`references/modules.md` (the data coupling layer and the module graph).

## The rule

**Decouple state from behavior.** Not UI from logic. There is no UI in
a node to separate. A `View` holds data, closures, and a transformation
from inputs to children; the runtime owns the pixels. A ViewModel takes
logic out of a node that is already only logic, and adds an object to
hold it. The cut that matters runs between data and the closures that
act on it. State is open, plain data that drives the view. Behavior is
closures the app sets into the flow at the root. The UI is pure and
data-driven, and the main app is where behavior enters.

That is the opposite of the OOP doctrine. Kay's object retained,
protected, and hid its state. Parnas had asked only to hide the design
decision, how a thing is represented and how an operation works. Hiding
the how gives a boundary. Hiding the state gives an object that must be
driven into every condition instead of constructed in one. So:

- **State is open.** Every value a node renders enters it as a `let`, a
  `@Binding`, an environment value, or its own `@State`. Nothing sits behind a private setter,
  an accessor that decides what you may read, or a factory that decides
  what you may build.
- **Every state is valid by definition.** A view is a function of its
  state. Whatever it is handed, it shows. There is no invariant to guard
  and no validation before construction. A state the view cannot show is
  a missing branch in `body`, not a bad value. A check such as
  `canSubmit` is one more value computed from the state. An edge case is
  a constructor argument.
- **State drives the view; behavior arrives as data.** A fact is a
  `let`, mutable state a `@Binding`, a service a closure. The node calls
  the closure with its payload and does not depend on what the call
  does. The app composes behavior. The UI never knows an implementation
  exists.
- **Everything that enters a node is a value, closures included, so
  every mock is a value and mock depth is one.** A function type has no
  members to stub. The signature is the whole contract, and nothing is
  behind it. An OO mock had to simulate an object, and an object's
  behavior reaches down through its collaborators, so depth was
  transitive. That is what test-driven development died of. Here the
  coupling is data before any test exists, so a logging closure or a
  logging binding is the entire mock, and it is written before the real
  service is.

Three sentences follow, one per source. Every rule below is one of them
applied.

1. **Data in at creation, boundary events out, nothing else.** A node's
   whole observable behavior is the children it creates and its boundary
   events: the mutations it performs, the calls it makes, their payloads.
   Nothing else about a node is observable, which is what makes it
   testable.
2. **Lift the state, lift the services, and what is left is the feature,
   pure.** A fact becomes a `let`, mutable state a `@Binding`, a service
   a closure. Anything an acceptance criterion names enters the feature
   that way. Purely presentational state stays local. When unsure, lift.
3. **Anything constructible from literals is testable by construction.**
   If a core cannot be constructed from inline literals, a boundary is
   missing, and the call site shows it before any test runs.

## Model: a node in a network

SwiftUI is a reactive dataflow system of dependency nodes. That is a
structural definition, what SwiftUI is. "A declarative framework that
describes UI as a function of state" is a behavioral one, and it is the
source of most broken SwiftUI mental models.

- `View`, `ViewModifier`, `App`, and `Scene` are the same entity: values
  that are nodes in the graph, each carrying the dependencies needed to
  compute its `body`. `body` is a transformation, input data in and
  child nodes out, computed on demand and discarded.
- **The struct has no lifecycle.** The runtime retains the network, the
  identity slots holding lifetime metadata and any `@State`, and not the
  nodes. Node values are created and discarded each wave. Identity is
  structural, type and position among siblings, unless `.id()` overrides
  it. Flipping an `if` is a teardown, not an update.
- **Dependencies are recorded by access.** A wrapper read during `body`
  registers its storage against that slot. A write to registered
  storage invalidates the slots that depend on it, and the runtime
  re-runs those transformations and no others.
- **A boundary event is one that changes a source of truth**, storage
  some node reads. A binding write whose setter chain ends in storage
  changes one, and the next wave follows. A fire-and-forget request
  changes none. The loop closes through storage and re-creation, never
  through a backward edge.
- **Wrappers divide in three.** Sources of truth (`@State`,
  `@AppStorage`, `@SceneStorage`, `@Query`) hold a plain value the node
  owns or materializes. References (`@Binding`, `@Environment`) hold
  nothing. Each points at a value an ancestor owns, one handed in at
  the initializer, the other set above with `.environment(...)`. Both
  are data in. UI-runtime machinery (`@GestureState`, `@FocusState`,
  `@Namespace`, `@ScaledMetric`) holds nothing a caller could supply.
  All three resolve only inside a `View`, `App`, `Scene`,
  `ViewModifier`, or another `DynamicProperty`. Inside a class they do
  nothing.
- **Classes sit outside the graph.** Put a screen's state in an
  `@Observable` or `ObservableObject` and the runtime no longer owns it.
  The object can be aliased, can outlive the node, and any holder can
  write around the node's boundary. An `@Observable` model is fine as
  data, a row the node reads. It breaks the model the moment it owns a
  screen's state and actions.

Every MV\*\* pattern the community reached for was solving a problem the
wrong mental model created. The view is the reducer. Each state
transition lives in the node that owns the storage, next to the UI that
triggers it. Mechanics, identity in collections, feedback cascades and
their fixes are in `references/data-flow.md`.

## Lift: the feature as a stateless tree

A feature needs only its data, models and closures, read off the UI.
The rows are a `let`; someone above will provide them. The toggle is a
`@Binding`. The destructive swipe is a closure. The screen dictates its
own signature, and modeling is transcription. Model the feature first,
against nothing:

```swift
struct BookShelf: View {
    let books: [Book]                 // a sorted fetch, eventually
    @Binding var sortByAuthor: Bool   // storage, eventually
    let onDelete: (Book) -> Void      // a service, eventually

    var body: some View {
        List {
            Toggle("Sort by author", isOn: $sortByAuthor)
            ForEach(books) { book in
                Text(book.title)
                    .swipeActions {
                        Button("Delete") { onDelete(book) }
                    }
            }
        }
    }
}
```

Nothing behind it exists and the feature compiles. It is a wireframe
you can type-check. There is no singleton, no context, and no service locator
to reach for, so every dependency is named at an initializer or it
cannot be used.

- **What did not happen: injection.** Injection, in the object sense,
  implies a stored reference to a stateful service, a lifetime the
  consumer manages. A view stores closures, but it is an ephemeral
  value with no lifetime and nowhere to inject into. Dependencies flow,
  like everything else. Data at the boundary is dependency rejection:
  values in, values out. Closures at the boundary are dependency
  parameterization: behavior handed in as a function. Neither is
  injection.
- **Where a closure enters, and where a write goes.** A closure the
  parent decides is an initializer argument: `onDelete`. A capability
  the app provides whoever the parent is a contract, set at the root
  and read from the environment: the store, the network, navigation. If
  every parent would hand the same closure, it is a contract. A
  write to state an ancestor holds in memory is a binding write. A
  write that leaves the tree is a closure call.
- **An edge case is a constructor argument**, or a driven sequence of
  them. The empty shelf is `books: []`. The error is a value handed in.
  The slow network has no duration, because the core is handed the
  result. Those are the previews, too.
- **Slices want structural types.** A node is coupled to whatever type
  its parameters name, so pass the fields a view reads, not the whole
  model. When a slice must travel as one value, a labelled tuple is its
  fields with no name to mint. Reach for a struct the moment the slice
  needs a protocol, such as `Identifiable` for `ForEach`. Behavior
  bundles the same way. `(save: (Book) -> Void, delete: (Book) -> Void)`
  grants two verbs, and the consumer has nothing else to couple to.
- **The price is plumbing you can see**, parameters threading through
  views that never read them, instead of coupling you cannot see. Over a
  stateless middle, relocating a source of truth is an initializer
  refactor, and the compiler lists every site.

## Cut: shell and core

The line SwiftUI offers is I/O versus pure transformation, not UI
versus logic. A view with live wrappers is the shell. `@State` installs
real storage on render, `@Query` talks to a real `ModelContext`,
`@AppStorage` reads `UserDefaults`. That I/O is fused into the type and
runs only inside a live render pipeline. The core is the same `body`
against data at the boundary. Three rules cut it:

1. **Plain fields go to the core.** They are already data.
2. **Data-holding wrappers become boundaries.** `@AppStorage` and
   `@SceneStorage` become `@Binding`. `@Query` becomes a plain `let`
   array. `@State` that only the core needs may stay. State a test must
   reach moves up and enters as `@Binding`.
3. **Machinery stays in the shell.** The shell owns the gestures, the
   focus, and the namespaces, and hands the core plain values. The
   environment is not machinery. A core reads it as it reads a binding.
   Apple's sealed actions are the by-hand exception in the table below.

Two ways to make the cut, one contract:

| | By hand | With `@Shell` (swift-core-flow) |
|---|---|---|
| The core | a second view, `BookListCore`, constructed by the shell's one-line `body` | a nested `Core` twin the macro generates. Same `body` text, copied by the compiler, so it cannot drift |
| Own `@State` | stays if only the core needs it; lifted to `@Binding` if a criterion names it | stays private as `@TestState` and logs every write. The write site emits the evidence |
| External storage, fetched data | `@Binding`, `let` | `@Binding`, `@QueryResult` (tests pass the bare array) |
| Machinery | shell | copied verbatim: live when hosted, defaulted otherwise. `@FocusState` becomes `@TestFocusState` and logs |
| Environment values, your own `@Entry` | the core reads them. The scenario sets them with `.environment(...)` | copied verbatim. The scenario sets them with `.environment(...)` |
| Apple's sealed actions, `\.dismiss`, `\.openURL` | the shell reads them and hands the core a closure, because nothing can build one from above | `@TestEnvironment`: the real action runs, every call logs |

Either way, what reaches a core is a value. A model context, a
session, a socket, a token refresher: a service that holds state is
wrapped in closures at the root before it is set, and the core reads
the closures. And there is one shell wherever the I/O is, not one per
view. A view made only of `let`s, bindings, environment reads, and
closures is already a core.

A closure of any signature is a behavior, sync or async, pure or not.
The node calls it and does not care what it does. For mocking, what a
core consumes falls into three shapes, and the shape says how it flows
in and how a test stands in for it:

| Shape | What it is | Flows in as | In a test |
|---|---|---|---|
| source of truth | input the core reads | a `let` (a fetch result), a `@Binding`, an environment value | hand it data: a constant binding, a stubbed array |
| black hole | a sink the core gives data to and forgets | a closure: `save(model)`, `haptic()`, analytics | a spy: assert it was called, with the right payload |
| async effect that can fail | a result the core awaits but does not implement | an `async throws` closure: `try await load()` | a stub per edge case (a value, an error, a delay), one test each |

The core's need decides the shape. Awaited, it is an async effect.
Fired and forgotten, a black hole. The same `save` can be either.
`async` is the I/O marker for what the core awaits. A black hole is
synchronous because the core does not await it; the root's closure may
start its own task. An `async` or `throws` closure announces a boundary
that belongs behind a contract. Pure logic is synchronous and
non-throwing, and needing `async` in it means the code is in the wrong
layer. `grep async` finds every awaited boundary. The wrapper table, the worked
examples, and who owns the loading flow are in
`references/shell-core.md`.

## Test: read the execution log

How would Apple test `Button`? Its contract is "a physical tap calls the
action closure", and there is nothing else to inspect. Hand it an action
that logs, tap it for real, check the log: `["action"]`. Every core has
`Button`'s shape. Mock each boundary with a logger, drive the core, and
assert the execution log, the ordered `(name, value)` record of its
boundary events, every write and every call with its payload. An entry
is the boundary's own name, never the contract's, a space, then the
arguments in order: `isLoading true`, `onDelete Dune`, `setStarred Dune
true` and never `favorites.setStarred`, `load`.

- **Mocking is construction.** A boundary is a value, so the mock is a
  value, one wrapper deep. A logging binding records the name and the
  new value before storing. A logging closure records its payload and
  forwards nowhere. A contract's no-op default already stubs all three
  shapes, and a test overrides only the closure it spies on.
- **The test is the hosted scenario.** A scenario is a view that owns
  real `@State`, hands the core logged bindings and closures, sets its
  contracts with `.environment(...)`, and is driven with real input in
  a UI test. The real runtime runs: identity, environment, `@State`,
  `.task`. Whether an action is a method or an inline call does not
  matter; the input fires it. Constructing a core in a unit bundle and
  calling a method sees only the `@Entry` defaults, because
  `@Environment` resolves only inside a render pipeline, and proves
  almost nothing. It is not the method's test.
- **A UI test here is a unit test, and the host is designed once.** A
  second, test-only `@main` over the feature code renders one scenario
  named in the launch environment and nothing else. Nothing else of the
  app exists in the process. One scenario per core, in its own file,
  and the same scenario is the preview and the launch target of the UI
  test. A new unit is one enum case,
  one scenario, one test. The host never learns the app's structure.
- **Effects log, getters don't.** Writes and calls fire once per event.
  Reads fire on the render scheduler's timing. Never log from a `get`.
- **Test the action, not the aftermath.** A core test proves an action
  executed with the right input, the closure called with the expected
  model or the binding written, plus the immediate state. It never
  asserts that the result later appears on screen. That is a different
  view tree, and the assertion would be testing SwiftUI.
- **Assert the order the criterion names.** Where two writes are
  interchangeable the log is a set, not a sequence. Silence is evidence
  too. No `books` entry means the failure wrote nothing.
- **Mock depth is one, permanently.** What the real `fetch` does with a
  304 is a separate question with a separate test, one per boundary, at
  the shell, written once. Refactor the core and the log cannot change.
  Only a changed requirement can. That is why the log is the contract.

Scenarios, the host, transports across the UI-test process
boundary, and the hosted test in swift-core-flow are in
`references/testing.md`.

## Layer: the data coupling layer

What the modules share is one more module, free of behavior: the data
coupling layer, the models, the closure signatures, and the
`EnvironmentValues` entries that propagate them. The composition root
constructs the implementations, features consume them, and the two meet
nowhere but in that layer's types.

- **A contract is a struct of closures, lets, or bindings** with a
  defaulted initializer, and its `@Entry` default is the minimal no-op,
  `.init()`. The `@Entry` belongs to the layer, beside the contract it
  defaults. An environment value is data flow: set at the root,
  replaced by a scenario, read by a core. The nodes that consume it dictate its signature, never the
  implementation that will satisfy it. No protocols, no classes, no
  reference-type service objects.
- **Data carries no behavior.** Models are stored properties and
  initializers. Computed members live as pure extensions in the feature
  layer. A class as data only when it earns it, for a lifecycle a struct
  cannot own, for `@Bindable` decomposition, or for per-element
  observation, and even then it stays pure data. `deinit` is the one
  behavior allowed, and only to release what the object holds: cancel a
  task, stop a manager, tear down a subscription. A type earns its place
  in the layer only by crossing a module boundary.
- **The root sets live values inline, where it sets them.** One
  modifier per system framework, each framework imported in one file,
  the chain applied inline at `@main` and read top to bottom. No
  `.live`, `.preview`, or `.unimplemented` statics and no `+Live` files.
  The default serves previews and tests, and a scenario builds the
  logger.
- **Every dependency points at data.** Features and I/O modules both
  depend on the layer and never on each other. The app depends on all of
  them. A stateless module is algorithms and cores, importable anywhere.
  The state sits at the top, in the app that composes the modules.
- **Seeing a capability couples nothing; consuming it does.** Apple
  exposes everything to every feature through the environment. The
  core's consumption is named at an initializer or at an `@Environment`
  read. A closure can only be called.

The graph, the composition root, flow versus injection, the capability
shapes, and when a protocol wins are in `references/modules.md`.

## swift-core-flow, by the rule it mechanizes

One dependency, independent macros. Adopt one view at a time, with
nothing rewritten. Each row is a rule above and its mechanized form.

| Rule | Macro or view |
|---|---|
| the cut, with own state logging at the write site | `@Shell` generates `Core`; `@TestState`, `@TestAction`, `@TestFocusState`, `@TestEnvironment` |
| the scenario as a hosted UI test | `HostApp<Scenario>`, `uiTestLog()`, `CoreFlowUITesting` |
| `@Query` as input: one shell owns the live query, content reads plain data | `QueryView` with `dependencies:`, `@QueryResult`, `.mockQuery` |
| a value derived from inputs, kept across renders, never `@State(wrappedValue:)` in an `init` | `MemoView` |
| a view-owned task that cancels on replacement and on teardown | `@UnstructuredTask` |
| capabilities: hand a consumer only the operations it needs, as a tuple | `@Capability` over a type or an extension |
| slices: a tuple of the fields a node reads, from one or more sources | `#pick(from:)` |
| the memberwise `init` a data package needs public, and construction inputs as a tuple | `@Flowable` generates `init`, `InFlow`, `makeFlow(_:)` |
| events up the tree and one closure back down the environment, for deeplinks and scoped notifications | `@FlowUp` with `.collectFlow` and `.onFlow` |

## Do not

- **Hide state behind an object.** Private setters, invariant guards,
  validating factories, a model that fuses its fields with the methods
  that change them. In every one of these, state must be driven into a
  condition instead of constructed in one. Open state is the point.
- **A ViewModel, or any `@Observable` or `ObservableObject` owning a
  screen's state and actions.** A node is already pure logic. Pulling
  logic out of it separates logic from logic and adds an object.
  `@StateObject` and `@ObservedObject` have no value-shaped boundary to
  substitute, which is why swift-core-flow leaves them unmapped.
  Renaming it a store, client, or manager and handing it in as a
  dependency changes nothing. A dependency with methods is still an
  object. Erase it into closures: networking as an async function, a
  validator as a plain closure or a value computed from the state.
- **A service locator, singleton, DI container, or protocol per
  dependency with a mock class behind it.** Nothing has a constructor
  waiting to be filled. A value the root sets into the environment is replaced in a preview
  or a scenario by setting it again there, and a struct of closures gives the same
  substitutability as a protocol with a third of the code. A protocol
  wins only for Objective-C interop, for a plugin API external callers
  must implement, or for a ten-method API with shared default behavior.
- **`.live`, `.preview`, or `.unimplemented` statics and `+Live` files.**
  They attach an implementation to a contract type, scatter the type
  across packages, and move the wiring one file away from the root
  modifier that sets the value.
- **A dependency whose live value can be made with no inputs.** It is
  a constant.
  Use it directly.
- **A chain of `.onChange` modifiers** where the second observes what
  the first wrote. One keystroke, three waves, and the transition lives
  in no node. Derive instead of store. Do the whole transition in one
  boundary event. Use `.onChange` only for a single terminal reaction to
  a value the node does not own.
- **Asserting the aftermath, or logging from a getter.** Both make a
  test assert the runtime's timing instead of the node's decisions.
- **Grouping for grouping's sake.** A `ViewState` umbrella, a data
  struct wrapped around a single view's properties, a helper that wraps
  a single-use sequence. Each is a jump the reader must make. Bundle by
  operation, not by screen. A `View` is already a struct.
- **Designing for the what-if.** "What if someone forgets to set the
  entry?" Then the no-op default runs and the preview shows it. No
  guard, no runtime assertion that a value was set, no fallback path
  for a misuse. The architecture does not protect itself from its
  authors.

## Vocabulary

The articles' terms. Use them. They make discussion precise in a way
"view", "update", and "re-render" do not.

| Term | Meaning |
|---|---|
| node | a view or view modifier, an ephemeral value created fresh each wave |
| network | the identity, position, and attached storage the runtime retains across waves |
| flow | data moving during a wave, down into inits or up through preference accumulation; every flow terminates in node creation or a source of truth |
| transformation | `body`, input data in, child nodes created |
| wave | one pass of re-creation; the runtime re-runs the transformations whose inputs changed, and no others |
| source of truth | storage some node reads (`@State`, `@AppStorage`, `@SceneStorage`, `@Query`); changing one triggers the next wave |
| self-loop | `@State`, an edge to the node's own next creation, not to another node |
| boundary event | a binding write or action call; re-enters the flow only if it changes a source of truth |
| reshaping | a wave that changes structure, not only values; the rare case |
| reference | `@Binding` or `@Environment`: holds no state, points at a value an ancestor owns, set at the initializer or above with `.environment(...)` |
| machinery | Apple's UI-runtime wrappers that hold no suppliable data (gestures, focus, namespaces, metrics) |
| shell / core | the view owning the live property wrappers and services, one wherever the I/O is / the feature as pure transformation, values and closures in, children and boundary events out |
| scenario | a test-host view owning real `@State`, handing down only logged boundaries |
| execution log | the ordered `(name, value)` record of boundary events, every write and call with its payload; a core's behavior, as data |
| mock depth | how many levels of internals a mock must assume; transitive through an object graph, constant at one for a closure |
| wireframe you can type-check | the feature modeled against nothing: compiles, names every dependency, implements no behavior |
| dependency rejection | data at the boundary; the core has no dependencies, values in, values out (Seemann's term, via Wlaschin) |
| dependency parameterization | closures at the boundary; behavior handed in as a function (Wlaschin) |
| data coupling layer | the one shared module, free of behavior: models, closure signatures, and the `EnvironmentValues` entries that propagate them |
| the consumer is the test | a boundary's implementation is judged by the feature that consumes it |

## References

- Lazar Otasevic, [SwiftUI Data Flow Masterclass](https://medium.com/@redhotbits/swiftui-data-flow-masterclass-099f0768f776)
- Lazar Otasevic, [TDD Is Dead. Long Live TDD.](https://medium.com/@redhotbits/tdd-is-dead-long-live-tdd-f85b4b9eacbd)
- Lazar Otasevic, [TDD: Death by a Thousand Mocks](https://medium.com/@redhotbits/tdd-death-by-a-thousand-mocks-26adb60cbe43),
  why the axis is authority, and why mock depth is what TDD died of
- Lazar Otasevic, [swift-core-flow](https://github.com/sisoje/swift-core-flow),
  `@Shell`, `@TestState`, `@TestAction`, `QueryView`, `HostApp`
- Edward Yourdon & Larry Constantine, *Structured Design* (1979), where
  the coupling taxonomy and the term "data coupling" come from
- Scott Wlaschin, [Six approaches to dependency injection](https://fsharpforfunandprofit.com/posts/dependencies/)
  and [Designing with capabilities](https://fsharpforfunandprofit.com/cap/)
- Mark Seemann, [Impureim sandwich](https://blog.ploeh.dk/2020/03/02/impureim-sandwich/)
- Gary Bernhardt, [Boundaries](https://www.destroyallsoftware.com/talks/boundaries)
- Apple, [Data Flow Through SwiftUI](https://developer.apple.com/videos/play/wwdc2019/226/)
  (WWDC19) and [Demystify SwiftUI](https://developer.apple.com/videos/play/wwdc2021/10022/)
  (WWDC21)
