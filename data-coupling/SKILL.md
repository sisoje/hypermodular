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
  converting or migrating a legacy codebase one view at a time;
  deciding where state lives; adding a service, capability, environment
  value, or @Entry; making a view testable or previewable; laying out
  packages and modules; starting an app or adding a package, a target,
  or a dependency to one; or whenever ViewModels, MVVM, @StateObject, TCA,
  reducers, DI containers, protocols for mocking, or .live/.preview
  statics come up. The hypermodular skill beside this one draws the
  maps. This skill writes the code the maps describe.
---

# data-coupling: writing the node

**Whatever you are making, lift, and keep the state apart from the
behavior that mutates it.** State drives a SwiftUI node, and the
driver is kept apart from it. Lift the state out of the view, to the
node above that can own it, as open data. Lift the mutating behavior
out of the view too, as closures the root sets and as rules that run
above the view. Keep the two apart, the state plain data, the behavior
closures over it, not one object holding both. Mutating behavior is
simple. It operates on bindings, and where it must hold a reference,
on an `@Observable` class it mutates, in the class cases this skill
names, a model class and a framework delegate. The word is not "logic", which
names nothing precise. Do this first, before anything else in this
skill, for every view you write.

A SwiftUI `View` is not a view. It is a node in a network, a plain
value carrying everything its subtree will show and do. Data enters a
node at one moment, its creation, through the initializer or the
environment. Everything else it does, a write or a call, is a boundary
event. That is the whole model, and everything in
this skill is that model applied: to where state lives, to what a
service is, to how a view is cut and tested, and to how the modules of
an app meet.

Three sources this file was distilled from. What wins, in order: a
ruling recorded in the repo's `TODO.md`, then this file, then the
sources; a disagreement with a source is flagged, not obeyed, the
environment read being the case (F23).

- [SwiftUI Data Flow Masterclass](https://medium.com/@redhotbits/swiftui-data-flow-masterclass-099f0768f776),
  the model: nodes, identity, waves, boundary events, the shell/core
  cut, testing as reading the execution log.
- [TDD Is Dead. Long Live TDD.](https://medium.com/@redhotbits/tdd-is-dead-long-live-tdd-f85b4b9eacbd),
  the method: lift state and services, lock the core with its log, plug
  in the shell, delegate the detail.
- [swift-core-flow](https://github.com/sisoje/swift-core-flow), the
  mechanics: the cut and the log as macros, and a hosted UI-test host
  that asserts the log.

Six references hold the detail, one per job: `references/data-flow.md`
(the runtime model), `references/shell-core.md` (cutting a view),
`references/testing.md` (the execution log and the test host),
`references/modules.md` (the data coupling layer and the module graph),
`references/converting.md` (a codebase that already exists, taken out
of its ViewModels one node at a time), `references/app-structure.md`
(what goes where on disk: the packages, the targets, the project
file).

## The rule

**Decouple state from the behavior that mutates it.** Not UI from
logic. There is no UI in a node to separate, and "logic" names nothing
precise. A `View` holds data, closures, and a transformation
from inputs to children; the runtime owns the pixels. That is why MVVM
is wrong here, precisely. A UIKit view exists. It is an object that
stays, so state and behavior were put in an object beside it. A SwiftUI
node does not exist that way. All it does is transform its
dependencies, and what the runtime does with the result, diffing,
managing, rendering, is not the node's concern. With no object that
stays there is nothing to attach a ViewModel to. So the state is
lifted, the mutating behavior is lifted too, and the two are kept
apart. A ViewModel does the opposite. It takes behavior out of a node
that is already only a transformation of its inputs, and adds an
object to hold it with the state. The cut that matters runs between
data and the closures that act on it. State is open, plain data that
drives the node. Behavior is closures the app sets into the flow at
the root, and it operates on bindings, or where it must hold a
reference, on an `@Observable` class it mutates, a model class or a
framework delegate. A rule the feature owns, a validation, is a pure
function of its state and stays with the feature, run above the view
that shows its result.
The node is pure and data-driven, and the main app is where behavior
enters. That is also why every ViewModel converts with no remainder.
It holds state and the behavior that mutates it, and nothing else.
The state lifts and is consumed as a `let`, a `@Binding`, or a
reference model read as data. The behavior lifts and is consumed the
same way, as a closure, and it mutates through the same bindings the
view reads, or the same model object. Both halves arrive as values,
construction above and capabilities below, the two meet in the
binding, and nothing is left over that needs an object to hold it.

That is the opposite of the OOP doctrine. Kay's object retained,
protected, and hid its state. Parnas had asked only to hide the design
decision, how a thing is represented and how an operation works. Hiding
the how gives a boundary. Hiding the state gives an object that must be
driven into every condition instead of constructed in one. So:

- **State is open.** Every value a node renders enters it as a `let`, a
  `@Binding`, an environment value, or its own `@State`. Nothing, in a
  view or in a model, sits behind a private setter, an accessor that
  decides what you may read, or a factory that decides what you may
  build.
- **Every state is valid by definition.** A view is a function of its
  state. Whatever it is handed, it shows. There is no invariant to guard
  and no validation before construction. A state the view cannot show is
  a missing branch in `body`, not a bad value. A check such as
  `canSubmit` is one more value computed from the state. An edge case is
  a constructor argument.
- **State drives the view; behavior arrives as data.** A fact is a
  `let`, mutable state a `@Binding`, a service a closure. The node calls
  the closure with its payload and does not depend on what the call
  does. The app composes behavior. The UI does not know an implementation
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

Three sentences follow, distilled from the sources above. Every rule
below is one of them applied.

1. **Data in at creation, boundary events out, nothing else.** A node's
   whole observable behavior is the children it creates and its boundary
   events: the mutations it performs, the calls it makes, their payloads.
   Nothing else about a node is observable, which is what makes it
   testable.
2. **Lift the state, lift the services, and what is left is the feature,
   pure.** Four keys decide a design. Construction decides where a
   source of truth lives. Whatever the root can name, it builds, and
   hands down as a projection. A static key names `@AppStorage`, so the
   root owns the app's finite set of keys and no feature names one. The
   container is opened at the root. A scene names `@SceneStorage`, so
   the scene's root. A node's own `@State` the root could only invent,
   so it stays where it is used, and the cut tests it there. A `@Query`
   is a read, like a binding or an environment value, a filtered
   projection of the store the root opened; it lives where it is read,
   at the common ancestor when several features read it. Usage decides what a feature
   receives. It receives what it uses, a fact as a `let`, a setting as
   a `@Binding`, a service as a closure, and it makes its queries over
   the models it sees. Actions are behavior. They are closures the root
   sets, and a write or a call is the event. Mockability is the test.
   Every boundary is a value a scenario stands in for, so the test is
   the log. State is not centralized on principle.
3. **Anything constructible from literals is testable by construction.**
   If a core cannot be constructed from inline literals, a boundary is
   missing, and the call site shows it before any test runs. The
   construction is the scenario's, where the environment resolves; a
   unit bundle constructs the same core and sees only defaults.

## Model: a node in a network

SwiftUI is a reactive dataflow system of dependency nodes. That is a
structural definition, what SwiftUI is. "A declarative framework that
describes UI as a function of state" is a behavioral one, and it is the
source of most broken SwiftUI mental models.

- `View`, `ViewModifier`, `App`, and `Scene` are the same entity: values
  that are nodes in the graph, each carrying the dependencies needed to
  compute its `body`. `body` is the node's capability, the one thing
  the node can do. It is a transformation, input data in and child
  nodes out, computed on demand and discarded. The runtime is what
  uses it. The runtime calls `body` when an input changes, and nothing
  else does.
- **The struct has no lifecycle.** The runtime retains the network, the
  identity slots holding lifetime metadata and any `@State`, and not the
  nodes. Node values are created and discarded each wave. Identity is
  structural, type and position among siblings, unless `.id()` overrides
  it. Flipping an `if` is a teardown, not an update.
- **Lifecycle is an effect of the graph, not of creation.** The struct
  is a value that describes a node. It is not the view on screen, and
  taking the one for the other is the object habit. The system is
  reactive. State changes, the graph recomputes its values, and
  appearance, disappearance, and `.task` are what the runtime does as a
  result. So nothing that creates a value starts work, not an `init`
  and not `body`, and a closure the root builds starts no `Task` that
  nobody holds when it is called. A value is created every wave and
  creating it causes nothing.
- **Creation builds nothing that has a lifetime.** A class instance has
  a lifetime. It is made once and it stays, and the struct is made
  every wave, so a view's `init` that builds a model object builds one
  every wave. A `Query` built there is built again the same way. What
  has a lifetime is built in one of four places. The handler of an
  event builds it. The root builds it. The runtime builds it, once, as
  the initial value of a private `@State`, when the slot is
  established. The `App` struct is a value like any view struct. Its
  `init` is creation too, and what lives as long as the app is the
  initial value of a private `@State` of the `App` or of a dynamic
  property it declares. A Memo builds it, at its first `body` and again when a
  dependency changes. The `@State` macro defers the initial value of a
  private `@State`, which avoids an allocation at every creation. It
  does not make creation the start of a lifetime, and state that takes
  its first value from an argument of the view's `init` belongs to the
  node that supplies the argument.
- **The action starts the work, not the view on screen.** Work is
  started by the action that causes it, as a task the node holds. The
  view on screen is the one thing here with a lifecycle. It appears and
  it goes, and that lifecycle is the runtime's and not the app's.
  `.task`, `.task(id:)`, and `.onAppear` hang work on its appearance.
  The view on screen appears again when a screen pushed over it is
  popped or the user comes back from another tab, and that work runs
  again. So when the action that put a node in the graph can be
  determined, a tap that presents or pushes it, what the node needs is
  done in that action and nowhere else, by the node that handles the
  action. What is loaded and what is loading is state a node holds and
  decides. It is not left to the lifecycle of the view on screen. When
  no action put the node there, as for the first screen at launch, the
  work is the app's own start, and it is started at the app level. The
  easiest means is used there, a `.task` on the node above the stack
  and the tabs. Nothing above that node removes
  it and puts it back, so its `.task` runs once. The forms are in the
  cut section below and in the do-not "A lifecycle modifier starting
  work an action causes".
- **Two kinds of node.** A view is a persisted node, and it is the
  runtime's. The runtime keeps its identity slot and its state across
  waves, re-creates the value each wave over that slot, and calls its
  capability, `body`. A transformer is a transformative node, and it is
  ours. The runtime does not know it and keeps no slot for it. It is
  pure flow, references in, bindings and labels out, created in the
  wave and gone with it. Its capability is not fixed by a protocol the
  way `body` is. It is what its consumer needs, the intercepted
  bindings, the labels, a `judge()`, and the consumer is our own code,
  a view's `body`. That is what swift-core-flow's `@Capability` is for.
  It declares a transformer's capability as one tuple, `capability`,
  which is to a transformer what `body` is to a view. State lives in
  the first kind, rules in the second. A transformer has no state, so its
  methods make no object, and its plain test is data in and data out,
  like any calculation; the node's log stays the test of the node.
- **Dependencies are recorded by access.** A wrapper read during `body`
  registers its storage against that slot. A write to registered
  storage invalidates the slots that depend on it, and the runtime
  re-runs those transformations and no others. A read of a static, a
  global, or a property of a plain class registers nothing, so the
  node does not follow it. A read of an observed property registers
  the `body` that is running, an `init` it calls included, so nothing
  a `body` runs writes an observed property it also reads. From its
  second run on, each run would invalidate the next.
- **A boundary event re-enters the flow only if it changes a source of
  truth**, storage some node reads. A binding write whose setter chain
  ends in storage changes one, and the next wave follows. A
  fire-and-forget request is a boundary event too, and it logs, but it
  changes none. The loop closes through storage and re-creation, not
  through a backward edge. Which screen shows is a projection of that
  storage, `if token == nil { Login() }`, not a route pushed from the
  place the token was cleared.
- **Wrappers divide in three.** Sources of truth (`@State`,
  `@AppStorage`, `@SceneStorage`) hold a plain value the node owns.
  References (`@Binding`, `@Environment`, `@Query`) hold nothing. A
  binding is a `get`/`set` pair an ancestor built and handed in at the
  initializer. An environment value is one an ancestor set above with
  `.environment(...)`. A query is a filtered read of the store the root
  opened. All three are data in. UI-runtime machinery (`@GestureState`, `@FocusState`,
  `@Namespace`, `@ScaledMetric`) holds nothing a caller could supply.
  All three groups resolve only inside a `View`, `App`, `Scene`,
  `ViewModifier`, or another `DynamicProperty`. The one exception is
  `@Binding`, a plain `get`/`set` pair that works in any struct, a
  transformer included. Inside a class the others are not installed,
  and nothing there drives a wave.
- **A binding is an interception point.** `$state` is the simplest
  binding, a setter that only stores. Any other setter is the
  ancestor's decision about what the write means, and an effect rides
  it: `set: { token = $0; if $0 == nil { keychain.clear(); refresh?.cancel() } }`,
  where `keychain` is a contract the root read and `refresh` a task the
  root owns. The logging binding in a test is the same pair with a
  different `set`. A binding is not a handle on a stored value. It is
  the one place a write can be intercepted, and it need not end in
  storage at all. A field's rule is its ordinary case: the setter
  stores the text and writes the error, and the field shows both.
- **A binding is handed where the receiver writes.** A binding is for
  mutating. What a node only reads it is handed as a fact, a `let` or
  a value read from the environment, and it is computed again when the
  fact changes. Before a binding is handed down, name the write the
  receiver makes through it. Where there is none, a fact is handed. A
  value the system reports, a tapped notification, is written by
  nothing in the app, so no node is handed a binding to it.
- **Classes sit outside the graph.** Put a screen's state in an
  `@Observable` or `ObservableObject` and the runtime no longer owns it.
  The object can be aliased, can outlive the node, and any holder can
  write around the node's boundary. An `@Observable` model is fine as
  data, a row the node reads. It breaks the model the moment it owns a
  screen's state and actions.

Every MV\*\* pattern the community reached for was solving a problem the
wrong mental model created. The view is the reducer. Each state
transition lives in the node that owns the storage, next to the UI that
triggers it. Mechanics, identity in collections, a value built from an
input, feedback cascades and their fixes are in
`references/data-flow.md`.

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
            ForEach(books, id: \.id) { book in
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
to reach for, so every dependency is named at an initializer or at an
`@Environment` read, or it cannot be used.

- **What did not happen: injection.** Injection, in the object sense,
  implies a stored reference to a stateful service, a lifetime the
  consumer manages. A view stores closures, but it is an ephemeral
  value with no lifetime and nowhere to inject into. The object world
  takes the view for a physical thing, one that exists and waits,
  which is why it injects a ViewModel into it. In a reactive system
  there is no such thing. What is called a view is only called one. It
  is a value, recomputed and composed when it is needed, from
  dependencies that are themselves flowing. Dependencies flow, like
  everything else. Data at the boundary is dependency rejection:
  values in, values out. Closures at the boundary are dependency
  parameterization: behavior handed in as a function. Neither is
  injection. A dependency's one public function is still named
  `inject`, the word a reader knows, and what it does is set a value
  into the flow at the root.
- **Where a closure enters, and where a write goes.** A closure the
  parent decides is an initializer argument: `onDelete`. A capability
  the app provides whoever the parent is a contract, set at the root
  and read from the environment: the store, the network, navigation. If
  every parent would hand the same closure, it is a contract. A service
  is one even when a single feature calls it. Sharing is not the test;
  who provides it is. A write to state an ancestor owns is a binding
  write, whatever its setter does with it. A write that leaves the tree is a closure call.
- **An edge case is a constructor argument**, or a driven sequence of
  them. The empty shelf is `books: []`. The error is a value handed in.
  The slow network has no duration when the core is handed the result.
  A core that awaits the load stubs the delay. Those are the previews,
  too.
- **Slices want structural types.** A node is coupled to whatever type
  its parameters name, so pass the fields a view reads, not the whole
  model. When a slice must travel as one value, a labelled tuple is its
  fields with no name to mint. Reach for a struct the moment the slice
  needs a protocol, `Hashable` for a navigation value, say. A `ForEach`
  is not that moment; `id: \.id` names the key at the call site.
  Behavior bundles the same way. `(save: (Book) -> Void, delete: (Book) -> Void)`
  grants two verbs, and the consumer has nothing else to couple to.
- **The price is plumbing you can see**, parameters threading through
  views that do not read them, instead of coupling you cannot see. Over a
  stateless middle, relocating a source of truth is an initializer
  refactor, and the compiler lists every site.

## Cut: shell and core

Every rule in this skill is there so that the code follows one
principle, functional core, imperative shell. The core decides, as a
function of what it was handed. The shell is everything that touches
the runtime's storage or the world outside the app. The line SwiftUI
offers is I/O versus pure transformation, not UI versus logic. A view with live wrappers is the shell. `@State` installs
real storage on render, `@Query` talks to a real `ModelContext`,
`@AppStorage` reads `UserDefaults`. That I/O is fused into the type and
runs only inside a live render pipeline. The core is the same `body`
against data at the boundary. Three rules cut it:

1. **Plain fields go to the core.** They are already data.
2. **Data-holding wrappers become boundaries.** `@SceneStorage` becomes
   `@Binding`; `@AppStorage` is the root's and not in a feature, so
   the cut does not meet it. `@Query` becomes a plain `let` array. `@State` stays. By hand, state a test must reach moves up and
   enters as `@Binding`; under `@Shell` it stays private and logs.
3. **Machinery stays in the shell, in the by-hand cut.** The shell owns
   the gestures, the focus, and the namespaces, and hands the core plain
   values. `@Shell` copies it into the generated core as a test wrapper
   instead, live when hosted, defaulted otherwise. A system UI that runs
   out of process, the photo picker, the share sheet, is machinery too.
   The shell owns it and hands the core its result as a value. Loading
   what the user picked, the photo's bytes, is I/O. It is an `async`
   closure on a contract the node calls, not a call inside furniture
   that no label shows. The
   environment is not machinery. A core reads it as it reads a binding.
   Apple's sealed actions are the by-hand exception in the table below.

Two ways to make the cut, one contract:

| | By hand | With `@Shell` (swift-core-flow) |
|---|---|---|
| The core | a second view, `BookListCore`, constructed by the shell's one-line `body` | a nested `Core` twin the macro generates. Same `body` text, copied by the compiler, so it cannot drift |
| Own `@State` | stays if only the core needs it; lifted to `@Binding` if a criterion names it | stays private as `@TestState` and logs every write. The write site emits the evidence |
| External storage, fetched data | `@Binding`, `let` | `@Binding`, `@QueryResult` (tests pass the bare array) |
| Machinery | shell. When the core must write focus, the shell hands it a binding built over its `@FocusState` | copied verbatim: live when hosted, defaulted otherwise. `@FocusState` becomes `@TestFocusState` and logs |
| Environment values, your own `@Entry` and Apple's plain ones, `\.locale`, `\.colorScheme` | the core reads them. The scenario sets them with `.environment(...)` | copied verbatim. The scenario sets them with `.environment(...)` |
| Apple's sealed actions, `\.dismiss`, `\.openURL` | the shell reads them and hands the core a closure, because nothing can build one from above | `@TestEnvironment`: the real action runs, every call logs |

By hand, the shell and the core are two types in two files. A screen
is named `…Screen`, a reusable view by its role, `Row`, `Sheet`,
`Style`.

**Screen first.** A core is modeled directly from the screen, the
Figma frame or the manager's sentence, before anything that feeds it
exists. This is building top-down inside one node, the contract before
what fulfils it. One property per thing the screen shows or accepts, the one
SwiftUI's own control asks for.

| On the screen | Core property |
|---|---|
| text, image, badge | `let title: String` |
| something sometimes there, a spinner, an error label, an empty state | the value that decides it, `let isLoading: Bool`, `let streetError: String?` |
| a list | `let books: [Book]` |
| text field, toggle, picker, slider | `@Binding var street: String` |
| button, swipe action, row tap | `let onSave: () -> Void` |
| pull to refresh | `let onRefresh: () async -> Void` |

Two checks. Every property is something you can point at on the
screen, so nothing is invented. Two screenshots that differ differ in
an init argument, so nothing is hidden and every state of the screen
is a construction from literals.

What the design says about the screen is the core's own rule, and it is
written in the core as it was said. Where a design says "if there is
an error, the field turns red and Save is disabled", that is a branch
on `streetError` and a `canSave` computed from the errors, and a
scenario that hands in an error proves it. Where another design leaves
Save enabled and has it do nothing, the core has no `canSave`. The
sentence is an example of a design, not a rule of the method, and
the core follows the design it was given. Whether there is an error is
decided above, and the core does not know how.

Then each property gets one source in the view above. A `let` comes
from a parent's value, a `@Query`, or state. A `@Binding` comes from
`$state`, a parent's binding, or a transformer's intercepted binding
where the write is judged. A closure comes from a parent's callback, a
contract, or a closure that assembles and forwards. The view above
owns and wires. Where nothing is judged on a write there is no
transformer. The screen's view owns no live wrapper, so it is a core
as written and is not cut. The view above is a shell written by
hand, or a `@Shell` where its writes are to log. That choice is made
per view (`references/shell-core.md`, "When to split"). The three
pieces as code are "Worked example, screen first" in the same file.

This is modeling one screen, not building a system. A SwiftUI screen
is cheap to write, so nothing is saved by sharing one, and it is read
like a book, top to bottom, each line a thing on the screen. The core
is written for this screen, with this screen's names. No generic form,
no field descriptor, no `Validator<T>`, no core shared by two screens
because they look alike today.

Either way, what reaches a core is a value. A model context, a session,
a socket, a token refresher: a service that holds state is wrapped in
closures at the root before it is set, and the core reads the closures.
And there is one shell wherever the I/O is, not one per view. A view
made only of `let`s, bindings, environment reads, and closures is
already a core, and gets no shell. Shells and cores cascade, a core's
child a shell with its own core, each node tested alone, the
composition holding because every edge is data. The composition root is
not cut either. It owns the app's state, hands it down as bindings,
sets the live values, and has no scenario; its one child is the first
core. No node starts a `Task` it does not hold. Work an event starts, a
tap, is assigned to an `@UnstructuredTask` slot under the library, a
slot that logs like state and whose entry the block declares. The
assignment is a write the node makes at a moment the node chooses, so
the node controls the work and a test reads it. `.task` and
`.task(id:)` are the runtime's events, hung on the view on screen, and
the runtime holds the task and cancels it. Appearance starts the work,
disappearance cancels it, a reappearance starts it again, and the node
decides none of the three. So they are not where a node's work is
started. Work a node needs when it is mounted is started by the action
that mounts it, in the node that handles the action, as a task that
node holds, and the result is state that node owns and hands down. A
refetch when a value changes is started by the write of the value. The
owner of the value hands down a binding whose setter stores the value
and assigns the fetch to a slot the owner holds. `.task` is what is
left when no action mounted the node, the first screen at launch, and
it hangs on the node above the stack and the tabs, which does not
leave. That is the app level, and the rule against the lifecycle of
the view on screen is about views that appear again. A first screen
that reads its list with `@Query` has nothing to load and carries
none. `.task(id:)` is used only when its id is a value
the app's code does not control, one the system supplies, and then in
the one modifier at the root that forwards the change into a flow, not
in a feature. A value the app writes has an action behind it, the
write. The app knows the value changed at the moment it writes it, so
it has no use for the UI runtime to notice the change and drive what
follows. A subscription sits in a node whose lifetime covers every
moment its events must be handled, not where the contract's value is
built. One that lasts for the life of the app is the root's and starts
in its `.task`, since launch is not an action. One that a mounted node
needs is started by the action that mounts the node and assigned to a
slot the node that handles the action holds. Whatever ends the need for
it clears the slot. A dismissal does, and it is caught in the binding
that presents the node, since a dismissal the runtime makes is a write
through that binding. An event the node hears does too, the app leaving
the foreground.

A closure of any signature is a behavior, sync or async, pure or not.
The node calls it and does not care what it does. For mocking, what a
core consumes falls into three shapes, and the shape says how it flows
in and how a test stands in for it:

| Shape | What it is | Flows in as | In a test |
|---|---|---|---|
| input | a fact the core reads | a `let` (a fetch result), a `@Binding`, an environment value | hand it data: a constant binding, a stubbed array |
| black hole | a sink the core gives data to and forgets | a closure: `save(model)`, `haptic()`, analytics | a spy: assert it was called, with the right payload |
| async effect that can fail | a result the core awaits but does not implement | an `async throws` closure: `try await load()` | a stub per edge case (a value, an error, a delay), one test each |

The core's need decides the shape. Awaited, it is an async effect.
Fired and forgotten, a black hole. The same `save` can be either.
`async` is the I/O marker for what the core awaits. A black hole is
synchronous because the core does not await it. The root's closure
starts no `Task` for it. Creation is not lifecycle. The root builds
values and sets them, and that is all a closure set there does when it
is called, a plain call into the service. Work is started by a node,
by a task the node holds when an action is the trigger, which is the
default, or by `.task` when no action can be determined and the
runtime's lifecycle is all there is. A closure whose work is asynchronous
is `async`, and the node that calls it owns the task it runs in. An
`async` or `throws` closure announces a boundary
that belongs behind a contract. Pure logic is synchronous and
non-throwing, and needing `async` in it means the code is in the wrong
layer. `grep async` finds every awaited boundary. The wrapper table, the worked
examples, and who owns the loading flow are in
`references/shell-core.md`.

## Test: read the execution log

How would Apple test `Button`? Its contract is "a physical tap calls
the action closure", and there is nothing else to inspect. Hand it an
action that logs, tap it for real, check the log: `["action"]`. Every
core has `Button`'s shape. Mock each boundary with a logger, drive the
core, and assert the execution log, the ordered `(name, value)` record
of its boundary events, every write and every call with its payload. An
entry is the boundary's own name, not the contract's, a space, then the
arguments in order, each written as the criterion names it: `isLoading
true`, `onDelete Dune` (a `Book`, by its title), `token nil`, `load`,
`dismiss`, `setStarred Dune true`. The name is `setStarred`, not
`favorites.setStarred`. That is the hand-written logger's spelling.
Under swift-core-flow no logger is written by hand. A boundary's
closure is a `@TestAction`, a contract's closure included, and the log
is two arrays, names and values. The names are the contract, asserted
whole and in order. The sequence is what the test proves, and the
values matter less. A value is asserted where the test's author can
read it, an optional unwrapped, a string, a number. A `@Model` logs as
its type name, so its entry is asserted by its name alone, and that is
enough. The log is not a reason to change a signature, so a contract
takes the model the node has, not its id because the id reads better.
The evidence block is the same either way.

- **Mocking is construction.** A boundary is a value, so the mock is a
  value, one wrapper deep. There is no mock object and no mock class to
  write, and no protocol kept so that one could be. A logging binding records the name and the
  new value before storing. A logging closure records its payload and
  forwards nowhere. A contract's no-op default already stubs all three
  shapes, and a scenario overrides every closure the node's label names. A scenario
  sets loggers for the node's own label lines and drives the node, no
  deeper; a child calling a logged contract would land in the same log.
  A child with a live wrapper is handed its runtime, `.modelContainer`
  or `.mockQuery`.
- **The test is the hosted scenario.** A scenario is a view that owns
  real `@State`, hands the core logged bindings and closures, sets its
  contracts with `.environment(...)`, and is driven with real input in
  a UI test. A `System` stimulus is the scenario's to produce, a
  control that feeds the stream or flips the value the system would.
  Where the system's event arrives through a modifier, the control
  calls a flow (the do-not "A modifier fed by the external system").
  The real runtime runs: identity, environment, `@State`,
  `.task`. Whether an action is a method or an inline call does not
  matter; the input fires it. Constructing a core in a unit bundle and
  calling a method sees only the `@Entry` defaults, because
  `@Environment` resolves only inside a render pipeline, and proves
  almost nothing. It is not the method's test. That is about a core. A
  pure calculation, a balance or a split, is data in and data out and
  gets a plain test with literals; so does a transformer of bindings,
  driven by bindings over local variables. A sort or a filter the store can
  perform is the query's job, in the shell's `QueryView`, proven at the
  shell with a seeded in-memory container, an integration test of the
  query the node wrote; the hosted scenario still proves the core
  reacts to the sort state.
- **A test proves what the app wrote, not what Apple's framework
  promises.** That a saved model is on disk after the app is closed and
  opened again, that the context saves on its own, and that `@Query`
  fetches again after a write are SwiftData's behavior, behind the
  boundary, and no test is written for them. A criterion the framework
  meets on its own, an address still in the list after a relaunch, is
  met by choosing the store and has no test. The app's use of the
  framework is the app's and is tested. The sort a query asks for is
  the node's choice, so the seeded in-memory container proves it. A
  dependency over SwiftData is tested in memory too. Its test proves
  that its insert and its delete did their job, the row fetched back
  after the one and gone after the other, however short that code is.
  The test reads the context directly, with a fetch, not through
  `@Query`, so it needs no view and no host. It does not open a store
  on disk.
- **A UI test here is a unit test, the unit being one core.** A second,
  test-only `@main` renders one scenario named at launch and nothing
  else of the app. A core has its scenarios. Supplied data is a
  parameter of one, a stub that answers differently is another
  scenario, and a scenario is also the preview and the launch target. Where a
  hand-written core sits under a shell that carries `@Shell`, the
  scenario is owed to the shell's generated `Core`, the one the
  evidence blocks are proven on, and it drives the hand-written core
  through it. The hand-written core gets a scenario of its own only
  when a block is declared on it. A core can also be previewed
  directly, constructed with literals. A view that owns state or reads
  a live wrapper, a shell, is previewed only through a scenario. A
  given that would have to set the node's own state says the truth is
  above the node: it arrives as a binding, and the state is not the
  node's. State that the node's own action writes is not such a given.
  The scenario reaches it by driving that action, a tap that opens the
  screen before the event under test, and the driven prefix is part of
  the log. A scenario is cheap, so a different given is another
  scenario, or another parameter on the same one, the scenario's own
  `@TestState` set to that value and handed down. The host is the
  swift-core-flow skill's.
- **Effects log, getters don't.** Writes and calls fire once per event.
  Reads fire on the render scheduler's timing. Do not log from a `get`.
  Under `@Shell` every private `@State` of the core logs, so a draft no
  criterion names lives in a furniture view below the core; the
  placement declares that keystrokes are not the node's evidence, and
  what the core owns is what its blocks declare. What moves below the
  core is storage a criterion does not name, not a rule. A rule runs
  above the view that shows its result, in the setter of the binding
  handed down. A form's node owns one `String` per field and one
  `String?` error per field, loose state, not a model as its draft;
  loose state composes, since any field can be handed anywhere as a
  binding, and the model is assembled only when Save hands it on. The
  node intercepts each field's binding to store the text and write
  that field's error, stored and not derived so that the judgment is an
  event in the log, and the fields view is the core read off the
  screen, bindings and labels. It decides nothing about whether a field
  is wrong, and what the screen does with an error it was handed is its
  own rule. The errors are not gathered into a struct;
  four fields are four errors, each beside its field. The interception is one value, a transformer, the transformative
  kind of node: a struct whose stored properties are `@Binding`s, the
  node's raw fields and their errors, and whose outputs are the
  intercepted field bindings and the labels. It holds no state and composes, one transformer's output binding
  being the next one's input, so a plain test constructs it over local
  variables, writes through an output binding, and reads the error
  back, no view runtime. A write of the value already held changes no
  source of truth, so the interception drops it whole, before the rule
  runs, and the system's focus and blur writes neither store nor judge;
  an error too is written only when it changes. Under swift-core-flow its
  outputs are one tuple, `@Capability` (the library's skill).
- **Test the action, not the aftermath.** The test proves an action
  executed with the right input, the closure called with the expected
  model or the binding written, plus the state the event leaves behind,
  through every await the node itself performs. It does not assert that
  the result later appears on screen. That is a different
  view tree, and the assertion would be testing SwiftUI.
- **Assert the order the criterion names.** Where two entries are
  interchangeable the test sorts them into one fixed order before
  comparing, duplicates kept, and the block shows that order. Silence is evidence
  too. No `books` entry means the failure wrote nothing.
- **Mock depth is one, permanently.** What the real `fetch` does with a
  304 is a separate question with a separate test, one per boundary, in
  the dependency's own test target, written once. Refactor the core and the log cannot change.
  Only a changed requirement can. That is why the log is the contract.

Scenarios, the host, transports across the UI-test process
boundary, and the hosted test in swift-core-flow are in
`references/testing.md`.

## Layer: the data coupling layer

Constantine ranked the ways two modules can depend on each other, and
data coupling is the weakest kind: they share values and nothing else,
no object, no protocol, no container. This method builds the whole app
on that one kind. Features do not import each other and do not import
I/O. The app imports everything. What they all share is one package of
pure data, the data coupling layer, `DataCoupling`, its own package
that depends on nothing of yours. Where swift-core-flow is used the
layer depends on it and re-exports it, `@_exported import CoreFlow`,
and the features package re-exports the layer the same way, so every
feature file sees the layer and the macros and imports neither by
name. The features package depends on it.
A dependency, the live side of a contract, a backend, a store,
depends on it too, to implement what the contract asks, and does not see
a feature. The app depends on all of them, owns the state, and sets
the live values by applying each dependency's one modifier in a chain
at the root. On disk that is `Packages/DataCoupling`,
`Packages/Features`, `Packages/Dependencies/<Name>` for each
dependency, and the app target beside them. This is dependency
inversion carried out. A protocol that sits in the module of its
implementation inverts nothing, since importing it imports the
module. The contract here sits in a package of pure data, and the two
sides cannot see each other. A feature is written against the layer alone, so it is
constructible from literals of its types and tested without the rest
of the app existing. The composition root constructs the live values,
the features consume them, and the two meet nowhere but in this
package. Diagram 2 on the map draws it.

What it holds, by folder:

- `Models/`. The app's records, SwiftData `@Model` classes or structs,
  stored `var` properties with defaults and a public initializer, so
  `.init()` is the empty one. What a brief says is kept on the device
  is SwiftData unless the brief says otherwise, `@Model` records read
  where they are shown by `@Query` and written through the store
  contract.
- `Values/`. What a feature computes and shows: a balance, a debt, a
  scan result. Plain structs of stored properties. They live here even
  when one screen is the only reader, because they are data of the
  app; what stays out is a helper that is not data. A field's error is
  not a value of the app: it is a `String?` beside its field.
- `Enums/`. The app's closed sets: a category, a payment method, an
  appearance.
- `Services/`. The contracts: one struct of closures per boundary, the
  store, the backend, the scanner, notifications, each with its
  `@Entry` no-op default. The backend's operations are closures here
  too, and the models they take and return are in `Models/`, the
  generated ones included. The backend package holds the wiring, the
  transport, the decoder, and what the root hands it, a base URL, a
  binding to the token.
- The settings, a contract in `Services/`. The root's `@AppStorage`
  keys as one struct of bindings, so no feature names a key.

What it does not hold: a method written by hand, a computed property, an `import` of an
I/O framework taken for its behavior, a conformance that needs behavior, or a screen's helper that
is not data of the app, a sort option, a sheet enum. What a generator
or a macro writes is not written by hand and is taken as it is. A contract may
take a system type the screen hands it, a `PhotosPickerItem`, and the
layer then imports that framework for the type alone. It does import SwiftUI, for
`Binding`, `EnvironmentValues`, and `@Entry`; those are types, and
nothing in the layer ever enters the render runtime. Seeing is not
dependency; using is. An import sees. The rule against UI imports in a
data layer is an object-oriented reflex, not this method's. Behavior lives in the features
as pure extensions and in the root as live closures. The layer has no
tests, since it has no behavior to be wrong about; the compiler is its
test. Data is the abstraction.

- **Every dependency has two parts, how it is constructed and how it
  is used.** Construction is the app's knowledge. The root knows what
  the dependency is built from and supplies those inputs, and the code
  that builds it may use anything in the layer. How it is used is its
  capabilities, the contract's members, and they are all a feature
  sees, read from the contract's environment entry. The settings are
  constructed from the root's `@AppStorage` properties, and their
  capabilities are a struct of bindings. A backend may need a binding
  to the token to be constructed, and its capabilities are a struct of
  closures. No dependency is a special case. Each one follows this
  same principle, Robert Martin's dependency inversion.
  `references/modules.md` shows both parts in code.
- **No information is lost where a value enters the app.** This is
  the first principle of the data flow. The code at a boundary keeps
  or forwards what the system or a service handed it, the whole
  response, the whole URL, and not one field picked out of it.
  Narrowing is a projection made afterwards, where the whole value is
  still held, by the modifier that builds a contract's member from it
  or by the node that hands a fact down. A feature still receives only
  what it uses. When another node needs another part, the part is
  there to project.
- **A contract is a struct of closures, lets, or bindings** with a
  defaulted initializer, and its `@Entry` default is the minimal no-op,
  `.init()`. A single value the root supplies, the date, is a contract
  of one `let`, so the label reads `clock.today`. The `@Entry` belongs to the layer, beside the contract it
  defaults. An environment value is data flow: set at the root,
  replaced by a scenario, read by a core. A closure in the environment
  is fine. It cannot be compared, so setting a contract again
  invalidates the nodes that read it, and a contract is set high in
  the tree, at the root, where that is rare. The nodes that consume it dictate its signature, not the
  implementation that will satisfy it. No protocols, no classes, no
  reference-type service objects. A protocol wins only for Objective-C
  interop, a plugin API external callers must implement, or a
  ten-method API with shared default behavior.
- **A type in the layer takes a name SwiftUI, Foundation, and the
  standard library do not have.** A feature file sees the layer and
  all three, and a name shared with one of them is ambiguous where the
  file writes it as a type, `private var settings: Settings`, and does
  not compile. `Label` and `Settings` are SwiftUI's, the second on the
  Mac, where the packages also build to run the plain tests.
  `Calendar` is Foundation's and `Clock` is the standard library's. A
  node's own name is not at risk, since a node is constructed,
  `Settings()`, and a call resolves by its arguments.
- **Networking is not a concept of the app.** The backend enters as a
  struct of async closures, one per operation, and the signature is the
  whole contract. Where the server publishes an OpenAPI document, the
  struct and its models are generated from it and live in the layer,
  and there the document states the signatures. A contract typed by
  hand would be a second copy of that document with nothing holding
  the two together. Above the root nothing names a session, a request, a
  status code, a header, or a decoder. Transport, decoding, retries,
  caching, and auth are closures composed at the root around one seam,
  not a subsystem a node can see. What answers the closures is the
  root's decision, a server, a folder of fixtures, a recording. A root
  that sets fixtures is a complete app with no server, and no screen
  can tell. The contract exists before anything implements it, so a
  feature is built and tested against the struct before a server
  answers. `grep URLSession` finds one file.
- **Data carries no behavior.** Models are stored `var` properties
  with defaults and a public initializer, so `.init()` is the empty
  one. A conformance that adds no behavior is fine on a model,
  `Identifiable` over a stored `id`, a synthesized `Codable`. Seeing a
  protocol couples nothing. What a model does not get is behavior, a
  method written by hand or a computed property, so a conformance
  that needs one is not declared on it. Computed members live as pure extensions in
  the feature layer. A class as data only when it earns it, for a lifecycle a struct
  cannot own, for `@Bindable` decomposition, or for per-element
  observation, and even then it stays pure data. A delegate a framework
  requires is a class too, private to the root modifier that owns it.
  It holds no state. It is handed a closure and calls it with the
  whole value the system gave, and the closure is a flow's. Where
  there is state to write, it holds a binding to state kept beside
  it, so the state and the behavior stay two things. No feature sees
  the class (`references/modules.md`). `deinit` is the one
  behavior allowed, and only to release what the object holds: cancel a
  task, stop a manager, tear down a subscription.
- **A dependency is a package under `Dependencies/`.** Every
  dependency that does I/O, a system framework, storage, the network,
  a device, is its own package in `Packages/Dependencies/`, however
  small. Size is not the test. Touching the outside world is. A
  dependency derived from contracts already set, a sync engine built
  on the backend and the store, is a package there too. It reads its
  ingredients from the environment by their types in the layer, so it
  imports no other dependency. A dependency imports the layer, platform
  frameworks, and the transport or SDK library it wraps, and nothing
  else of yours. It imports neither the features nor another
  dependency. The package boundary is what holds that. A modifier file
  in the app target sees whatever the app sees, a feature's enum, a
  feature's parser, and nothing stops it from using them. What a
  dependency needs from a feature is either data, which moves into the
  layer, or a rule, which stays in the feature behind the contract. A
  dependency exposes exactly one public thing, a `View` extension
  named `inject` and the dependency's own name, `injectBackend(baseURL:)`,
  `injectHaptics()`, over an internal modifier that builds the live
  value and sets it. The package is not named as the contract's
  type, since a module and a type of one name shadow each other, nor
  as the framework it wraps, `Photos`, since its import would then
  name itself. What the root supplies is that function's
  parameters. The one integration test of the boundary lives in the
  package's own test target. The tree, the manifests, and the project
  file are in `references/app-structure.md`.
- **The root sets live values inline, where it sets them.** One
  dependency per I/O framework the root wires, the framework imported
  in that package alone, each `inject` applied inline at `@main`. A modifier that reads a value
  another sets is written first, inside it, so the code reads the
  dependency column bottom-up. SwiftData's `@Model` and `@Query` are
  materialization and import it where they stand. No `.live`,
  `.preview`, or `.unimplemented` statics and no `+Live` files; they
  attach an implementation to the contract type and move the wiring
  away from the modifier that sets it. The default serves previews and
  tests, and a scenario builds the logger. A live closure that writes the root's own state closes over
  its binding, `$habits`, not over `self`. A live value over the model
  context comes from a modifier that reads `\.modelContext` inside the
  `.modelContainer(...)` scope and sets the contract there.
- **Every dependency points at data.** Features and I/O modules both
  depend on the layer and not on each other. The app depends on all of
  them. A stateless module is algorithms and cores, importable anywhere.
  The state sits at the top, in the app that composes the modules.
- **Seeing a capability couples nothing; consuming it does.** Apple
  exposes everything to every feature through the environment. The
  core's consumption is named at an initializer or at an `@Environment`
  read. A closure can only be called. A contract is not split for size.
  A struct of three hundred closures holds no state and no invariant,
  and a node that calls one is coupled to one signature. A smaller
  record sliced off for a feature is taste, not rescue.

The graph, the composition root, flow versus injection, the capability
shapes, and when a protocol wins are in `references/modules.md`.

## swift-core-flow

The cut and the log as macros, one dependency, adopted one view at a
time with nothing rewritten. `@Shell` generates the core, `@TestState`
and `@TestAction` log at the write site, `QueryView` and `@QueryResult`
make `@Query` an input, `MemoView` keeps a value derived from inputs
across renders, not `@State(wrappedValue:)` in an `init`, and
`HostApp` with `CoreFlowUITesting` hosts and asserts the scenario. The
rule-to-macro table, the install, and the order of work are the
library's own skill, `skill/SKILL.md` in
[sisoje/swift-core-flow](https://github.com/sisoje/swift-core-flow).

## Do not

The first group breaks the method. The second is how this code is
written, and the reader is the writer, so it binds too. Any rule in
this skill, in this list or anywhere above it, may be broken whenever
breaking it saves time or is the more practical thing to do.
Practicality outranks the rule. The one who breaks it says which rule
and why, where it is broken.

- **A ViewModel, or any `@Observable` or `ObservableObject` owning a
  screen's state and actions.** A node is already a transformation of
  its inputs to children. Pulling that out of it moves a
  transformation into an object and adds the object.
  `@StateObject` and `@ObservedObject` have no value-shaped boundary to
  substitute, which is why swift-core-flow leaves them unmapped.
  Renaming it a store, client, or manager and handing it in as a
  dependency changes nothing. A dependency with methods is still an
  object. An `@Observable` class holding only stored properties is
  data, set and read like any value; the methods make it the object.
  Erase the object into closures: networking as an async function, a
  validator as a value computed from the state, or as a plain closure
  when the app supplies the rule. Where each part of an existing one
  goes is the table in `references/converting.md`.
- **A dependency whose live value can be made with no inputs**, a
  formatter, a calendar, a pure calculation. It is a constant. Use it
  directly, not through the environment. I/O with no inputs, a file
  written to the temporary directory, is still a contract. The clock is
  not a constant to use directly either. The current date is a fact an
  ancestor owns and hands down, a `let` or an environment value, not a
  closure the node calls, so a scenario can fix it. A delay the node
  awaits is an async effect, a closure the scenario stubs to return at
  once or not at all. A repeating tick is a stream that a contract's
  closure returns. Its default finishes at once, and a scenario feeds
  it with a control. It is not a delay awaited in a loop, which spins
  on a no-op default.
- **`.onChange` on a value the app writes.** The app does not observe
  its own changes through the UI runtime. It knows who mutates what,
  so it intercepts the write where it is made, in the handler, or in
  the setter of the binding the value's owner hands down, and the
  reaction rides that write, a haptic when the selection changes, a
  sheet dismissed when a save returns. `.onChange` learns of the
  change a wave late and cannot tell who wrote it or why. A chain of
  them, where the second observes what the first wrote, is the worst
  form. One keystroke, three waves, and the transition lives in no
  node. Derive instead of store. Do the whole transition in one
  boundary event. `.onChange` is what is left for a value the app's
  code does not control, the scene phase, and it sits in one modifier
  at the root that forwards the change into a flow. Features handle
  the flow.
- **State seeded from an input.** Seeded means given a first value
  that is taken from an input, at creation, `_doubler =
  State(wrappedValue: Doubler(seed: seed))` in an `init`, or the same
  build made lazy, or on appearance, the same write in `.onAppear`.
  The `init` runs at every creation and builds each time, the slot
  keeps the first, and the node shows what was built from the first
  input from then on. The input is the parent's, so the kept copy is a
  second source of truth. Laziness removes the wasted builds and keeps
  the stale value. `.id(seed)`, and an `.onChange(of: seed)` that
  writes the copy again, are repairs. They keep the copy and have the
  runtime bring it back in step, and neither is used here for this.
  The requirement is that what is built from an input follows the
  input and is kept while the input does not change. The handler of
  the event that mounts the node, or of the one that changes the
  input, builds it in the parent, and the parent hands it down. State
  that an event writes is not seeded. The tap that opens an editor
  writes the field's first value into state the presenter owns. What a
  node is to hold when it first appears is written by the action that
  puts it in the graph, not by anything the node does on appearing.
  Where the built thing is the child's own detail, the child derives
  it, as a computed property, or with `MemoView` keyed by the input
  when the instance is to be kept. A binding to the input is not a
  third way. A binding shares a value and does not rebuild what was
  built from it. A `Query` built in a child's `init` is the same
  mistake with the other requirement failed. It follows the input and
  is built again at every creation, and `QueryView` replaces it. The
  two ways, the Memo's limits, the measurement, and a table of the
  common forms with what replaces each are in
  `references/data-flow.md`, "A value built from an input".
- **A `Task` nobody holds.** `Button("Save") { Task { try await save()
  } }` starts work that nothing cancels. It outlives the node, a second
  tap runs a second copy beside the first, and its writes land in a
  node that may be gone. An unstructured task is assigned, to an
  `@UnstructuredTask` slot of swift-core-flow or to a
  `Binding<Task<Success, Failure>?>` a parent backs with one. The slot
  cancels the previous task when a new one is assigned and the live one
  when the node is removed, writing `nil` cancels on demand, and each
  assignment logs. The task closure takes a capture list, `Task {
  [save] in ... }`, since capturing the view keeps the storage alive
  and defeats the cancel on removal. State the task writes is captured
  as its binding and written through it, `Task { [library, $books] in
  $books.wrappedValue = … }`. A call whose result the node does not
  await is a different thing. It is one closure call, it logs, and
  nobody starts a `Task` for it, the root's closure included.
  `.onAppear { Task { await load() } }` is the same `Task`, and it
  hangs the load on appearance besides, the entry below. A `Task { }`
  nobody holds inside a closure the root sets is lifecycle hidden in
  creation, the object habit of a service that runs itself. A task a
  dependency shares between its callers, a token refresh that
  concurrent calls join, is held like any other. It is assigned through
  a binding to a slot the root owns, and the root can cancel it. The
  map skill's `mapcheck.py --sources` warns on a `Task` that is not
  assigned.
- **A lifecycle modifier starting work an action causes.** `.task`,
  `.task(id:)`, and `.onAppear` hang work on the appearance of the
  view on screen. That view appears again when a screen pushed over it
  is popped or the user comes back from another tab, and the work runs
  again, a `.task(id:)` whose id did not change included. When the
  action that put the node in the graph can be determined, the work is
  done there and nowhere else. The node that handles the action
  assigns a task it holds, and what is loaded, what is loading, and
  what failed are state that node owns and hands down. The node that
  is mounted receives them as `let`s and has no `.task`. A counter or
  a flag stored only so that `.task(id:)` fires is state invented to
  reach the runtime's event. `.task` is what is left in two cases, the
  first screen at launch, which no action mounts, and a subscription
  the root holds for the life of the app. It hangs on a node that does
  not leave, the one above the stack and the tabs. Both are the app's
  own lifecycle, and at the app level the easiest means is used.
  `.task(id:)` is
  used only when its id is a value the app's code does not control.
  The method names no use for `.onAppear`. The map skill's
  `mapcheck.py --sources` warns on `.task(id:)`, `.onChange`,
  `.onAppear`, and `.onOpenURL` in a view, and leaves a plain `.task`
  and the root's forwarding modifier alone. The worked forms are in
  `references/shell-core.md`, "Who owns the load".
- **A modifier fed by the external system, inside a feature.** This is
  the shell and core cut again, for whatever reaches the app from
  outside it. The rule is general. When the event or the data behind a
  modifier comes from outside the app, the app hears it in one place,
  at the root, and hands it to the features as a flow. Recognize the
  case by the source and by nothing else. A `Button`'s closure runs on
  a tap in the app, and a write of the app's own state comes from the
  app's code. A link another app opens, an activity the system hands
  over, a value the system sets and changes, each has its source
  outside. `.onOpenURL`, `.onContinueUserActivity`, and an `.onChange`
  or a `.task(id:)` over the scene phase are examples and not the list.
  Whether a test could fake the source some other way does not enter
  into it. A node that carries such a modifier is a shell with handling
  inside it, and the app would be watching the system through the UI
  runtime in every node that cares. So make the core with a flow, in
  five steps. Declare the flow in the layer, in an `EnvironmentValues`
  extension where the `@Entry` values are, `@FlowUp var deeplink: (URL)
  -> Void`. Collect it at the root, `.collectFlow(\.deeplink)`. Keep
  the system's own modifier inside one `ViewModifier` at the root,
  applied before the collector so that it sits inside it, where its
  closure does one thing, `.onOpenURL { deeplink($0) }`. Write the
  handling as a node that listens, `.onFlow(\.deeplink) { url in … }`,
  the node that owns the state the handling writes. Give its scenario
  the same collector and a control below it that calls the flow. A link
  that launches the app reaches the listener too. Where the system
  delivers through a delegate and not a modifier, a tap on a
  notification, the same form holds. The delegate holds no state. The
  dependency's `inject` modifier keeps it in a private `@State` and
  hands it a closure in `body`, and the closure calls the flow. A
  modifier whose `body` returns `content` untouched does not run, so
  the modifier applies something, the dependency's contract. A tap
  that launches the app comes before the first screen and is not
  delivered in this form. An app that has to open on it keeps the
  response as data in a dynamic property the `App` declares, read in
  the `App`'s `body` (`references/modules.md`). The
  `App` is a
  node and is there from the first moment, so a tap that launches the
  app is a write of state like any other, and nothing waits for a
  screen to exist (`references/modules.md`). The system's value as a
  fact, a cover shown while the scene is inactive, is still data a node
  reads. The form with its code, the scenario included, is in
  `references/modules.md`.
- **Asserting the aftermath, or logging from a getter.** Both make a
  test assert the runtime's timing instead of the node's decisions.
- **Designing for the what-if.** "What if someone forgets to set the
  entry?" Then the no-op default runs and the preview shows it. The
  architecture does not protect itself from its authors.

The code, as it is written here:

- **Grouping for grouping's sake.** A `ViewState` umbrella, a data
  struct wrapped around a single view's properties, an errors struct
  gathering one `String?` per field, a helper that wraps a single-use
  sequence. Each is a jump the reader must make. Bundle by operation,
  not by screen. A `View` is already a struct, and a field's error
  belongs beside the field.
- **A model invented in a feature.** A model is a struct or an enum
  that groups facts, and it exists because the data layer already
  defines it, a `Decodable` the backend returns, a `@Model` the store
  keeps. A feature does not invent one. The reason is composability.
  A feature's state is loose fields, and loose fields are orthogonal.
  Each one changes without touching the others, so each is handed down
  as its own binding, animated on its own, and logged as its own
  write, and any subset of them composes into a child. A model couples
  its fields. Whoever needs one receives all of them. The object
  doctrine grouped state to guard it, and here there is no object to
  guard, since state lives outside the node that renders it. A struct
  around a view's fields is one invented model. `enum LoadState { case loading, failed(String), loaded([Book]) }`
  is another, written so that an "impossible" state cannot be
  represented. Loading, the error, and the result are three facts,
  `isLoading`, `error`, `books`. Fused, none can be handed down alone,
  and a refresh that keeps the old list on screen while it loads has
  no case. A binding into one case takes extra machinery, a case path,
  which exists only because the facts were fused. No state is impossible here. Every state is valid, and a
  combination the view does not show is a missing branch in `body`.
  Facts grouped today must be taken apart tomorrow, when one is needed
  somewhere the others are not. An enum that names one choice from a
  finite set is not a model. A sort option, which sheet is open, which
  of a fixed selection of components to show, each is one fact, and it
  stays in the feature. Such an enum can conform to `View` itself.
- **Several types in one file.** Most types get a file of their own,
  named for the type: a hand-written core, a shell, a transformer, a
  contract, a model, a root modifier. A hand-written core does not sit
  in its shell's file. A type is found by the name of its file. A
  scenario is a file of its own, named for the scenario, beside the
  view it stages. The `#Preview` lines are in the view's file, each
  naming a scenario, since Xcode's canvas shows the previews of the
  file that is open. Small private furniture that the view alone uses, a row,
  a label, stays in that file too. A generated `Core` has no file. The
  macro writes it.
- **Data-driving statically known content.** Three onboarding pages are
  three views, or an enum with an exhaustive `switch`, not a `[Page]`
  replayed through `ForEach` with `lastPage = 2`. What is fixed at
  compile time is written out.
- **A struct that only switches over an enum.** Any value can conform
  to `View`. An enum that renders itself conforms directly.
- **Generic implementations.** Most problems are static. Model each as
  the one case it is, screen by screen.
- **Trivial comments.** A comment says what the code cannot, the why,
  or it is not there.

## Vocabulary

The articles' terms. Use them. They make discussion precise in a way
"view", "update", and "re-render" do not.

| Term | Meaning |
|---|---|
| node, persisted | a view or view modifier: the runtime keeps its identity slot and state across waves, the value is created fresh each wave |
| network | the identity, position, and attached storage the runtime retains across waves |
| flow | data moving during a wave, down into inits or up through preference accumulation; every flow terminates in node creation or a source of truth |
| transformation | `body`, input data in, child nodes created |
| capability | what a node does with its inputs. A view's is `body`, fixed by the protocol and used by the runtime. A transformer's is its own, declared with `@Capability` and used by a view |
| wave | one pass of re-creation; the runtime re-runs the transformations whose inputs changed, and no others |
| source of truth | storage some node owns (`@State`, `@AppStorage`, `@SceneStorage`); changing one triggers the next wave |
| self-loop | `@State`, an edge to the node's own next creation, not to another node |
| node, transformative (transformer) | pure flow through it: a struct of `@Binding` inputs whose outputs are intercepted bindings and labels, created in the wave and gone with it, no slot, so it tests as a pure value |
| boundary event | a binding write or action call; re-enters the flow only if it changes a source of truth |
| reshaping | a wave that changes structure, not only values; the rare case |
| reference | `@Binding`, `@Environment`, or `@Query`: holds no state. A binding is a `get`/`set` pair an ancestor built and handed in at the initializer; an environment value is one an ancestor set above with `.environment(...)`; a query is a filtered read of the store the root opened |
| machinery | Apple's UI-runtime wrappers that hold no suppliable data (gestures, focus, namespaces, metrics) |
| shell / core | the view owning the live property wrappers and services, one wherever the I/O is / the feature as pure transformation, values and closures in, children and boundary events out |
| scenario | a test-host view owning real `@State`, handing down only logged boundaries |
| preview chain | the scenario that stages a view, a file of its own beside the view, and the `#Preview` in the view's file that shows it |
| execution log | the ordered `(name, value)` record of boundary events, every write and call with its payload; a core's behavior, as data |
| mock depth | how many levels of internals a mock must assume; transitive through an object graph, constant at one for a closure |
| wireframe you can type-check | the feature modeled against nothing: compiles, names every dependency, implements no behavior |
| dependency rejection | data at the boundary; the core has no dependencies, values in, values out (Seemann's term, via Wlaschin) |
| dependency parameterization | closures at the boundary; behavior handed in as a function (Wlaschin) |
| data coupling layer | the one shared module, free of behavior: models, closure signatures, and the `EnvironmentValues` entries that propagate them |
| the consumer is the test | a boundary's implementation is judged by the feature that consumes it |

## References

Each rule of this skill has an older name in the dataflow literature,
a process, a data store, essential state, a value over time and an
event, an output on the transition. `references/data-flow.md`, "The
rules under their older names", has them in one table with their
sources. Knowing that a rule holds is not understanding it. For why a
rule is the way it is, or to check whether it is right, read the
source its row names.

- Lazar Otasevic, [SwiftUI Data Flow Masterclass](https://medium.com/@redhotbits/swiftui-data-flow-masterclass-099f0768f776)
- Lazar Otasevic, [TDD Is Dead. Long Live TDD.](https://medium.com/@redhotbits/tdd-is-dead-long-live-tdd-f85b4b9eacbd)
- Lazar Otasevic, [TDD: Death by a Thousand Mocks](https://medium.com/@redhotbits/tdd-death-by-a-thousand-mocks-26adb60cbe43),
  why the axis is authority, and why mock depth is what TDD died of
- Lazar Otasevic, [swift-core-flow](https://github.com/sisoje/swift-core-flow),
  `@Shell`, `@TestState`, `@TestAction`, `QueryView`, `HostApp`
- Lazar Otasevic, *Don't Separate Networking From Your UI, Eliminate It
  From the App*, and [swift-declarative-openapi-generator](https://github.com/sisoje/swift-declarative-openapi-generator),
  the backend as a struct of async closures, and its models, written
  from the OpenAPI document the server publishes
- Edward Yourdon & Larry Constantine, *Structured Design* (1979), where
  the coupling taxonomy and the term "data coupling" come from
- Scott Wlaschin, [Six approaches to dependency injection](https://fsharpforfunandprofit.com/posts/dependencies/)
  and [Designing with capabilities](https://fsharpforfunandprofit.com/cap/)
- Mark Seemann, [Impureim sandwich](https://blog.ploeh.dk/2020/03/02/impureim-sandwich/)
- Gary Bernhardt, [Boundaries](https://www.destroyallsoftware.com/talks/boundaries)
- Apple, [Data Flow Through SwiftUI](https://developer.apple.com/videos/play/wwdc2019/226/)
  (WWDC19) and [Demystify SwiftUI](https://developer.apple.com/videos/play/wwdc2021/10022/)
  (WWDC21)
