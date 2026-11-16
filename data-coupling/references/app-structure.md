# App structure: what goes where on disk

Read this when starting an app, or when adding a package, a target, or
a dependency to one. `modules.md` says why the graph has this shape.
This file says where each thing sits, what it may import, and what the
project file looks like. Nothing here is a matter of taste to settle
again per app.

## The tree

```
AddressForm/
  APP-MAP.md                         the whole app, drawn by the checker, then the root's three diagrams
  Maps/
    AddressScreen/MAP.md             one folder per node, named for the node,
    AddressScreen/Save.md            a file per flow, one evidence block each
    AddressScreen/AddressForm/Save.md   each child's inside its parent's; a leaf has flows and no MAP.md
  Packages/
    DataCoupling/                    the layer: Models/ Values/ Enums/ Services/
    AppCore/                         the nodes, their cores, transformers, and rules
      Tests/AppCoreTests/            plain tests of calculations and transformers
    Dependencies/
      AddressFile/                   one package per dependency that does I/O
        Tests/AddressFileTests/      the one integration test of its boundary
  App/
    generate.sh                      the script that writes the Xcode project
    AddressForm.xcodeproj/           its output, one JSON file, committed
    AddressApp/AddressApp.swift      the @main file, the whole app target
    TestHost/main.swift
    UITests/
  .gitignore                         xcuserdata/, *.xcworkspace, DerivedData/, .build/
```

The root of the repository shows what the app is made of, the root
map, the maps, and the packages. The app itself is one thin folder
among them, `App/`, since it is only the composition root. The rest
of the app is `AppCore`, every node from the top one down and the
scenarios, shells and cores alike. It knows no implementation exists,
which makes it the app's core, and the app target, the one place that
builds the live values, is its shell. The Xcode
project is written into `App/` by the script beside it, and both are
committed. The node maps are one folder, `Maps/`, apart from the code,
and `APP-MAP.md` is the one map file at the root. Every package is a
folder under `Packages/`, and every dependency is a folder under
`Packages/Dependencies/`.

## Who sees whom

| Module | Depends on | Its public surface |
|---|---|---|
| `DataCoupling` | swift-core-flow, which it re-exports, and nothing of yours | models, values, enums, contracts with their `@Entry` |
| `AppCore` | `DataCoupling`, and a model-free presentation package if there is one | the top node of its tree, `public` with a `public init()` written out, and `TestScenario` |
| a dependency | `DataCoupling`, platform frameworks, the transport or SDK library it wraps | one `inject` view modifier |
| the app target | `AppCore` and every dependency | nothing |
| the test host | `AppCore`, `CoreFlowUITestHost` | nothing |
| the UI-test bundle | `CoreFlowUITesting`, and `AppCore` to name the cases | nothing |

No dependency imports `AppCore`. No dependency imports another
dependency. `AppCore` imports no dependency. The compiler holds all
three, because each is a package and its manifest lists what it sees.

## One import reaches everything a feature needs

The layer depends on swift-core-flow and re-exports it. `AppCore`
re-exports the layer. Each is one file of one line.

```swift
// Packages/DataCoupling/Sources/DataCoupling/Exports.swift
@_exported import CoreFlow

// Packages/AppCore/Sources/AppCore/Exports.swift
@_exported import DataCoupling
```

An `@_exported import` in one file of a module makes that module
visible in every file of it. So every feature file sees the layer and
the macros and writes neither import, and a dependency that imports
`DataCoupling` has the macros too. The library appears in one manifest,
the layer's. The app target has no such file. It is one source file,
and it imports what it names.

## A package manifest

Every package is `swift-tools-version: 6.4`, the Swift 6 language
mode, platforms iOS 17 and macOS 14. macOS is there only so the plain
tests run under `swift test` on the Mac. Every target that holds views
or contracts carries the main-actor default.

```swift
// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "AddressFile",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "AddressFile", targets: ["AddressFile"])],
    dependencies: [.package(path: "../../DataCoupling")],
    targets: [
        .target(
            name: "AddressFile",
            dependencies: [.product(name: "DataCoupling", package: "DataCoupling")],
            swiftSettings: [.defaultIsolation(MainActor.self)]),
        .testTarget(
            name: "AddressFileTests",
            dependencies: ["AddressFile"],
            swiftSettings: [.defaultIsolation(MainActor.self)]),
    ],
    swiftLanguageModes: [.v6]
)
```

`DataCoupling` lists swift-core-flow and nothing else. `AppCore` lists
`DataCoupling` and has an `AppCoreTests` target. The layer's two lines
for the library are these, its URL and the version, or the path of a
checkout in its place.

```swift
dependencies: [.package(url: "https://github.com/sisoje/swift-core-flow", from: "1.3.0")],
// in the target:
dependencies: [.product(name: "CoreFlow", package: "swift-core-flow")],
```

With the library re-exported, the layer's models and contracts take
`@Flowable`, which writes the public memberwise initializer a type in
a package needs.

## A dependency package

One public declaration, the `inject` function, over an internal
modifier that builds the live value and sets it.

```swift
// Packages/Dependencies/AddressFile/Sources/AddressFile/AddressFile.swift
import DataCoupling
import Foundation
import SwiftUI

public extension View {
    /// Sets `addressService`. The address is written as JSON to a file.
    func injectAddressFile() -> some View {
        modifier(AddressFileInjector())
    }
}

struct AddressFileInjector: ViewModifier {
    func body(content: Content) -> some View {
        content.environment(\.addressService, AddressService(save: { address in
            try write(address, to: FileManager.default.temporaryDirectory)
        }))
    }
}
```

- **The function is named `inject` and the dependency's own name**,
  `injectAddressFile()`, `injectBackend(baseURL:)`. A dependency may
  set several related contracts, and it still has one name. What the
  root supplies is the function's parameters, and each dependency
  has its own. A backend that calls a server takes a base URL. One
  that answers from fixtures takes nothing.
- **The package is not named as the contract's type.** A module and
  a type of one name shadow each other. `AddressService` is the
  contract, so the package is `AddressFile`. Nor is it named as the
  framework it wraps. A package `Photos` that imports `Photos` names
  itself, so it is `PhotoLibrary`.
- **Its logic is internal functions** the closures call, here
  `write(_:to:)`, each taking its inputs as parameters.
- **The modifier's type is named for its package**,
  `AddressFileInjector`. The map checker reads a type by its name, so
  two types of one name in two packages read as one.
- **A derived dependency** declares `@Environment` reads of its
  ingredients on that modifier. Their contracts and entries are in the
  layer, so it imports no other dependency.
- **A failure is thrown.** Work that can fail makes the closure
  `throws`. A dependency does not catch its own failure to hand back a
  string or a default in a result's place. What a failure shows is the
  node's logic, and the node cannot decide it once the failure has been
  dressed as a result.
- **Its test target holds the one integration test of the boundary.**
  The real file is written, the real request is made, once. It proves
  the dependency's own code, what it encodes, builds, and hands to the
  framework. What the framework does with it afterwards is Apple's and
  is not tested. A dependency over SwiftData is tested against an
  in-memory container, and its test does not close a store on disk and
  open it again. Whether its insert did its job, the row fetched back
  from that container, is the dependency's own code and is tested,
  even where that code is one line. The test reads the context
  directly, `context.fetch(FetchDescriptor<Address>())`, not through
  `@Query`, so it is a plain test with no view.

## The app target

The app is one file. It owns the root's state, constructs the
top node of `AppCore`, and applies the `inject` chain inline. It
imports `AppCore` and each dependency by name.

```swift
// App/AddressApp/AddressApp.swift
import AddressFile
import AppCore
import SwiftUI

@main
struct AddressApp: App {
    var body: some Scene {
        WindowGroup {
            AddressScreen()
                .injectAddressFile()
        }
    }
}
```

## The project file

An app is an Xcode project, not a bare package. The project is the
output of `App/generate.sh`, a script that deletes it and writes it
again from nothing with `xcrun xcodeproj`, the tool that ships with
Xcode. It is not edited by hand and not produced by a third-party
generator. The xcode-project skill beside this one teaches the tool,
every command and the facts that bite. Read it before writing the
script.

The script for this app is that skill's own example. In short:

```sh
#!/bin/sh
set -e
cd "$(dirname "$0")"
rm -rf AddressForm.xcodeproj
xcrun xcodeproj init AddressForm.xcodeproj
# project settings: SDKROOT iphoneos, IPHONEOS_DEPLOYMENT_TARGET 17.0,
# SWIFT_VERSION 6.0, CODE_SIGNING_ALLOWED NO, ALWAYS_SEARCH_USER_PATHS NO,
# the bundle identifier

xcrun xcodeproj pkg add-local ../Packages/DataCoupling
xcrun xcodeproj pkg add-local ../Packages/AppCore
xcrun xcodeproj pkg add-local ../Packages/Dependencies/AddressFile
xcrun xcodeproj pkg add https://github.com/sisoje/swift-core-flow --from 1.3.0

application() {   # a target, its phases, its folder, the main-actor default, AppCore
    xcrun xcodeproj target add "$1" --product-type application
    xcrun xcodeproj target phase add sources --target "$1"
    xcrun xcodeproj target phase add frameworks --target "$1"
    xcrun xcodeproj group add "$1" --filesystem-path "$1"
    xcrun xcodeproj group include --group "$1" --target "$1"
    xcrun xcodeproj setting set SWIFT_DEFAULT_ACTOR_ISOLATION MainActor --target "$1"
    xcrun xcodeproj pkg link AppCore --package AppCore --target "$1"
}

application AddressApp      # links every dependency: pkg link AddressFile ...
application TestHost        # links the host product: pkg link CoreFlowUITestHost ...
# UITests: a ui-test-bundle that depends on TestHost and links
# AppCore and CoreFlowUITesting, without the main-actor default
# last line: predictable ids, so a second run changes nothing
```

Three targets and no other. `AddressApp` is the folder `App/AddressApp`
and links `AppCore` and every dependency package. `TestHost` is the
folder `App/TestHost` and links `AppCore` and the host product.
`UITests` is the folder `App/UITests`, runs against the test host, and
links `AppCore` and the testing product. The folders are
synchronized with disk, so a new file needs no change to the script. A
new dependency is one `pkg add-local` and one `pkg link`.

No scheme is written. Xcode creates one per target. From `App/`, the
app builds and the evidence tests run with these two commands, the
second building the test host first.

```sh
xcodebuild -scheme AddressApp -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath DerivedData build
xcodebuild test -scheme UITests -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath DerivedData
```

The destination names a simulator that is installed, whichever the
brief or the machine gives.

## The test side

- **The checker** runs from the repo root over every source folder,
  `python3 <mapping skill>/scripts/mapcheck.py . --sources Packages App`,
  and passes at zero errors and nothing unverified. `--write` is added
  after a map changes, to redraw the whole-app diagram. It skips build
  folders, `.build`, `DerivedData`, `SourcePackages`.
- **Plain tests** of pure calculations and transformers are in
  `AppCore/Tests/`, run with `swift test`. No view runtime. The
  package builds for the Mac to run them, so a modifier that exists
  only on iOS sits behind `#if os(iOS)`.
- **The boundary's integration test** is in the dependency's own
  package, run with `swift test` there. It calls the internal function
  the closure calls, `write(_:to:)`, through `@testable import`, and
  the real file is written.
- **Evidence tests** are the UI-test bundle, one test class per node,
  one method per evidence block. The bundle's application is the test
  host, whose whole `main.swift` is `HostApp<TestScenario>.main()`.
  They run in the iPhone simulator, not against a Mac app, and
  nothing scripts the Mac's own interface.
- **`TestScenario`** is public in `AppCore`, in its own file, and the
  bundle links `AppCore` to name its cases.
- **A test that drives the system photo picker** needs a photo in the
  simulator's library first, `xcrun simctl addmedia booted <file>`.
  Its photo cells are `app.images` with the identifier
  `PXGGridLayout-Info`. The first of `app.images` is the picker's own
  icon, not a photo.

## Where a file goes

- A node is one file named for the node. A hand-written core is a file
  of its own, and so is a transformer.
- A scenario is a file of its own, named for the scenario, in the
  node's folder beside the view. The `#Preview` lines that show the
  scenarios are in the view's file.
- A generated `Core` has no file.
- A contract is one file in the layer's `Services/`, with its `@Entry`.
- A dependency is one package, and a small one is one source file.

## Checklist

- [ ] `Packages/DataCoupling`, `Packages/AppCore`, and one package per
      I/O dependency under `Packages/Dependencies/`.
- [ ] The layer re-exports swift-core-flow, and `AppCore` re-exports
      the layer. No feature file imports either by name.
- [ ] No dependency's manifest lists `AppCore` or another dependency.
- [ ] Each dependency has exactly one public declaration, its `inject`
      function, and a test target with its integration test.
- [ ] The app target is one `@main` file in `App/`, with no exports
      file.
- [ ] `APP-MAP.md` is at the repo root, and every node's map is under
      `Maps/`, one folder per node.
- [ ] The project is written by `App/generate.sh` with `xcrun
      xcodeproj`, both are committed, and the test host and the
      UI-test bundle sit beside the app target.
