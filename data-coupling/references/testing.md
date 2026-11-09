# Testing: reading the execution log

A common MVVM justification is "views can't be tested, so we extract
logic into a ViewModel class". In this architecture a core has a fully
declared boundary, so its entire observable behavior can be captured as
an execution log and asserted with one equality check. Nothing is
mocked in the OO sense, nothing is inspected behind a boundary, and no
effect is ever executed.

Sources: the masterclass (the scenario, the two rules), the method
article (direct construction, order, silence, mock depth, one test per
boundary), the swift-core-flow README (logging at the write site, the
hosted test).

## What a view's behavior is

A node's whole observable behavior is the children it creates and its
boundary events: the mutations it performs, the calls it makes, their
payloads. Nothing else about a node is observable.

How would Apple test `Button`? Its contract is "a physical tap calls the
action closure". There is nothing else to inspect. The only meaningful
test hands it an action that logs, taps it for real, and reads the log:

```swift
Button("Save") { log("action") }   // the mock is a logger

// UI test: tap "Save", then read the log: ["action"]
```

That contract can rot without a sound. Change the component's internals
so the tap no longer reaches the action, and no compiler, no type
check, and no screenshot notices. One test catches it, this one. Every
core has `Button`'s shape. Its whole behavior is state writes and calls
to handed-in closures. So every core tests the same way.

The children have no API to walk. Read them in a preview. The log is
what a test asserts.

## Mocking is construction

A boundary is a value, so the mock is a value, one wrapper deep:

- A logging `Binding`'s setter records `(name, value)` before storing.
- A logging closure records its payload before forwarding, or forwards
  nowhere at all.

By the shape of the boundary (`shell-core.md`):

| Shape | The mock |
|---|---|
| source of truth | hand it data: a constant binding, a stubbed array. A logging binding when its writes are the evidence |
| black hole | a spy closure. Assert it was called, with the right payload |
| async effect that can fail | a stub per edge case (a value, an error, a delay), one test each |

A contract's no-op default already stubs all three shapes. A test
overrides every closure the node's label names. The test wants the evidence,
not the effect.

## Direct construction, and why it is not the test

The method article constructs the core against logged boundaries and
calls its method. The whole test, for the loading shelf in
`shell-core.md`:

```swift
@Test @MainActor func offlineIsOneLog() async {
    var log: [String] = []
    let shelf = LoadingShelf(
        books: Binding(get: { [] }, set: { log.append("books \($0.map(\.title))") }),
        isLoading: Binding(get: { false }, set: { log.append("isLoading \($0)") }),
        error: Binding(get: { nil }, set: { log.append("error \($0 ?? "nil")") }),
        load: { log.append("load"); throw URLError(.notConnectedToInternet) })

    await shelf.reload()

    #expect(log == ["isLoading true", "load", "isLoading false", "error offline"])
}
```

This works only because every boundary of `LoadingShelf` enters at the
initializer. A core that reads a contract from the environment sees the
`@Entry` default here, since `@Environment` resolves only inside a
render pipeline, and `.environment(...)` on a struct in a unit bundle
sets nothing. Nor is there a `@State`, a focus, or a `TextField` to
drive. The form proves almost nothing. The hosted scenario is the
test, and the rest of this file is about it.

No render pipeline, no `.task`, no network. The driven sequence the
edge case named, asserted in one line. The order is guaranteed, not
conventional. `View` is a `@MainActor` protocol, so every member of a
conforming type inherits its isolation, and nothing can interleave the
writes. `@MainActor` on the test is required for the same reason. A
nonisolated test touching a `View`-conforming type's members crosses an
isolation boundary at runtime and traps under strict concurrency.

## The scenario

A scenario is a small test-host view that owns the real `@State` and
hands the core nothing but logged boundaries. It is also a preview.

```swift
struct SortScenario: View {
    @State private var storage = false
    let log: (String) -> Void

    var body: some View {
        BookShelf(
            books: [Book(id: "dune", title: "Dune", author: "Herbert")],
            sortByAuthor: Binding(
                get: { storage },
                set: { log("sortByAuthor \($0)"); storage = $0 }),   // logs, then stores
            onDelete: { log("onDelete \($0.title)") })                 // records; forwards nowhere
    }
}
```

A UI test drives the live scenario with real touches and real
keystrokes, and asserts the exact sequence. For a text field and a
submit button:

```swift
let field = app.textFields["Title"]
field.tap()
field.typeText("Dune")
app.buttons["Submit"].tap()

// names:  ["title","title","title","title","title","title",
//          "title","title","title","title","onSubmit","title"]
// values: ["","","D","D","Du","Du","Dun","Dun","Dune","Dune","Dune",""]
```

One equality check pins two binding writes per keystroke (`TextField`'s
real behavior, recorded as-is), the submit call carrying the full
title, and the clear as the final write. A login scenario reads the
same way: the `username` and `password` writes, the `submit` call
carrying both, the `isLoading` write, the navigation call.

One unit, one way to test it. The unit is the node, constructed from
values with nothing under it. The test hosts it in a scenario for live
reach, real `@State`, real input, the environment set, and reads the
log. A tap calling `onDelete` is `Button`'s contract, Apple's to test.
What the tap proves here is that the node's log holds `onDelete Dune`.
The log is the assertion, never the screen.

## The test host: a UI test here is a unit test

The classic UI test launched the whole app, navigated to a screen,
drove it against live services, and asserted what appeared on screen.
That is an integration test of everything at once, and it cannot see
what the screen did. This is a different thing with the same tooling.
swift-core-flow tests itself this way. Its hosted suite is one app
whose `main.swift` is `HostApp<TestScenario>.main()`, and every
scenario in the package runs there. A large app tests the same way,
with a dedicated test host whose only job is to host one unit at a
time, designed once.

- **A second `@main`, test-only.** Either a second app target over the
  same source set as the shipped app, or a small app that `@testable
  import`s the feature module so it can construct internal cores. It
  ships nothing. It links the host product of swift-core-flow if it
  uses it, and the shipped app never links that product.
- **One launch, one scenario, one node.** The host's root renders the scenario named in its launch environment
  and nothing else. swift-core-flow passes the scenario as JSON; a
  `Codable` enum with one case per unit is one way to spell it. No root
  view, no navigation stack, no other screens, no live service. The
  host sets nothing into the environment. The scenario sets the
  loggers. A test never launches the shipped app.
- **The unit is the node.** Whatever is hosted (a row, a screen, a
  feature subtree) is the unit, and the test's reach is that node's
  edge. Inside the edge, taps, focus, gestures, and owned state are
  real. At the edge, every boundary event enters the log instead of
  crossing into an effect. Nothing is behind the boundaries, so no side
  effect exists beyond them.
- **The granularity is the shell/core cut.** One scenario per core, in
  its own file, and a core exists wherever the I/O is. A screen with one
  shell is one unit. A component with its own boundaries is its own
  unit, testable alone. The scenario holds the mock state, pre-filled
  so the action under test is reachable, with every binding wrapped to
  log and every handed-in closure logging. With swift-core-flow that is
  `@TestState` and `@TestAction` fields and one `Core(...)`
  construction.
- **One scenario, two uses.** The same view is the `#Preview` and the
  launch target of the UI test. Writing the preview is writing the
  fixture. Scenarios live in
  the app or feature target like every preview, with no `#if DEBUG`,
  and a release build drops them.
- **The UI-test bundle launches the host on a scenario**, drives it,
  reads the log through the transport, and compares. It links the
  testing product, which imports XCTest, and nothing else does.
- **It grows one unit at a time.** A new unit is one enum case, one
  scenario file, and one test. The host never learns the app's
  structure, so it never changes when the app does.

Why a host at all: `@State`, focus, gestures, the environment, and
`TextField`'s two writes per keystroke exist only inside a live render
pipeline. The host supplies that pipeline and nothing else. "Unit" was
never about how the test runs. It is about what is constructed, and here one node is
constructed, from values, with nothing under it.

## A criterion is a log

The stateless feature couples to nothing but data, and that makes the
product owner's words literal code. *Given* names constructor
arguments and stubs. *When* names an interaction, a closure call driven directly
or by a real tap. *Then* names boundary events. "Given an empty
library, when the user submits a title, then the book is saved" is a
construction, a tap, and a log assertion, with no translation through
services or architecture.

Anything an acceptance criterion names must therefore enter the feature
as a `let`, a `@Binding`, or a closure, or, with `@Shell`, stay private
`@State` whose writes log. Purely presentational state stays local.

## The rules that keep a log honest

**Effects log, getters don't.** Writes and calls fire once per event, on
the component's own timing. That is deterministic, so a test asserts
the exact sequence with one equality check. Reads fire on the render
scheduler's timing, so the same property can log zero, one, or several
times per action, which breaks assertions. Never log from a `get`. A
test that needs "was this read?" uses a use-site spy binding instead.

**Whose source of truth, not who holds the pen.** A text field writing
the node's `title` logs every keystroke though the system held the pen.
The system moving focus logs nothing, because focus is the system's.
Programmatic focus moves are the component's own decisions, and those
log.

**Test the action, not the aftermath.** SwiftUI views are ephemeral
values. The runtime owns the state, and the model is view, action, next
view. A core test verifies that an action executed with the right
input (the handed-in closure was called with the expected model, the
binding was written) and the immediate view state, such as a button
disabled while the form is invalid. It does not assert that the result
later appears on screen. That is a different view tree, and the
assertion would be testing SwiftUI itself.

**Assert the order the criterion names.** Where two writes are
interchangeable the test sorts them into one fixed order before
comparing, duplicates kept, and the block shows that order. Over-specify and the
test breaks on refactors again, at depth one.

**Silence is evidence.** No `books` entry means the failure wrote
nothing. Record the behavior as-is. Two writes per keystroke is
`TextField`'s behavior, and the log keeps it.

**Mock depth is one, permanently.** Everything that enters a core is a
value, closures included, so every mock is a value. The mock of
`onDelete` assumes nothing about databases, contexts, or sessions,
because a function type has no members to stub. Depth has nowhere to
descend, and the signature is the whole contract. An OO mock had to
simulate an object, and an object's behavior reaches down through its
collaborators. Depth was transitive, ending only at a type with no
methods left to call. A mock was never a testing technique. It was a
coupling repair, converting behavior coupling into data coupling per
test at the price of simulating everything behind the interface. Here
the coupling is data before any test exists, and the conversion has
nothing left to do. What the real `fetch` does with a 304, or `save`
with a conflict, is a separate question with a separate test, one per
boundary, at the shell, written once. The feature never asks it again.

**The log names only boundary events.** A log assertion is an
interaction test, with one difference from the expectation-checking
style that made mockist suites brittle. Their expectations named
collaborators, internal conversations a refactor is free to reshuffle.
The log names only the events the acceptance criterion already names.
Refactor the core and the log cannot change. Only a changed requirement
can. Interaction was never the brittleness. Interaction with internals
was.

**The log is exhaustive by construction.** A core captures nothing it
was not handed, so its parameters are its only channel outward.
Instrument them all and no effect escapes unlogged. The effect needs no
witness.

## Getting the log across the process boundary

A UI test runs in a separate process from the app. The scenario's log
cannot hand its record to the test directly, so the host needs a
transport. Keep it dumb:

- **Render the log into the host** as one accessibility element, names
  in its label and values in its value, and have the test wait until
  the label equals the expected name sequence. This is what
  swift-core-flow's `uiTestLog()` does.
- **Append entries to a file** the test reads on teardown. One committed
  text file per test, truncated at setup and regenerated in place by the
  run. A green run reproduces the file byte for byte, and any failure or
  behavior change shows up as a `git diff` of the log. The diff of the
  action sequence is the test report. A missing file means "review and
  commit the generated log".
- **No transport** when every boundary enters at the initializer and
  the test constructs the core in-process. The log stays a plain array,
  and the test proves what the section above says it proves.

The transport is plumbing. The assertion, one equality check on the
ordered record, is the point.

## With swift-core-flow

The package mechanizes the scenario so that most of it wires itself.
Everything logs to the installed sink at the write site, never through
a view-layer observer replaying history.

- **`@TestState var count = 0`** is a drop-in `@State` that logs every
  mutation. The storage stays live. The single logging point is the
  setter, and the generated `$count` binding routes through the
  property, so direct writes and binding writes log identically.
- **`@TestAction var save: (Item) -> Void = { _ in }`** makes reading
  the property the logged action. Each call logs an arity-shaped
  payload, then forwards, with `return`, `try`, and `await` carried
  through.
- **`@TestFocusState`** keeps native focus behavior and logs
  programmatic writes. `@TestEnvironment(\.dismiss)` logs each call
  and runs the real action. That is the "did it really dismiss" test
  plain SwiftUI cannot write, because `DismissAction` has no public
  initializer.
- **`@Shell`** generates the `Core` whose own `@State` is already
  `@TestState`, so a scenario adds only what the host takes from
  callers: `@TestAction` closures, data arguments, backings for genuine
  `@Binding`s. Your own closure `@Entry` values need none of this.
  Set them with `.environment`, and the mock is where the log goes.
- **The sink** is `@MainActor (String, String) -> Void`. Payloads are
  `String(describing:)` frozen at the call site. The default is a
  no-op, so hosts behave normally wherever no sink is installed.
- **`HostApp<Scenario>`** (`CoreFlowUITestHost`) is the test-only host
  app. `HostApp<TestScenario>.main()` is its whole `main.swift`, and
  `View.uiTestLog()` installs the sink and exposes the log as one
  accessibility element. `CoreFlowUITesting` gives the UI-test
  bundle `XCUIApplication.launch(_:)` on a scenario, `app.logElement`
  with `logNames` and `logValues`, `waitUntil(_:equals:timeout:)`, and
  `tapOrClick()`, `switchOrCheckBox(_:)`, and `pressOrClick(...)`, one
  spelling for every destination. The host app links the host product,
  never a shipping app. The test bundle links the testing product, which
  imports XCTest.

## When the log is the wrong tool

- The behavior under test is a pure derivation: a computed property, a
  formatter, a calculator. Assert the value directly. Pure logic is
  synchronous and non-throwing and needs no host.
- The requirement names no order. Then the test sorts the
  interchangeable entries into one fixed order before comparing,
  duplicates kept. It is never a subsequence. The whole log is compared with one equality, so
  a call the criterion did not name fails the test, which is the
  point.

## Pitfalls

- **Logging from a getter.** The single most common cause of a flaky
  log test.
- **Asserting "body was evaluated N times".** Evaluation counts change
  with SwiftUI internals. Assert semantics: logged boundary events,
  state values, rendered text.
- **Missing `@MainActor`** on a test that touches a `View`-conforming
  type's members, including a `Core`. Match the isolation of the thing
  under test. Leave the annotation off pure derivations.
- **`tap()` or `click()`, never both.** Mac Catalyst sends nothing on
  `tap()`. An iPhone simulator rejects `click()`. The package helpers
  choose at compile time.
- **A sleep in a UI test.** Wait on the log element's label instead.
