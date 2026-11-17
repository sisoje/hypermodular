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
into the type, so it runs only inside a live render pipeline, not in
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
the array it delivers. The read itself is asked from the query service
and run in the shell ("The SwiftData shell", below), so a `@Query`
property is what a view not yet converted has.

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
| `@SceneStorage` (`@AppStorage` is the root's and not in a feature) | data, external storage | shell keeps it; core takes `@Binding` | `@Binding`. The key disappears, because a twin does not persist |
| a read of the store, `QueryView` over a query asked from the query service | reference, a filtered read | in the shell's `body`; core takes a plain `let` array | copied with the `body`; the scenario supplies the result by setting the member to a fixed result or with a seeded container |
| `@Query`, in a view not yet converted | reference, a filtered read | shell keeps it; core takes a plain `let` array | `@QueryResult`. The memberwise init takes the bare array |
| `@FocusState` | machinery | shell | `@TestFocusState`: a real `FocusState` underneath, programmatic writes log |
| `@Environment` value, your own `@Entry` | reference | in the core; the scenario sets it with `.environment(...)` | copied verbatim; the scenario sets it with `.environment(...)` |
| `@Environment(\.dismiss)`, `(\.openURL)` | reference, sealed action | shell reads it and hands the core a closure, because nothing can build one from above | `@TestEnvironment`: the real action runs, every call logs |
| `@GestureState`, `@Namespace` | machinery | shell | copied verbatim: live when hosted, defaulted otherwise |
| `@ScaledMetric` | machinery | may stay in the core. It has a default and does not block construction | copied verbatim |
| `@StateObject`, `@ObservedObject` | none | not in this architecture | unmapped on purpose: no value-shaped boundary to substitute |

## The three extraction rules

Extracting the core is a mechanical split into two views.

1. **Plain fields go to the core.** They are already data.
2. **Data-holding wrappers become boundaries.**
   - `@SceneStorage` becomes `@Binding`. External storage is a
     dependency, and whoever constructs the core supplies it.
     `@AppStorage` is the root's and not in a feature.
   - A read of the store becomes a plain `let` array. The shell asks
     the query service and hands the fetched result in as a value. A
     `@Query` property found in the view becomes the same `let`.
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
    @Environment(\.queryService) private var queryService          // rule 2: the store's reads
    @Binding var sortByAuthor: Bool                                // rule 1: the root's storage, a binding
    let onDelete: (Book) -> Void                                   // rule 1: already data

    var body: some View {
        QueryView(queryService.books(sortByAuthor)) { $books in    // rule 2: the fetch, run here
            BookListCore(books: books, sortByAuthor: $sortByAuthor, onDelete: onDelete)
        }
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
assertion on the core's boundary events (`testing.md`). A core is
previewed directly like this, constructed with literals. A shell, or
any view that owns state or reads a live wrapper, is previewed through
a scenario, which owns or sets what the view needs.

## Worked example, with `@Shell`

`@Shell` is a member macro that generates a nested, always-internal
`Core`: the same `body`, helpers, methods, and nested types, copied by
the compiler. Stored properties follow two rules. Wrappers on the
mapping whitelist (the table above) are substituted with test
boundaries. Everything else is copied verbatim. Members written in a
separate extension are invisible to the macro, so a helper the core
needs sits in the type body. `@Shell` requires Swift 6.4 (Xcode
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

`Card` is a view as it stood before the cut, its read written into it
as `@Query`. That is the case `@Shell` was made for. A view written by
the method asks the query service ("The SwiftData shell", below), and
its `QueryView` is copied onto `Core` with the `body`.

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

The mapped wrappers are `private` on the host, and the macro
diagnoses anything else. They are the view's own source of truth, not
something a caller supplies. A plain `private` field with no wrapper is
a compile error, because pure data flow has no room for opaque state.

## Worked example, screen first

A new screen starts from the design, not from a view to cut. The
address form has two fields, an error label under each, and a Save
button. Three pieces, written in this order.

```swift
struct Address { var street: String; var city: String }

// AddressFormCore.swift
// 1. The core, read off the screen. Two fields, two error labels, one button.
struct AddressFormCore: View {
    @Binding var street: String
    let streetError: String?
    @Binding var city: String
    let cityError: String?
    let onSave: () -> Void

    // The design: "Save is disabled while an error shows."
    var canSave: Bool { streetError == nil && cityError == nil }

    var body: some View {
        Form {
            TextField("Street", text: $street)
            if let streetError { Text(streetError).foregroundStyle(.red) }
            TextField("City", text: $city)
            if let cityError { Text(cityError).foregroundStyle(.red) }
            Button("Save", action: onSave).disabled(!canSave)
        }
    }
}

// AddressFields.swift
// 2. The transformer, where a write is judged. Raw bindings in,
//    intercepted bindings out. No state.
struct AddressFields {
    @Binding var street: String
    @Binding var streetError: String?
    @Binding var city: String
    @Binding var cityError: String?

    var streetField: Binding<String> {
        Binding(get: { street }, set: { text in
            guard text != street else { return }
            street = text
            let error = Self.required(text)
            if error != streetError { streetError = error }
        })
    }

    var cityField: Binding<String> {
        Binding(get: { city }, set: { text in
            guard text != city else { return }
            city = text
            let error = Self.required(text)
            if error != cityError { cityError = error }
        })
    }

    func judge() -> Bool {
        let streetJudged = Self.required(street)
        if streetJudged != streetError { streetError = streetJudged }
        let cityJudged = Self.required(city)
        if cityJudged != cityError { cityError = cityJudged }
        return streetJudged == nil && cityJudged == nil
    }

    static func required(_ text: String) -> String? {
        text.trimmingCharacters(in: .whitespaces).isEmpty ? "Required" : nil
    }
}

// AddressForm.swift
// 3. The shell. It owns the state and wires it. It decides nothing.
struct AddressForm: View {
    @State private var street = ""
    @State private var streetError: String?
    @State private var city = ""
    @State private var cityError: String?
    let onSave: (Address) -> Void

    var body: some View {
        let fields = AddressFields(
            street: $street, streetError: $streetError,
            city: $city, cityError: $cityError)
        AddressFormCore(
            street: fields.streetField, streetError: streetError,
            city: fields.cityField, cityError: cityError,
            onSave: {
                if fields.judge() { onSave(Address(street: street, city: city)) }
            })
    }
}

#Preview("An error, no typing") {
    AddressFormCore(
        street: .constant(""), streetError: "Required",
        city: .constant("Belgrade"), cityError: nil,
        onSave: {})
}
```

The core's initializer is the screen's inventory, and the preview
constructs a state no typing would reach in one step. The design's
sentence about Save is a computed value in the core. The rule, what
makes a street wrong, is in the transformer, and a plain test writes
through `streetField` over local variables and reads `streetError`
back. A write of the value already held is dropped before the rule
runs, and an error is written only when it changes. The shell holds
four loose `@State`s and assembles the `Address` only when Save hands
it on. Where the shell's own writes are to log, it carries `@Shell`
("When to split" below).

The example wires the transformer by hand so that it reads without the
library. With swift-core-flow the transformer carries `@Capability`,
and the shell takes `AddressFields(...).capability`, one tuple of the
field bindings, the messages, and `judge`, and hands the core nothing
else (the library's skill, "Transformers").

## What a core consumes: three shapes of I/O

A closure of any signature is a behavior. The core calls it and does
not care what it does. For mocking, every boundary a core touches falls
into one of three shapes, and naming the shape tells you how to hand it
in and how a test stands in for it.

| Shape | What it is | Flows in as | In a test |
|---|---|---|---|
| input | a fact the core reads | a `let` (a fetch result), a `@Binding` (storage), an environment value | hand it data, a constant binding or a stubbed array. You are not testing whether the source works, only that the core reads and derives from it correctly |
| black hole | a sink the core gives data to and forgets | a closure: `save(model)`, `haptic()`, analytics | a spy. Assert it was called, with the right payload. Whether it persists or fires is the boundary's own test |
| async effect that can fail | a result the core awaits but does not implement | an `async throws` closure: `try await load()` | a stub per edge case (a value, an error, a delay), one test each. The result, error, and loading handling live in the core |

The core decides what to do. The boundary does the I/O. Pick any
screen. Its entire relationship to the outside world is a handful of
these, all visible in its property list. No hidden service locator, no
ambient singleton, nothing a comment has to remind you to register. A
contract's no-op default is all three shapes stubbed, and a test
overrides every closure the node's label names.

`async` is the I/O marker for what the core awaits. A black hole is
synchronous because the core does not await it. The root's closure
starts no `Task` for it, since creation is not lifecycle; work that is
asynchronous is an `async` closure, and the node that calls it owns the
task. Effects belong in the type signature. A closure
typed `() async throws -> Void` reads as "async effect that can fail".
See `async` or `throws` in a signature and you are looking at a
boundary that belongs behind a contract, not inline in view logic.
Pure logic is synchronous and non-throwing, which is the proof that it
is pure. `grep async` finds every awaited boundary.

## The SwiftData shell

A read of the store is a query, and its configuration (filter, sort,
section) comes from state, yet a `@Query` is locked in at
construction. Building it in a child's `init` off parent state
constructs a new query on every parent re-render. Apple DTS confirmed a
filtered `@Query` re-fetching once per keystroke in the parent. And
`.id(value)` on that child destroys the subtree's state whenever the
value changes. swift-core-flow's `QueryView` builds the live query in
`body`, rebuilds it only when its dependencies change, and hands
content the result as plain data. A query made in the view is
`QueryUtilities.lazyQuery` bound to a name, `let sorted =
QueryUtilities.lazyQuery { (descending: Bool) in Query(…) }` asked
with `QueryView(sorted(descending))`. Its arguments are its
dependencies. A value the expression captures and does not take as an
argument is a change the query does not follow, with no error and no
warning. And the store's predicate and sort are in the view.

So the query is not written in the view. It is asked from the query
service, a contract in the layer, with the values it depends on as
arguments. What comes back is a `LazyQuery`, the query not built yet
together with those values. The arguments are the dependencies, so
there is no list to write and none to forget.

The contract, in the layer. `@LazyQueries` writes its initializer and
`defaultQueries`, which the entry defaults to:

```swift
// Packages/DataCoupling/Sources/DataCoupling/Services/QueryService.swift
import SwiftData
import SwiftUI

@LazyQueries
public struct QueryService {
    public var books: (_ byAuthor: Bool) -> LazyQuery<Book, [Book]>
}

public extension EnvironmentValues {
    @Entry var queryService = QueryService.defaultQueries
}
```

The node. The shell asks, and the core takes the array:

```swift
struct BookList: View {
    @Environment(\.queryService) private var queryService
    @Binding var sortByAuthor: Bool
    let onDelete: (Book) -> Void

    var body: some View {
        QueryView(queryService.books(sortByAuthor)) { $books in
            BookListCore(books: books, sortByAuthor: $sortByAuthor, onDelete: onDelete)
        }
    }
}
```

`QueryView` hands its content the query's result, written `$books`,
and `books` inside the closure is the array.

The dependency that wraps the store. A query expression is the store's
knowledge. It is written once, as a function from the arguments to a
fetch descriptor. The initializer the macro writes takes, for each
member, a closure with the member's arguments that returns the
`Query`, and here that closure builds the `Query` over the descriptor:

```swift
// Packages/Dependencies/BookStore/Sources/BookStore/BookStore.swift
struct BookStoreInjector: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(BookStoreWrites())       // sets dbService over \.modelContext
            .environment(\.queryService, QueryService(books: { byAuthor in Query(books(byAuthor: byAuthor)) }))
            .modelContainer(for: Book.self)
    }
}

func books(byAuthor: Bool) -> FetchDescriptor<Book> {
    FetchDescriptor(sortBy: [SortDescriptor(byAuthor ? \Book.author : \Book.title)])
}
```

Its test fetches with that function from a seeded in-memory container.
It is a plain test, with no view and no host:

```swift
@Test func booksAreFetchedInTheOrderAsked() throws {
    let container = try ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    context.insert(Book(title: "Dune", author: "Herbert"))
    context.insert(Book(title: "Anathem", author: "Stephenson"))

    #expect(try context.fetch(books(byAuthor: false)).map(\.title) == ["Anathem", "Dune"])
    #expect(try context.fetch(books(byAuthor: true)).map(\.title) == ["Dune", "Anathem"])
}
```

- **Whoever provides the arguments gets the dependencies for free**,
  since they are the arguments. Calling the member builds nothing. It
  is called on every render, and the query is built again only when
  an argument changes.
- **A `LazyQuery` that holds a query is made only by calling a member
  of the service and read only by `QueryView`.** Nothing else can open
  one or build one, so a query does not travel without the values it
  was asked with. The one public initializer, `LazyQuery(result:)`,
  makes a fixed result, which holds no query.
- **The service holds queries and nothing else.** Every stored
  property is a function that answers a `LazyQuery`. The store's
  writes are another contract, which stays writes only.
- **`defaultQueries` is the service before the root sets one.** Every
  member answers every record of its type, unsorted, whatever it is
  asked with. It serves previews and scenarios as any contract's no-op
  does.
- **A scenario sets the query its node asks to a fixed result, by
  name.** `.environment(\.queryService.books) { _ in LazyQuery(result:
  QueryResult(wrappedValue: [dune])) }`. `QueryView` hands that result
  to the content. No `Query` is built, no store is read, and no
  container is needed. A member is a `var`, so one is set alone and
  the others keep their queries, and two queries of one result type
  get their own records. A `QueryResult` with a `fetchError:` is the
  error branch. A child that reads the store has the member it asks
  set the same way. A read does not log, so no logger is set for it.
  Or `.modelContainer(for:inMemory:)` seeds a real container, and the
  default service fetches every record from it, unsorted. Under
  `@Shell` the `QueryView` is copied onto `Core` with the `body`, and
  the scenario supplies the records the same two ways.
- **The sort is proven where it is written.** The node's scenario
  proves the node, that it writes the sort flag and shows what it is
  handed. That the store returns the records in the order asked is the
  dependency's test above.

## Who owns the load

The action that puts a node in the graph starts the node's load, and
the node that handles the action owns it. A tap opens a book's
reviews. The list handles the tap, so the list assigns the task and
holds what it loads, and the detail receives a `let`:

```swift
struct Library: View {
    @Environment(\.reviewService) private var reviewService
    let books: [Book]
    @State private var opened: Book?
    @State private var reviews: [Review]?
    @UnstructuredTask private var load: Task<Void, Never>?

    var body: some View {
        List(books, id: \.id) { book in
            Button(book.title) {
                opened = book           // this action mounts the detail
                reviews = nil
                load = Task { [reviewService, $reviews] in
                    $reviews.wrappedValue =
                        try? await reviewService.fetch(book.id)
                }
            }
        }
        .sheet(item: $opened) { book in
            BookDetail(title: book.title, reviews: reviews)
        }
    }
}
```

`BookDetail` has no `.task`. A `.task` on it would hang the load on
the view on screen, and that view appears again when a screen pushed
over it is popped or the user comes back from another tab, so the
load would run again each time. Here the load runs once for each tap,
a second tap replaces it, and what is loaded is state the list holds
and decides. The example keeps one fact, the reviews, `nil` while
they load. A screen that shows a spinner or an error holds those as
two more fields, written by the same task. When the tap goes through
the navigation contract, the node that answers the route is the one
that mounts the screen. It handles the action, so it starts the load
and holds it. The caller sent a route and data and holds nothing.

A node that no action mounts has only the runtime's event, `.task`.
The first screen at launch is the case. Launch is the app's own start
and is handled at the app level, where a `.task` on the node that does
not leave is the easiest means. There the loading flow
(spinner on, fetch, spinner off, error or data) is a rule the core can
own. Whether it does, or a shell above it does, is a choice per
feature, not a default. Once the core owns the load, the `let`s it
produces become bindings, and the sequence becomes a rule of the
feature, a method the `.task` calls:

```swift
struct LoadingShelf: View {
    @Binding var books: [Book]
    @Binding var isLoading: Bool
    @Binding var error: String?
    let load: () async throws -> [Book]

    var body: some View {
        NavigationStack {
            List(books, id: \.id) { Text($0.title) }
        }
        .task { await reload() }   // launch is not an action
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

The `.task` hangs above the stack, on a node that does not leave. Hung
on a list inside the stack or under a tab, it would run again each
time the list reappears. The second example is another form of the
same screen, where a shell above the core holds the load. It starts
the first fetch, starts the refetch on the toggle's write, and
persists the delete as a source-of-truth write:

```swift
struct BookShelfShell: View {
    @Environment(\.library) private var library
    @Binding var sortByAuthor: Bool
    @State private var books: [Book]?
    @UnstructuredTask private var fetch: Task<Void, Never>?
    @UnstructuredTask private var save: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            BookShelf(
                books: books ?? [],
                sortByAuthor: Binding(
                    get: { sortByAuthor },
                    set: { byAuthor in
                        sortByAuthor = byAuthor   // the write is the action
                        load(byAuthor)
                    }),
                onDelete: { book in
                    let kept = (books ?? []).filter { $0.id != book.id }
                    books = kept
                    save = Task { [library] in try? await library.save(kept) }
                })
        }
        .task { load(sortByAuthor) }   // launch is not an action
    }

    func load(_ byAuthor: Bool) {
        fetch = Task { [library, $books] in
            let loaded = try? await library.fetch(byAuthor)
            // a replaced fetch writes nothing
            guard !Task.isCancelled else { return }
            $books.wrappedValue = loaded
        }
    }
}
```

No node starts a `Task` it does not hold, and the trigger decides the
form. The shelf is the first screen at launch. No action mounted it,
so its first fetch has only the runtime's event, `.task`. The `.task`
hangs on the shell, above the `NavigationStack`. That node does not
leave, so the fetch does not run again when a screen pushed inside the
stack is popped. Hung on the shelf inside the stack, it would. The
refetch has an action, the toggle's write. The shell hands the core a
binding whose setter stores the sort and starts the fetch. Launch and
the setter go through one function and one slot, so a toggle during
the first fetch replaces it, and a replaced fetch writes nothing. The
setter is built by the node that every write of the value passes
through. Here that is the shell, since the shelf's toggle is the
sort's only writer. A value written in more than one place is
intercepted by its owner. `.task(id:)` is used only when its id is a
value the app's code does not control, one the system supplies. The
sort is the app's own data. The app knows it changed when it writes
it, and has no use for the UI runtime to drive the fetch.
`.task(id: sortByAuthor)` would refetch on the change too, and again
at every reappearance with the sort unchanged. Its id is a value that
is `Equatable` by nature, a flag, a count, a string, not a model made
`Equatable` for it.

The save is started by an event, a delete, so the shell assigns it. A
job the user starts with a tap, a save or a download, is
swift-core-flow's `@UnstructuredTask`: it holds the task in a
view-owned slot that cancels the previous task on replacement and the
live one on teardown, and logs every assignment like `@TestState`.
Writing `nil` cancels on demand, and `save != nil` is the fact that
work is in progress. A delete the user may undo for a few seconds is
the same slot. The task awaits the delay, a contract's `async` closure,
then calls the delete, and Undo writes `nil`. The slot sits in the
node whose lifetime the work shares, since removing that node cancels
it. A delete started on a detail screen and meant to finish after the
user has left it is held by the node above, the list. Held in the
detail, going back within the few seconds would cancel the delete. The assignment is a write the node makes at a
moment the node chooses, so the node controls the work and a test
reads it. A second delete replaces the first save, and the new one
carries the whole list. A second delete while one waits for its undo
first commits the waiting one, since replacing its task would cancel
it and undo it unasked. Use a capture list in the task closure.
Capturing the view keeps the storage alive and defeats the teardown
cancel. Capture the contract, `[photoService]`, and call
`photoService.load(item)` inside it, not the closure,
`[load = photoService.load]`, which reads as a read of the contract
and not as the call the label names. A child that starts the work receives the slot as a
`Binding<Task<Void, Never>?>`, `$save`, and its write cancels and logs
the same way.

Without the library a tap has no held form, since a hand-written slot
is a class in `@State`. The fallback there, and only there, is a count
the event increments and `.task(id: saveCount)` runs on, the count
being what lets the same save run twice.

Nothing here is free-floating, and nothing a test cannot reach. The
shell is a view, so it tests like one. Hand it a logged
`LibraryService` through the environment and it produces a log of its
own.

## When to split, and when not to

- **One shell wherever the I/O is, not one per view.** A view made only
  of `let`s, bindings, and closures is already a core. A shell on it
  adds nothing.
- **Shells and cores cascade.** A core's child may be a shell with a
  core of its own, to any depth. Where a piece of state should sit is
  not a puzzle to solve for the whole feature. It sits in the node
  that uses it, and when a scenario or a preview must hand it in, one
  more shell goes above that node. Each node is tested alone as a
  unit, and the composition works because every edge between them is
  data. That is what hypermodular means.
- **Screen first for a new screen.** The core is written before the
  view that feeds it, read off the screen one property per element,
  with the design's own rules in it (`SKILL.md`, "Cut"). The view above
  is then the answer to where each property comes from. The three
  extraction rules above are for a view that already exists with its
  wrappers.
- **Split when** the view owns a live wrapper and a preview or a test
  needs a state the wrapper cannot easily produce, or a boundary event
  you want to assert.
- **`@Shell` or by hand is judged per view, as the work goes.** Neither
  is the default.
  - **`@Shell`** was made for a view that already exists, a legacy
    screen with its wrappers fused in. One attribute makes it testable
    and nothing is rewritten, so a project gains tests one view at a
    time. It is also the practical choice wherever the state and the
    `body` that uses it are to be tested together, in one log. Own
    state stays where it is used and logs at the write site, and a
    sealed action, a focus write, and a query are covered by the same
    cut.
  - **By hand** fits a new screen modeled from the design. The core
    owns no wrapper, so there is nothing to cut, and a scenario or a
    preview constructs any state of it from literals. State a test
    must reach lives in the shell and enters the core as `@Binding`,
    and a rule sits in a transformer between them.
  - **All three together** when the shell itself is to be tested. The
    core is written by hand from the screen, the shell is written by
    hand above it, and that shell carries `@Shell`. The macro's cut of
    the shell proves the real shell, its state writes, its wiring into
    the core, and its contract calls, in one log. The evidence blocks
    are proven on the shell's generated `Core`, so the scenario is owed
    to that one. The hand-written core is constructed from literals in
    its preview, and gets a scenario of its own only when a block is
    declared on it. A hand-written shell without the macro is proven
    only through its contracts.
  - Without the library the cut is by hand.

## Naming and layout

- The shell keeps the product name. The core takes the `Core` suffix
  (`BookList` and `BookListCore`), or is the nested twin (`Card.Core`).
  With all three pieces two types carry the word, and they are two
  things. `AddressFormCore` is the screen, written by hand.
  `AddressForm.Core` is the shell's generated twin, which constructs
  it, and it is the one a scenario names.
  A `Host` and `Core` pair of files is the same split with the shell
  named for its job.
- A hand-written core is `internal`, not `private`. Tests and previews
  construct it directly. The shell and the core are two types in two
  files, `BookList.swift` and `BookListCore.swift`, and the transformer
  is a third. Most types get a file of their own, named for the type.
  A scenario is a file of its own, named for the scenario, beside the
  view it stages, and the `#Preview` that shows it is in the view's
  file. A generated `Core` has no file.
- A core's preview is a construction of the core with literals,
  written directly in `#Preview`. A view with state or a live wrapper,
  a shell, is previewed through a scenario and not bare. A bare
  preview of a shell is a query hitting a container, which is an
  integration test.
  Previews do not touch real storage. The environment default serves
  them, and a specific value comes from `@Previewable @State` bound into
  a defaulted initializer.

## Why this is not a ViewModel

A ViewModel cut separates "UI" from "logic". But there is no UI in a
node, and a node is already a transformation from inputs to children.
Pulling that out of it moves a transformation into an object and adds
the object to hold it. The cut that matters is state from the behavior
that mutates it.

The shell/core cut runs between I/O and pure, and only data crosses.
The core has nowhere to hide state or behavior outside its declared
boundaries, which is the property a ViewModel destroys. A ViewModel is a
shared mutable reference other code can alias, that can outlive the
node, and that cannot be sliced into a tuple, diffed by equality, or
logged as `(name, value)`.

## Checklist

- [ ] Every data-holding wrapper crossed the boundary. `@SceneStorage`
      became `@Binding`; no `@AppStorage` below the root; a read of the
      store is a `QueryView` in the shell over a query asked from the
      query service, and the core takes a plain array; a `@Query` left
      in a view not yet converted became a plain array or
      `@QueryResult`; criterion-named `@State` became `@Binding` or
      `@TestState`.
- [ ] Machinery stayed in the shell or is copied verbatim on the twin.
      Everything the core reads from the environment is a value an
      ancestor set.
- [ ] Every boundary is one of the three shapes, visible in the property
      list. Every `async` or `throws` is behind a closure.
- [ ] The shell's `body` constructs the core and terminates its
      boundaries. The real `body` exists once.
- [ ] A core is previewed directly, a shell through a scenario, and no
      preview touches real storage.
- [ ] On a new screen, every core property is a thing on the screen,
      and two screenshots that differ differ in an init argument. No
      model the feature invented, no `Task` nobody holds.
