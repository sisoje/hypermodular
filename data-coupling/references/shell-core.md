# Shell and core: cutting a view along the I/O line

Read this when a view has become hard to construct in a preview or a
test, when someone proposes a ViewModel "so we can test it", or when a
view mixes live runtime wrappers with the logic that decides things.

Sources: the masterclass (the cut by hand), the method article (lifting,
the shell, who owns the load), the swift-core-flow README (the cut as a
macro), and the three shapes of I/O after Wlaschin.

## The lineage

Gary Bernhardt, *Boundaries*. Scott Wlaschin, *Moving I/O to the edges
of your app: Functional Core, Imperative Shell*. Mark Seemann, *Impureim
sandwich*. All three say the same thing. Pure logic inside, I/O at the
edges.

A SwiftUI view with live property wrappers is the shell. `@State`
installs real storage on render. `@Query` talks to a real
`ModelContext`. `@AppStorage` reads `UserDefaults`. That I/O is fused
into the type, so it runs only inside a live render pipeline, never in
isolation. The line SwiftUI offers is I/O versus pure transformation,
not UI versus logic.

Seemann's sandwich (impure, pure, impure) is the split shaped as views.
The shell reads the sources of truth, the core decides as a pure
function of its inputs, and the handed-in closure does the write.

## First: classify the wrappers

Only data that can be set from above can be lifted out of a view.
Property wrappers divide in three, and the division is the cut line.

Sources of truth are `@State`, `@AppStorage`, and `@SceneStorage`. What
they hold is a plain value, and the node owns it. Data can move. It
can be handed in, captured, asserted on.

References are `@Binding`, `@Environment`, and `@Query`. None holds
state of its own. A binding is a `get`/`set` pair an ancestor built and
arrives at the initializer; an environment value is set above with
`.environment(...)` and read without a constructor argument; a query is
a filtered read of the store the root opened. Same kind, different
spelling. All are data in, and all belong in the core, the query as
the array it delivers.

UI-runtime machinery is `@GestureState`, `@FocusState`, `@Namespace`,
and `@ScaledMetric`. None hold data a caller could supply. There is no
`BookRow(gesture: .inProgress)` the way there is `BookRow(title:
"Dune")`.

So the rule for a core and the environment:

- A core reads the environment as it reads a binding. The value was set
  above and is replaced above. `.environment(...)` on the scenario is
  its mock, as a literal binding is a binding's. The environment is the
  right way for a capability to reach a feature. Seeing a value there
  couples nothing. Consuming it does, and the read names the
  consumption as an initializer argument would.
- What is set into the environment is a value: a contract struct of
  closures with its `@Entry` no-op, a `let`, a binding (`modules.md`).
  A service that holds state, `\.modelContext`, a session, a socket, a
  token refresher, is wrapped in closures at the root before it is set.
  No node reads the handle.
- Apple's sealed actions, `\.dismiss` and `\.openURL`, are the one
  wrinkle. They cannot be built from above, so by hand the shell reads
  them and hands the core a closure. `@Shell` logs them in place with
  `@TestEnvironment`.

| Wrapper | Class | Cut by hand | Cut with `@Shell` |
|---|---|---|---|
| plain `let` and `var` fields, closures | data | already in the core | copied verbatim |
| `@Binding` | reference | already in the core; passes straight through | copied verbatim; the caller supplies the binding |
| `@State` | data, owned | stays in the core if only the core needs it; `@Binding` if a criterion names it | `@TestState`: stays private, keeps its default, logs every write |
| `@SceneStorage` (`@AppStorage` is the root's and never in a feature) | data, external storage | shell keeps it; core takes `@Binding` | `@Binding`. The key disappears, because a twin does not persist |
| `@Query` | reference, a filtered read | shell keeps it; core takes a plain `let` array | `@QueryResult`. The memberwise init takes the bare array |
| `@FocusState` | machinery | shell | `@TestFocusState`: a real `FocusState` underneath, programmatic writes log |
| `@Environment` value, your own `@Entry` | reference | in the core; the scenario sets it with `.environment(...)` | copied verbatim; the scenario sets it with `.environment(...)` |
| `@Environment(\.dismiss)`, `(\.openURL)` | reference, sealed action | shell reads it and hands the core a closure, because nothing can build one from above | `@TestEnvironment`: the real action runs, every call logs |
| `@GestureState`, `@Namespace` | machinery | shell | copied verbatim: live when hosted, defaulted otherwise |
| `@ScaledMetric` | machinery | may stay in the core. It has a default and never blocks construction | copied verbatim |
| `@StateObject`, `@ObservedObject` | none | not in this architecture | unmapped on purpose: no value-shaped boundary to substitute |

## The three extraction rules

Extracting the core is a mechanical split into two views.

1. **Plain fields go to the core.** They are already data.
2. **Data-holding wrappers become boundaries.**
   - `@SceneStorage` becomes `@Binding`. External storage is a
     dependency, and whoever constructs the core supplies it.
     `@AppStorage` is the root's and never in a feature.
   - `@Query` becomes a plain `let` array. The fetched result is handed
     in as a value.
   - `@State` that only the core itself needs may stay in the core.
     `@State` a test must reach moves up to the shell and enters the
     core as `@Binding` too.
3. **Machinery stays in the shell.** The shell owns the gestures, the
   focus, and the namespaces, and passes the core plain values. The
   environment is not machinery. A core reads it as it reads a binding.
   Apple's sealed actions are the by-hand exception in the table above.

The shell keeps the live wrappers and a one-line `body` constructing the
core.

> The real `body` lives in the core, against boundaries that are data.
> There is no second copy to drift.

## Worked example, by hand

```swift
struct BookList: View {                    // shell: owns the I/O
    @Query private var books: [Book]                               // rule 2: fetch
    @Binding var sortByAuthor: Bool                                // rule 1: the root's storage, a binding
    let onDelete: (Book) -> Void                                   // rule 1: already data

    var body: some View {
        BookListCore(books: books, sortByAuthor: $sortByAuthor, onDelete: onDelete)
    }
}

struct BookListCore: View {                // core: data at the boundary
    let books: [Book]                      // fetched array, as a value
    @Binding var sortByAuthor: Bool        // passes straight through
    let onDelete: (Book) -> Void           // unchanged: a plain field all along

    var body: some View { ... }            // the one real body
}
```

Constructing the core takes no `ModelContainer` and no render loop, and
every edge case is a constructor argument:

```swift
#Preview("Two books") {
    BookListCore(books: [.dune, .anathem], sortByAuthor: .constant(false), onDelete: { _ in })
}

#Preview("Empty") {
    BookListCore(books: [], sortByAuthor: .constant(false), onDelete: { _ in })
}
```

Every visual variant is a one-line preview, and every behavior is an
assertion on the core's boundary events (`testing.md`).

## Worked example, with `@Shell`

`@Shell` is a member macro that generates a nested, always-internal
`Core`: the same `body`, helpers, methods, and nested types, copied by
the compiler. Stored properties follow two rules. Wrappers on the
mapping whitelist (the table above) are substituted with test
boundaries. Everything else is copied verbatim. Members written in a
separate extension are invisible to the macro, so a helper the core
needs must sit in the type body. `@Shell` requires Swift 6.4 (Xcode
27); earlier compilers make `Core`'s memberwise initializer private.

```swift
@Shell
struct Card: View {
    @Query private var items: [Item]
    @State private var isExpanded = false
    let title: String
    let action: (Item) -> Void

    var body: some View { ... }   // ordinary SwiftUI, written once

    // generates:
    // struct Core: View {
    //     @QueryResult var items: [Item]
    //     @TestState private var isExpanded = false
    //     let title: String
    //     let action: (Item) -> Void
    //     var body: some View { ... }   // the same text, copied
    // }
}

// #Preview cannot name macro-generated code, hence the wrapper.
// Its construction is also a unit test's entire setup.
struct CardScenario: View {
    @TestAction private var action: (Item) -> Void = { _ in }    // every call logs its payload

    var body: some View {
        Card.Core(items: [], title: "t", action: action)
    }
}

#Preview { CardScenario() }
```

Three terms keep fixed meanings. The host (`Card`) is the production
shell. `Core` is its generated twin. A scenario (`CardScenario`) is the
hand-written stage supplying `Core`'s test boundaries for a preview or a
UI test.

What the macro cut buys over the hand cut is that own `@State` stays
private and still logs. Moving that state up only to observe it would
falsify the component's data flow, so the write site emits the evidence
instead. Replacing external sources with supplied data also removes
their live event channels. Persistence changes and fetch notifications
cannot trigger a wave mid-test. `Core` is internal, ships no bytes in a
release build, and needs no `#if DEBUG`. Scenarios live in the app
target like every preview.

The mapped wrappers must be `private` on the host, and the macro
diagnoses anything else. They are the view's own source of truth, never
something a caller supplies. A plain `private` field with no wrapper is
a compile error, because pure data flow has no room for opaque state.

## What a core consumes: three shapes of I/O

A closure of any signature is a behavior. The core calls it and does
not care what it does. For mocking, every boundary a core touches falls
into one of three shapes, and naming the shape tells you how to hand it
in and how a test stands in for it.

| Shape | What it is | Flows in as | In a test |
|---|---|---|---|
| source of truth | input the core reads | a `let` (a fetch result), a `@Binding` (storage), an environment value | hand it data, a constant binding or a stubbed array. You are not testing whether the source works, only that the core reads and derives from it correctly |
| black hole | a sink the core gives data to and forgets | a closure: `save(model)`, `haptic()`, analytics | a spy. Assert it was called, with the right payload. Whether it persists or fires is the boundary's own test |
| async effect that can fail | a result the core awaits but does not implement | an `async throws` closure: `try await load()` | a stub per edge case (a value, an error, a delay), one test each. The result, error, and loading handling live in the core |

The core decides what to do. The boundary does the I/O. Pick any
screen. Its entire relationship to the outside world is a handful of
these, all visible in its property list. No hidden service locator, no
ambient singleton, nothing a comment has to remind you to register. A
contract's no-op default is all three shapes stubbed, and a test
overrides every closure the node's label names.

`async` is the I/O marker for what the core awaits. A black hole is
synchronous because the core does not await it; the root's closure may
start its own task. Effects belong in the type signature. A closure
typed `() async throws -> Void` reads as "async effect that can fail".
See `async` or `throws` in a signature and you are looking at a
boundary that belongs behind a contract, never inline in view logic.
Pure logic is synchronous and non-throwing, which is the proof that it
is pure. `grep async` finds every awaited boundary.

## The SwiftData shell

`@Query` is a source of truth whose configuration (filter, sort,
section) is itself sourced from other truth, yet it is locked in at
construction. Building it in a child's `init` off parent state
constructs a new query on every parent re-render. Apple DTS confirmed a
filtered `@Query` re-fetching once per keystroke in the parent. And
`.id(value)` on that child destroys the subtree's state whenever the
value changes. swift-core-flow's `QueryView` builds the live query in
`body` from the view's own state, rebuilds it only when `dependencies:`
change (the values that take part in the `Query` init, those and only
those), and hands content the result as plain data:

```swift
struct BookList: View {
    @Binding var sortDescending: Bool

    var body: some View {
        QueryView(
            query: Query(sort: \Book.title, order: sortDescending ? .reverse : .forward),
            dependencies: [sortDescending]
        ) { $books in
            List(books, id: \.id) { Text($0.title) }
        }
    }
}
```

Two mock paths. `.mockQuery(QueryResult(wrappedValue: [dune]))` cans
the result per type. Or seed an in-memory container and let the real
query run against test data, so sorting, filtering, and sectioning are
the query's own.

## Who owns the load

Even the loading flow (spinner on, fetch, spinner off, error or data)
is a rule the core can own. Whether it does, or a shell above it does,
is a choice per feature, not a default. Once the core owns the load,
the `let`s it produces turn writable, and the sequence becomes feature
logic, a method the `.task` calls:

```swift
struct LoadingShelf: View {
    @Binding var books: [Book]
    @Binding var isLoading: Bool
    @Binding var error: String?
    let load: () async throws -> [Book]

    var body: some View {
        List(books, id: \.id) { Text($0.title) }
            .task { await reload() }
    }

    func reload() async {
        isLoading = true
        let loaded = try? await load()
        guard !Task.isCancelled else { return }  // a cancelled flow writes nothing more
        isLoading = false
        error = loaded == nil ? "offline" : nil
        if let loaded { books = loaded }
    }
}
```

The shell that terminates those boundaries keys the fetch on the toggle
and persists the delete as a source-of-truth write:

```swift
struct BookShelfShell: View {
    @Environment(\.library) private var library
    @Binding var sortByAuthor: Bool
    @State private var books: [Book]?
    @State private var pendingSave: [Book]?

    var body: some View {
        BookShelf(
            books: books ?? [],
            sortByAuthor: $sortByAuthor,
            onDelete: { book in
                books?.removeAll { $0.id == book.id }
                pendingSave = books
            })
        .task(id: sortByAuthor) { books = try? await library.fetch(sortByAuthor) }
        .task(id: pendingSave) { if let pendingSave { try? await library.save(pendingSave) } }
    }
}
```

Every async job is structured. `.task` binds the work to the view's
lifetime, and `.task(id:)` restarts it on change, cancelling the stale
job at its next suspension point. No free-floating `Task`, and nothing
a test cannot reach. The shell is a view, so it tests like one. Hand it
a logged `LibraryService` through the environment and it produces a log
of its own.

When a job must outlive a `.task`, such as a download the user starts
with a tap, swift-core-flow's `@UnstructuredTask` holds it in a
view-owned slot that cancels the previous task on replacement and the
live one on teardown, and logs every assignment like `@TestState`. Use
a capture list in the task closure. Capturing the view keeps the
storage alive and defeats the teardown cancel.

## When to split, and when not to

- **One shell wherever the I/O is, not one per view.** A view made only
  of `let`s, bindings, and closures is already a core. A shell on it
  adds nothing.
- **Split when** the view owns a live wrapper and a preview or a test
  needs a state the wrapper cannot easily produce, or a boundary event
  you want to assert.
- **Cut with `@Shell` wherever the library is present.** It is the
  shorter code, and own state stays where it is used and still logs.
  Cut by hand only without the library; then state a test must reach
  moves up to the shell and enters the core as `@Binding`.

## Naming and layout

- The shell keeps the product name. The core takes the `Core` suffix
  (`BookList` and `BookListCore`), or is the nested twin (`Card.Core`).
  A `Host` and `Core` pair of files is the same split with the shell
  named for its job.
- A hand-written core is `internal`, not `private`. Tests and previews
  construct it directly. Shell and core read together, so they live in
  the same file until it grows past comfortable scrolling.
- Previews are constructions of the core with literals. A preview of a
  shell is `@Query` hitting a container, which is an integration test.
  Previews never touch real storage. The environment default serves
  them, and a specific value comes from `@Previewable @State` bound into
  a defaulted initializer.

## Why this is not a ViewModel

A ViewModel cut separates "UI" from "logic". But a node is already pure
logic, a transformation from inputs to children. Pulling logic out of
it separates logic from logic and adds an object to hold it.

The shell/core cut runs between I/O and pure, and only data crosses.
The core has nowhere to hide state or behavior outside its declared
boundaries, which is the property a ViewModel destroys. A ViewModel is a
shared mutable reference other code can alias, that can outlive the
node, and that cannot be sliced into a tuple, diffed by equality, or
logged as `(name, value)`.

## Checklist

- [ ] Every data-holding wrapper crossed the boundary. `@SceneStorage`
      became `@Binding`; no `@AppStorage` below the root; `@Query` became a plain array
      or `@QueryResult`; criterion-named `@State` became `@Binding` or
      `@TestState`.
- [ ] Machinery stayed in the shell or is copied verbatim on the twin.
      Everything the core reads from the environment is a value an
      ancestor set.
- [ ] Every boundary is one of the three shapes, visible in the property
      list. Every `async` or `throws` is behind a closure.
- [ ] The shell's `body` constructs the core and terminates its
      boundaries. The real `body` exists once.
- [ ] Previews are on the core and touch no real storage.
