# App structure: what goes where on disk

Read this when starting an app, or when adding a package, a target, or
a dependency to one. `modules.md` says why the graph has this shape.
This file says where each thing sits, what it may import, and what the
project file looks like. Nothing here is a matter of taste to settle
again per app.

## The tree

```
AddressForm/
  APP-MAP.md                         the root's three diagrams
  AddressScreen/MAP.md               one folder per node, named for the node,
  AddressScreen/AddressForm/MAP.md   each child's inside its parent's
  Packages/
    DataCoupling/                    the layer: Models/ Values/ Enums/ Services/
    Features/                        the nodes, their cores, transformers, and rules
      Tests/FeaturesTests/           plain tests of calculations and transformers
    Dependencies/
      AddressFile/                   one package per dependency that does I/O
        Tests/AddressFileTests/      the one integration test of its boundary
      AddressPrint/                  a second answer to the same contract
  Sources/
    App/                             the one @main file, shared by every app target
    AddressApp/Exports.swift         this target's picks
    AddressAppFixtures/Exports.swift
    AddressTestHost/main.swift
    AddressUITests/
  project.yml
```

The map tree stands at the repo root, apart from the packages. Every
package is a folder under `Packages/`, and every dependency is a
folder under `Packages/Dependencies/`.

## Who sees whom

| Module | Depends on | Its public surface |
|---|---|---|
| `DataCoupling` | nothing of yours | models, values, enums, contracts with their `@Entry` |
| `Features` | `DataCoupling`, swift-core-flow where it is used, a model-free presentation package if there is one | the top node of its tree, and `TestScenario` |
| a dependency | `DataCoupling`, platform frameworks, the transport or SDK library it wraps | one `inject` view modifier |
| an app target | `Features` and the dependencies it picked | nothing |
| the test host | `Features`, `CoreFlowUITestHost` | nothing |
| the UI-test bundle | `CoreFlowUITesting`, and `Features` to name the cases | nothing |

No dependency imports `Features`. No dependency imports another
dependency. `Features` imports no dependency. The compiler holds all
three, because each is a package and its manifest lists what it sees.

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

`DataCoupling` has no `dependencies`. `Features` adds swift-core-flow
and a `FeaturesTests` target.

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
    func injectAddressService() -> some View {
        modifier(Injector())
    }
}

struct Injector: ViewModifier {
    func body(content: Content) -> some View {
        content.environment(\.addressService, AddressService(save: { address in
            try write(address, to: FileManager.default.temporaryDirectory)
        }))
    }
}
```

- **The function is named `inject` and the contract's name**,
  `injectAddressService()`, `injectBackend(baseURL:)`. What the root
  must supply is its parameters.
- **The package is named for how it answers**, `AddressFile`,
  `AddressPrint`, `Backend`, `SyncEngine`. It is never named as the
  contract's type. A module and a type of one name shadow each other.
- **Its logic is internal functions** the closures call, here
  `write(_:to:)`, each taking its inputs as parameters.
- **A derived dependency** declares `@Environment` reads of its
  ingredients on the `Injector`. Their contracts and entries are in the
  layer, so it imports no other dependency.
- **Its test target holds the one integration test of the boundary.**
  The real file is written, the real request is made, once.

## Two answers to one contract

A second package may answer the same contract, with the same `inject`
function, the same name and the same parameters.

```swift
// Packages/Dependencies/AddressPrint/Sources/AddressPrint/AddressPrint.swift
import DataCoupling
import SwiftUI

public extension View {
    /// Sets `addressService`. The address is printed and nothing is stored.
    func injectAddressService() -> some View {
        modifier(Injector())
    }
}
```

The two are never linked into one target. A target picks one.

## The app targets

The `@main` file is one file, shared by every app target. It owns the
root's state, constructs the features' top node, and applies the
`inject` chain inline. It imports no dependency by name.

```swift
// Sources/App/AddressApp.swift
import SwiftUI

@main
struct AddressApp: App {
    var body: some Scene {
        WindowGroup {
            AddressScreen()
                .injectAddressService()
        }
    }
}
```

Each app target adds one file that names what it picked. An
`@_exported import` in one file of a target makes that module visible
in every file of the target, so the shared file needs no import of its
own.

```swift
// Sources/AddressApp/Exports.swift
@_exported import AddressFile
@_exported import Features

// Sources/AddressAppFixtures/Exports.swift
@_exported import AddressPrint
@_exported import Features
```

Production against fixtures is which packages a target links, with no
line of the app's source changed.

## The project file

An app is an Xcode project generated by xcodegen from `project.yml`,
never a bare package. Application targets carry the main-actor default.
The UI-test bundle never does.

```yaml
name: AddressForm
options:
  bundleIdPrefix: dev.addressform
  deploymentTarget:
    iOS: "17.0"
settings:
  base:
    SWIFT_VERSION: "6.0"
    TARGETED_DEVICE_FAMILY: "1"
    GENERATE_INFOPLIST_FILE: YES
    CODE_SIGNING_ALLOWED: NO
packages:
  DataCoupling: { path: Packages/DataCoupling }
  Features: { path: Packages/Features }
  AddressFile: { path: Packages/Dependencies/AddressFile }
  AddressPrint: { path: Packages/Dependencies/AddressPrint }
  CoreFlow: { path: ../CoreFlow }
targets:
  AddressApp:
    type: application
    platform: iOS
    sources: [Sources/App, Sources/AddressApp]
    dependencies:
      - package: Features
      - package: AddressFile
    settings:
      base:
        SWIFT_DEFAULT_ACTOR_ISOLATION: MainActor
        INFOPLIST_KEY_UILaunchScreen_Generation: YES
  AddressAppFixtures:
    type: application
    platform: iOS
    sources: [Sources/App, Sources/AddressAppFixtures]
    dependencies:
      - package: Features
      - package: AddressPrint
    settings:
      base:
        SWIFT_DEFAULT_ACTOR_ISOLATION: MainActor
        INFOPLIST_KEY_UILaunchScreen_Generation: YES
  AddressTestHost:
    type: application
    platform: iOS
    sources: [Sources/AddressTestHost]
    dependencies:
      - package: Features
      - package: CoreFlow
        product: CoreFlow
      - package: CoreFlow
        product: CoreFlowUITestHost
    settings:
      base:
        SWIFT_DEFAULT_ACTOR_ISOLATION: MainActor
        INFOPLIST_KEY_UILaunchScreen_Generation: YES
  AddressUITests:
    type: bundle.ui-testing
    platform: iOS
    sources: [Sources/AddressUITests]
    dependencies:
      - target: AddressTestHost
      - package: Features
      - package: CoreFlow
        product: CoreFlowUITesting
    settings:
      base:
        TEST_TARGET_NAME: AddressTestHost
schemes:
  AddressApp:
    build: { targets: { AddressApp: all } }
  AddressAppFixtures:
    build: { targets: { AddressAppFixtures: all } }
  AddressEvidence:
    build: { targets: { AddressTestHost: all, AddressUITests: [test] } }
    test: { targets: [AddressUITests] }
```

## The test side

- **Plain tests** of pure calculations and transformers are in
  `Features/Tests/`, run with `swift test`. No view runtime.
- **The boundary's integration test** is in the dependency's own
  package, run with `swift test` there.
- **Evidence tests** are the UI-test bundle, one test class per node,
  one method per evidence block. The bundle's application is the test
  host, whose whole `main.swift` is `HostApp<TestScenario>.main()`.
  They run in the iPhone simulator, never against a Mac app, and
  nothing scripts the Mac's own interface.
- **`TestScenario`** is public in `Features`, in its own file, and the
  bundle links `Features` to name its cases.

## Where a file goes

- A node is one file named for the node. A hand-written core is a file
  of its own, and so is a transformer.
- The preview chain lives in one file with the view that is there, the
  scenario that stages it and the `#Preview` that shows the scenario.
- A generated `Core` has no file.
- A contract is one file in the layer's `Services/`, with its `@Entry`.
- A dependency is one package, and a small one is one source file.

## Checklist

- [ ] `Packages/DataCoupling`, `Packages/Features`, and one package per
      I/O dependency under `Packages/Dependencies/`.
- [ ] No dependency's manifest lists `Features` or another dependency.
- [ ] Each dependency has exactly one public declaration, its `inject`
      function, and a test target with its integration test.
- [ ] One `@main` file, importing no dependency by name. Each app
      target has its own `Exports.swift`.
- [ ] The map folders are at the repo root, one per node.
- [ ] The project is generated from `project.yml`, with the test host
      and the UI-test bundle beside the app targets.
