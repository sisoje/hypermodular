---
name: xcode-project
description: >
  Creating and changing an Xcode project from the command line with
  Apple's own `xcrun xcodeproj` tool (Xcode 27.2 or later). The project
  is the output of a `generate.sh` that rewrites it from nothing:
  targets and their build phases, folders synchronized with disk, local
  and remote Swift packages, build settings, predictable ids, and
  building and testing with the schemes Xcode creates. Use when
  creating an app's Xcode project, adding a target, a folder, a
  package, or a build setting to one, when a project must be
  reproducible from a script, or when xcodegen, project.yml, Tuist, or
  editing project.pbxproj by hand comes up.
---

# xcode-project: the project is the output of a script

An Xcode project is not edited by hand and not produced by a
third-party generator. A shell script beside it, `generate.sh`, deletes
the project and writes it again from nothing with `xcrun xcodeproj`,
the tool that ships with Xcode. The script is the source. The project
file is its output. Both are committed, so the repository opens in
Xcode without anything being run first.

Most agents have not seen this tool. Do not guess its commands from
other tools. Everything needed is on this page, and `xcrun xcodeproj
<subcommand> --help` prints the rest.

## What the tool is

`xcrun xcodeproj` has six subcommands: `init`, `setting`, `target`,
`group`, `config`, and `pkg`. It reads and writes the project file and
nothing else. It does not write a workspace, a scheme, or the contents of
an `.xcconfig` file.

The project it creates is one JSON file, `Name.xcodeproj/project.xcproj`.
For an app with two targets and a test bundle it is about four
kilobytes. Xcode 27.0 or later opens that format. `init` needs the tool
of Xcode 27.2.

Every command takes `--project <path>`. Without it the tool uses the
one `.xcodeproj` in the current directory, which is why the script
moves to its own folder first.

## The script

This is the whole project of an iPhone app with a test host and a
UI-test bundle, over three local packages and one remote one. It was
built and its UI tests were run from exactly this text.

```sh
#!/bin/sh
# Rewrites AddressForm.xcodeproj from nothing with the `xcodeproj` tool that
# ships with Xcode 27.2 or later. Run it after changing this file.
set -e
cd "$(dirname "$0")"
rm -rf AddressForm.xcodeproj
xcrun xcodeproj init AddressForm.xcodeproj

# The project: an iPhone app, the Swift 6 language mode, no signing.
xcrun xcodeproj setting set SDKROOT iphoneos
xcrun xcodeproj setting set IPHONEOS_DEPLOYMENT_TARGET 17.0
xcrun xcodeproj setting set TARGETED_DEVICE_FAMILY 1
xcrun xcodeproj setting set SWIFT_VERSION 6.0
xcrun xcodeproj setting set CODE_SIGNING_ALLOWED NO
xcrun xcodeproj setting set ALWAYS_SEARCH_USER_PATHS NO
xcrun xcodeproj setting set PRODUCT_BUNDLE_IDENTIFIER 'dev.addressform.$(TARGET_NAME)'

# The packages. The first three are local, each a path relative to this
# folder. swift-core-flow is remote, its URL and the version the app needs.
xcrun xcodeproj pkg add-local ../Packages/DataCoupling
xcrun xcodeproj pkg add-local ../Packages/AppCore
xcrun xcodeproj pkg add-local ../Packages/Dependencies/AddressFile
xcrun xcodeproj pkg add https://github.com/sisoje/swift-core-flow --from 1.4.2

# An application: the target, its two phases, the folder of its own name
# synchronized with disk, the main-actor default, and AppCore.
application() {
    xcrun xcodeproj target add "$1" --product-type application
    xcrun xcodeproj target phase add sources --target "$1"
    xcrun xcodeproj target phase add frameworks --target "$1"
    xcrun xcodeproj group add "$1" --filesystem-path "$1"
    xcrun xcodeproj group include --group "$1" --target "$1"
    xcrun xcodeproj setting set SWIFT_DEFAULT_ACTOR_ISOLATION MainActor --target "$1"
    xcrun xcodeproj setting set INFOPLIST_KEY_UILaunchScreen_Generation YES --target "$1"
    xcrun xcodeproj pkg link AppCore --package AppCore --target "$1"
}

# The app: AppCore and every dependency.
application AddressApp
xcrun xcodeproj pkg link AddressFile --package AddressFile --target AddressApp

# The test host: AppCore and the host product.
application TestHost
xcrun xcodeproj pkg link CoreFlowUITestHost --package swift-core-flow --target TestHost

# The UI tests: run against the test host, never with the main-actor default.
xcrun xcodeproj target add UITests --product-type ui-test-bundle
xcrun xcodeproj target phase add sources --target UITests
xcrun xcodeproj target phase add frameworks --target UITests
xcrun xcodeproj target add-dependency UITests TestHost
xcrun xcodeproj setting set TEST_TARGET_NAME TestHost --target UITests
xcrun xcodeproj group add UITests --filesystem-path UITests
xcrun xcodeproj group include --group UITests --target UITests
xcrun xcodeproj pkg link AppCore --package AppCore --target UITests
xcrun xcodeproj pkg link CoreFlowUITesting --package swift-core-flow --target UITests

# Predictable ids, so a regeneration is byte-identical: a target's id is its name.
perl -0pi -e 's/"name": "(\w+)",(\s*)"id": "[0-9A-F]{24}"/"name": "$1",$2"id": "$1"/g; s/ "id": "[0-9A-F]{24}",//g' AddressForm.xcodeproj/project.xcproj
```

Read it in five blocks.

1. **Start from nothing.** `rm -rf` and `init`. The script does
   not patch an existing project, so the project cannot hold a
   setting the script does not show.
2. **Project settings.** `setting set KEY VALUE` with no `--target`
   writes to the project, and every target inherits it.
3. **Packages.** `pkg add-local <path>` names a local package once.
   The path is relative to the project's folder.
4. **Targets.** A shell function holds what several targets share. One
   call makes one target.
5. **Ids.** The last line replaces the random ids the tool wrote with
   the targets' names.

## What each command does, and what it does not

| Command | What it does |
|---|---|
| `init Name.xcodeproj` | an empty project with Debug and Release, no target, no file. The name is the path's basename |
| `setting set KEY VALUE [--target T] [--config C]` | one build setting, written verbatim |
| `setting set-multi KEY V1 V2 ...` | a setting that is a list, `OTHER_LDFLAGS`, `FRAMEWORK_SEARCH_PATHS` |
| `setting get`, `setting list`, `setting unset` | read or remove one |
| `target add NAME --product-type TYPE` | a blank target with no build phase |
| `target phase add KIND --target T` | a build phase, `sources`, `frameworks`, `resources`, `headers` |
| `target add-dependency A B` | B builds before A |
| `target list`, `target info --target T` | what the project holds now |
| `group add NAME --filesystem-path DIR` | a folder synchronized with disk |
| `group include --group NAME --target T` | every file of that folder belongs to the target |
| `pkg add-local PATH` | a local package |
| `pkg add URL --from 1.2.0` | a remote package, with exactly one version rule |
| `pkg link PRODUCT --package IDENTITY --target T` | one product linked into one target |
| `pkg list` | the packages and which target links which product |

Product types are short names: `application`, `framework`,
`library.static`, `library.dynamic`, `bundle`, `unit-test-bundle`,
`ui-test-bundle`, `tool`, `app-extension`.

## The facts that bite

- **A new target has no build phases.** `target add` creates it blank.
  Add `sources` and `frameworks` before including a folder or linking a
  product. `pkg link` is refused on a target with no `frameworks`
  phase.
- **A new target has two settings and no more.** `PRODUCT_NAME` is
  `$(TARGET_NAME)`, and `GENERATE_INFOPLIST_FILE` is `YES` for an
  application, a framework, a bundle, and a test bundle. Everything
  else is the script's to set. A new project has none of the settings
  Xcode's own templates add, so the script sets
  `ALWAYS_SEARCH_USER_PATHS` to `NO`. Without it every build warns
  that the traditional header map is no longer supported. An
  `Info.plist` key Xcode knows is a build setting too, named
  `INFOPLIST_KEY_` and then the key, and is set the same way. A usage
  description is one, `INFOPLIST_KEY_NSPhotoLibraryUsageDescription`.
- **A synchronized folder is named for its directory.** In
  `group add NAME --filesystem-path DIR`, `NAME` has to equal the
  basename of `DIR`, or the command is refused. A relative `DIR` is
  resolved against the parent group's own directory, and at the top
  level that is the project's folder.
- **A synchronized folder needs no upkeep.** A file added to the
  directory is in the target at once. The script changes only when a
  target, a folder, a package, or a setting changes.
- **A package is addressed by its identity.** For a local package that
  is its directory's name, `--package AppCore`. For a remote one it is
  the repository's name, `--package swift-core-flow`. `pkg list` prints
  them.
- **A product is linked per target.** `pkg add-local` alone links
  nothing. Each target that imports a product needs its own `pkg link`.
- **`setting set` writes the value as it stands.** No substitution, no
  quoting. Put `$(TARGET_NAME)` in single quotes so the shell leaves it
  alone. A value that begins with `-` needs a bare `--` before it,
  `setting set WARNING_CFLAGS -- -Wall`. A list-valued key is refused
  and needs `set-multi`.
- **No scheme is written.** Xcode creates one scheme per target the
  first time the project is read. Build with the target's name,
  `xcodebuild -scheme AddressApp -destination 'platform=iOS
  Simulator,name=iPhone 18 Pro' build`. Run UI tests with the test
  bundle's name, `xcodebuild test -scheme UITests` and the same
  destination, which builds the application it depends on first. `xcodebuild -list` may leave the
  test bundle's scheme out of its list, and the scheme still runs.
  Pass `-derivedDataPath DerivedData` beside the project, so a build
  does not pick up the products of another checkout.
- **The ids are made predictable on purpose.** With the last line, two
  runs of the script give the same bytes, so the committed file changes
  only when the script does. Xcode writes its own ids back when it
  saves the project. Run the script again after Xcode has had the
  project open, before committing.

## What is committed

`generate.sh` and `Name.xcodeproj/project.xcproj` are committed. Xcode
puts two more things inside the project folder, and both are ignored.

```
xcuserdata/
*.xcworkspace
DerivedData/
```

## A worked example

swift-core-flow builds its own hosted test project this way.
`CoreFlowHosted/generate.sh` in
[sisoje/swift-core-flow](https://github.com/sisoje/swift-core-flow) is
a project for several platforms at once, with `SDKROOT auto` and
`SUPPORTED_PLATFORMS`, an application, and a UI-test bundle, and the
root `test.sh` there runs it with the test bundle's scheme. An app laid
out by the hypermodular method puts the script at `App/generate.sh`,
and the data-coupling skill's `references/app-structure.md` says what
the targets are.

## Do not

- **Edit `project.xcproj` or a `.pbxproj` by hand.** Change the script
  and run it.
- **Add a third-party generator.** No xcodegen, no `project.yml`, no
  Tuist. The tool is already installed with Xcode.
- **Patch a project in place from the script.** It starts with
  `rm -rf` and `init`, every time.
- **List source files.** A folder is synchronized, not enumerated.
- **Write a scheme file** for what the target's own scheme already
  does.

## Checklist

- [ ] `generate.sh` sits beside the project it writes and starts from
      `rm -rf` and `init`.
- [ ] Every target has its `sources` and `frameworks` phases before
      anything is included or linked.
- [ ] Every source folder is a synchronized group named for its
      directory.
- [ ] Every product a target imports is linked into that target.
- [ ] The last line makes the ids predictable, and a second run
      changes nothing.
- [ ] The script and `project.xcproj` are committed. `xcuserdata/` and
      the inner workspace are ignored.
