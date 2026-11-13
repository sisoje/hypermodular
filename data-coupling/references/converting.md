# Converting: a codebase that already exists

The legacy job on the code side. The app works, it was written around
objects, and it is to come under the method without stopping.
`hypermodular/references/reverse-engineering.md` maps such a codebase.
This file converts its code. Map first. The map gives every feature an
address, and its findings, a value set below the root, a decision in a
surprising node, are the worklist.

Read this when a ViewModel, a store, a coordinator, a reducer, or a
dependency container is in front of you and the task is to bring the
screen it serves under the method, or to add a feature beside it.

## One node at a time

Nothing is rewritten at once, and the app ships after every step. A
converted node's edge is data, values, bindings, and closures, so it
sits beside code that is not converted yet and neither side knows. The
unit of work is one node of the map.

A node's criteria are agreed with the owner before it is converted, and
declared as evidence, as the hypermodular skill has it. The code is
not the source of a criterion. Legacy code shows what it does, not
what someone decided.

## Two kinds of legacy view

Look at what drives the view.

- **Its own wrappers.** A SwiftUI view with `@State`, `@Query`,
  `@SceneStorage`, or `@FocusState` fused into it, and no object. Put
  `@Shell` on it as it stands. One attribute, nothing rewritten, and
  the view has a core a scenario can construct and a log a test can
  read. This is the case the macro was made for, and a project gains
  tests this way one view at a time. An `@AppStorage` found in it is
  the root's. It moves there and comes back as a binding.
- **An object.** `@StateObject`, `@ObservedObject`,
  `@EnvironmentObject`, or an `@Observable` class with methods.
  `@Shell` does not help here. It copies an object wrapper onto the
  core verbatim, since there is no value-shaped boundary to put in its
  place. The screen is modeled again from what it shows, the core read
  off the screen and the shell above it (`shell-core.md`, "Worked
  example, screen first"), and the object is taken apart by the table
  below.

Without the library both kinds are cut by hand, by the three extraction
rules in `shell-core.md`.

## Taking an object apart

A ViewModel, a store, a manager, a presenter all hold the same few
things, state and the behavior that mutates it. Each has one place to
go, and none of those places is another object. The conversion has no
remainder, since the state is consumed as values and the behavior as
closures that mutate through those same values, which is the code
skill's rule.

| In the object | Where it goes |
|---|---|
| `@Published var email`, a stored property the screen shows | loose `@State` in the shell, one per fact, handed to the core as a `let` or a `@Binding`. Not a `State` struct |
| `@Published var state: LoadState`, an enum with a case per phase | the facts it fused, `isLoading`, `error`, `books`, each its own `@State` |
| a computed property over the state, `canSubmit` | a computed value in the core |
| a method that only writes the state, `reset()` | the write itself, at the control that triggers it |
| a method that judges input, `validateEmail()` | a transformer between the shell's state and the core's binding, the rule a pure function |
| a method that calls a service, `submit()` | a call to a contract's closure, awaited in a task the node holds, started by the action that causes it. `.task` only where no action can be determined |
| a service handed to `init`, a protocol and its class | a contract in the layer, a struct of closures with an `@Entry` no-op, its live value set at the root |
| `Service.shared`, a container's `resolve()` | the same contract. The root is the one place that names the singleton or the container |
| work started in `init`, `init() { load() }` | the action that mounts the node starts it, as a task the node that handles the action holds. `.task` on the node where no action mounts it, the first screen at launch. Creation starts nothing |
| the object itself built in the view's `init` from a value the parent hands in, `_vm = StateObject(wrappedValue: BookViewModel(id: id))` | Nothing is built at creation. Left as it is, `StateObject` defers its argument, so the object is built once and keeps the first `id`. `id` is an input of the node, and the object's state and behavior go where the other rows send them. What the object computed from `id` with no service call is built by the parent's event or derived in the child (`data-flow.md`, "A value built from an input"). What it loaded for `id` is a call to a contract, started as the row above this one says |
| a Combine `sink`, an `AnyCancellable`, `[weak self]` | `.task` over the stream a contract's closure returns, or a task the node holds. The runtime cancels it, so there is nothing to store and nothing to weaken |
| a coordinator or a router the object calls | a call to the navigation contract with a route and data. A sheet or a stack only this node drives is the node's own `@State` |
| an app-wide object every screen reads, `AppViewModel`, a session | state the root owns, handed down as the fact, the binding, or the closure each feature uses |
| the mock class, and the protocol that existed for it | nothing. A scenario's logging closure is the mock |
| a unit test that calls a method and asserts a `@Published` value | the hosted scenario's log. A test of a pure calculation stays, as a plain test |

The same table reads a reducer architecture. Its `State` struct is the
loose state. An `Action` case is the write or the call it stood for.
The reducer is the view. An `Effect` is an awaited closure, and a
`@Dependency` is an environment contract.

## The order for one node

1. Find the node on the map and read its label. The label lists what
   the converted node may call and write.
2. Agree its criteria and declare the evidence.
3. Write the core from the screen. It compiles against nothing.
4. For each service the object called, add the closure to a contract
   in the layer, with its no-op default. The node that calls it
   dictates the signature, not the service that exists.
5. Write the shell. Loose state, the contract read from the
   environment, a transformer where a write is judged, a held task
   where an event starts work.
6. At the root, set the contract's live value by wrapping the service
   that already exists in the contract's closures. The service is not
   touched.
7. Write the scenario, drive it, and make the log match the evidence.
8. Point the parent at the new node. Delete the object, its protocol,
   its mock, and the tests that asserted its published state.
9. Update the map in the same commit.

## Worked example

A signup screen, before. The object owns the screen's state and its
actions, the service is handed to its `init`, and the button starts a
`Task` nobody holds.

```swift
final class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isSubmitting = false
    @Published var error: String?

    private let api: API
    init(api: API) { self.api = api }

    var canSubmit: Bool { email.contains("@") && password.count >= 8 && !isSubmitting }

    func submit() async {
        isSubmitting = true
        defer { isSubmitting = false }
        do { try await api.signup(email: email, password: password) }
        catch { self.error = "Sign up failed" }
    }
}

struct SignupView: View {
    @StateObject var vm: SignupViewModel

    var body: some View {
        Form {
            TextField("Email", text: $vm.email)
            SecureField("Password", text: $vm.password)
            if let error = vm.error { Text(error).foregroundStyle(.red) }
            Button("Sign up") { Task { await vm.submit() } }.disabled(!vm.canSubmit)
        }
    }
}
```

After. The four `@Published` properties are four loose `@State`s, the
computed property is in the core, the method is a task the shell holds,
and the service is behind a contract the root sets.

```swift
// Backend.swift, in the layer. The node that calls it dictated the signature.
struct Backend {
    var signup: (_ email: String, _ password: String) async throws -> Void = { _, _ in }
}

extension EnvironmentValues {
    @Entry var backend = Backend()
}

// SignupCore.swift. The core, read off the screen.
struct SignupCore: View {
    @Binding var email: String
    @Binding var password: String
    let isSubmitting: Bool
    let error: String?
    let onSubmit: () -> Void

    var canSubmit: Bool { email.contains("@") && password.count >= 8 && !isSubmitting }

    var body: some View {
        Form {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            if let error { Text(error).foregroundStyle(.red) }
            Button("Sign up", action: onSubmit).disabled(!canSubmit)
        }
    }
}

// Signup.swift. The shell. Loose state, the contract, and the task it holds.
struct Signup: View {
    @Environment(\.backend) private var backend: Backend
    @State private var email = ""
    @State private var password = ""
    @State private var isSubmitting = false
    @State private var error: String?
    @UnstructuredTask private var submit: Task<Void, Never>?

    var body: some View {
        SignupCore(
            email: $email, password: $password,
            isSubmitting: isSubmitting, error: error,
            onSubmit: {
                submit = Task { [backend, email, password, submitting = $isSubmitting, failure = $error] in
                    submitting.wrappedValue = true
                    let failed = (try? await backend.signup(email, password)) == nil
                    guard !Task.isCancelled else { return }
                    submitting.wrappedValue = false
                    failure.wrappedValue = failed ? "Sign up failed" : nil
                }
            })
    }
}

// The root. The service that already exists, wrapped and not touched.
Signup()
    .environment(\.backend, Backend(signup: { [api] email, password in
        try await api.signup(email: email, password: password)
    }))

#Preview("Failed") {
    SignupCore(
        email: .constant("a@b.c"), password: .constant("12345678"),
        isSubmitting: false, error: "Sign up failed", onSubmit: {})
}
```

The failed state is a preview with no network and no typing. A
scenario constructs `SignupCore` with a logging `onSubmit` and reads
`onSubmit` in the log, or hosts `Signup` with a logging `Backend` and
reads `signup` with its payload. `SignupViewModel`, its `@StateObject`, and any `MockAPI` are
deleted. The class `API` is as it was.

## The service is wrapped, not rewritten

A service that holds state, a session, a socket, a database handle, a
token refresher, stays the class it is, behind the contract's closures.
No node reads the handle. It is converted last, or not at all. What converts
is who names it, and after step 6 one file does. Once the service can
leave the app target, it and its wrapper become a package under
`Packages/Dependencies/` that exposes one `inject` modifier.

A closure the root sets is a plain call into the service. It starts no
`Task`. Where the service's work is asynchronous the closure is
`async`, and the node that calls it owns the task.

## The edge with code not yet converted

- **A legacy parent, a converted child.** The parent constructs the
  child and hands it values, bindings, and closures. A closure may be a
  method of the parent's object, `onSave: viewModel.save`. The child
  cannot tell, and nothing in it changes on the day the parent is
  converted.
- **A converted parent, a legacy child.** The parent constructs the
  child as before, object and all, until the child's turn.
- **A contract and a root that is not yet the root.** A contract is set
  at the root from the first node that reads it. Where the app has been
  setting values lower down, that is a finding the map already lists,
  and each conversion moves one contract up.

## What the old habits propose instead

Each of these is the object coming back under another name, and each
breaks a rule `SKILL.md` already states.

- **A `State` struct and a `Logic` struct.** The ViewModel in two
  halves. The struct is a model the feature invented, and the logic
  struct is its methods held one step away.
- **The object kept as an `@Observable` store** that holds only state,
  until the first method is added to it.
- **A phase enum**, loading, loaded, failed, in place of the three
  facts.
- **`Button { Task { await submit() } }`**, copied over from the old
  view.
- **A protocol for the service**, so it can be mocked.
- **Converting the services first, from the bottom up.** The layers are
  the order things were built in. The map's order is authority, and a
  contract's signature comes from the node that calls it, so the nodes
  go first and the cylinders last.
- **A coordinator renamed a router.** Navigation across features is one
  call to a contract.

## When to convert, and when to leave it

Convert a node when a feature is being added to it, when its screen is
being rewritten anyway, or when the owner asks. A screen that works and
that nobody is changing stays as it is, and the next feature is written
the new way beside it. A conversion nobody needs costs time and buys
nothing, and practicality outranks the rule.

## Checklist

- [ ] The node was on the map, and its evidence was declared, before
      its code changed.
- [ ] No object owns the screen's state or its actions. No
      `@StateObject`, `@ObservedObject`, or `@EnvironmentObject` is
      left in the node.
- [ ] Every stored property of the object is a loose `@State`, and no
      struct or enum was invented to hold them.
- [ ] Every service the node calls is a closure on a contract in the
      layer, set at the root, and the service behind it is unchanged.
- [ ] Nothing starts work at creation, and every `Task` is held.
- [ ] The object, its protocol, its mock, and its state-asserting tests
      are deleted in the same commit, and the map is updated in it.
