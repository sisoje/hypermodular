# TODO

- **DONE: validation run, findings recorded.** CoreFlowExample mapped
  with the skill as-is. `hypermodular/references/coreflow-example-validation.md`
  holds the maps, three doctrine passes, and six findings (F1 two roots
  and unmounted components, F2 decision values with no contract line,
  F3 parent-supplied callbacks, F4 modifier hosts, F5 `@AppStorage`
  naming tension, F6 wrapper-name collisions). Ruled and folded into
  `SKILL.md`. See "Rulings applied" at the end of the reference. F5 is
  ruled in the Vocabulary table: no cylinder, the `@` line is the claim.

- **DONE: Diagram 4 validated, findings recorded.** Evidence as a
  `sequenceDiagram` per acceptance criterion (in-arrows are the when,
  out-arrows the log, dashed arrows supplied data, `loop` a count
  unnamed, `Note` silence). All eight CoreFlowExample logs transcribe
  and render (mermaid 11.16.0); Part 2 of the same reference file. Six
  new findings: F7 "who fired it" mispredicts and "whose source of
  truth" predicts; F8 leaves with evidence get a MAP.md; F9 F3's bare
  `· name` is now load-bearing; F10 property target versus wrapper
  label (F6 with teeth); F11 the registry check as three set
  comparisons; F12 mermaid reserved words (`title`!) must be quoted.
  Ruled and folded into `SKILL.md` as Diagram 4: optional iff own state
  only, `Evidence:` as the header word. Still open from it:
  - **F11, code-side half.** `scripts/mapcheck.py` covers everything
    the maps alone can verify. Still missing: every call in a node's
    Swift appears on its label; bare evidence targets are real stored
    properties. Built 2026-11-09 as `--sources <dir> ...`, after three
    reviews named it the one thing the HYPERLAMBDA notes wanted that
    was still unbuilt: each node matched to the Swift type of its
    name, the label derived from the type's body by a few textual
    patterns, compared both ways; bare evidence targets checked against
    stored properties; `@AppStorage` below the root an error (F32); a
    view on no map reading a cylinder a warning. Fixtures gained Swift
    stubs, six code findings planted in `broken/`. On the book app it
    verified all four formerly unverified targets with zero findings,
    then caught every planted breach in a mutation pass. Plain Python
    over the text, no SwiftSyntax, by the owner's choice.
  - **`Parent->>Node` stimulus.** Needs real material (a parent handing
    down a new value mid-scenario) before it is a rule. Two readings: a
    new parent value is a new *given* (the node dies in the wave and is
    re-created; "the network is reactive so the nodes don't have to
    be"), or an `.onChange(of: input)` reaction makes it a genuine
    *when*. `mapcheck.py` warns on it, never errors, until ruled.
  - **Flowchart reserved words.** `end` and the like as node ids,
    untested.

- **Aligned with the published manifesto** (*TDD: Death by a Thousand
  Mocks*, 2026-08): authority axis in rule 1, mock depth defined, a
  cylinder is a signature ("eventually"), refactor-stability as why the
  log is the contract, "constructible from literals", and the example
  tree reshaped to the article's lifted BookShelf (Library holds the
  fetch and the store; the shelf takes a value, a binding, a callback).
  The article's example is the better one. The earlier in-view sort was
  a hidden computation the evidence would have had to describe.

- **DONE: the second skill.** `data-coupling/` is the code side of the
  method, beside the maps: `SKILL.md` (the rule, model, lift, cut, test,
  layer, do-not list, the articles' vocabulary) and four references,
  `data-flow.md`, `shell-core.md`, `testing.md`, `modules.md`. Every
  paragraph has a source: the masterclass, the method article, the
  swift-core-flow README, or the module rules of a shipped data-coupled
  app written in general form. The mapping skill no longer restates
  environment-value or shell/core doctrine. It links. Its word for dependencies entering the flow is "set at the root". The
  method article uses "injection" only to reject it, in the OO sense;
  the masterclass says "injected boundaries" for the cut. The skills
  keep the mapping skill's own phrase.

- **DONE: the code skill read cold by five models** (2026-11-06; two
  Claude tiers, Codex, a local 27B). Six questions, a `Favorites`
  design, a confusion list, from `data-coupling/SKILL.md` alone. Every
  run answered six of six. Every confusion that named a missing or
  misleading sentence was fixed in the same commit: the entry format,
  where a closure enters, the test as the hosted scenario, the
  environment as a reference, the store with methods, the what-if. The
  prompt is `data-coupling/scripts/comprehension-prompt.md`; rerun it
  after any doctrine change. How to run it is in `AGENTS.md` under
  "Prose".

- **Notes files removed** in the repo cleanup: `COREFLOW.md` (a
  snapshot of CoreFlow at `d065fd7`, 140 commits stale, describing the
  since-removed CoreFlowExample) and `HYPERLAMBDA.md` (the argument for
  the map as a verified slot registry, in `notation.md` and the
  checker, except the code-side half of that check, F11, still
  unwritten). Both are in git history. What was worth keeping has
  landed or is listed under F11.
  "Material, not framework" and "Cooper inherited, not refuted" are one
  sentence each in `hypermodular/SKILL.md` and `references/evidence.md`.
  CoreFlow's mechanics are in `data-coupling/references/shell-core.md`
  and `testing.md`, written from the current README. The regeneration
  loop ("maps replace the behavioral half of a spec") stays recorded
  here only: a proof mechanism, not run, and not this repo's to run.

- **Open, from a fresh agent's review (2026-11-05).** Three rulings
  and one notation gap.
  - **F21, a write through a binding inside a dependency.** A node
    writes `settings.city`, a binding the root built over its own
    `@AppStorage` and set into the environment. The write logs like any
    binding write; the only question was the spelling on the label.
    Ruled 2026-11-09: the `$` kind takes a path, `· $settings.city`,
    `settings` is a cylinder, the evidence names it as the label does,
    and the checker requires a block that writes it, as for
    `· $sortByAuthor`. The second Garden pass had dodged this with
    `@AppStorage("city")` in two nodes, which F32 now forbids.
  - **F22, who may set a value below the root.** The mapping law says
    the root only, and a value set below it is a finding. Who said no:
    this skill, and only this skill. The sentence is the mapping skill's
    own (`SKILL.md`, the depth-1 law; `notation.md`, "a second arrow
    into the box means a value was set below the root";
    `reverse-engineering.md`, "every place a service enters the
    environment below the root is a finding"), stated since the initial
    commit, `e9bca86`, "injection enters only at the root", and
    restated 2026-11-04. The
    masterclass and the method article do not state it, and the
    manifesto never names a root. The app rules this skill was distilled
    from say override at any subtree, one screen included. The skills
    now say previews and scenarios may. Ruled 2026-11-09: a shipped
    screen may not. The root is the root of the tree that is running,
    the app's `@main`, a scenario, a preview; each sets every value its
    tree reads and nothing below it sets any. Previews and scenarios are
    instances of the law, not exceptions, and a shipped screen setting a
    live value is the finding the checker already reports. Applied to
    `hypermodular/SKILL.md`, Diagram 3. Material, 2026-11-09: the app the rule was distilled from
    says in its rules file that a host wires the live store and that
    any subtree may override, and its shipped code does neither. The
    host's own comment says the live service comes from the app above
    and the host holds no IO, and the only `.environment(...)` below
    the root in its feature package is inside a `#Preview`. The rule
    text is stale; the code sets live values at the root only.
  - **F23, may a core read `@Environment`. Ruled 2026-11-05: yes.
    CoreFlow is correct.** An environment value holds no state of its
    own. Like a `@Binding`, it is a reference to a value an ancestor
    owns, set from above and replaced from above, so it is data in, not
    a source of truth and not machinery. Wrappers divide in three
    (sources, references, machinery), and the core reads a reference
    as it reads a binding. The one by-hand exception is Apple's sealed
    actions, `\.dismiss` and `\.openURL`, which nothing can build from
    above, so by hand the shell reads them and hands the core a
    closure; `@Shell` logs them with `@TestEnvironment`. Applied to
    `data-coupling/SKILL.md`, `data-flow.md`, `shell-core.md`. The
    record of the disagreement, kept because the articles still say
    otherwise. Who said no: both articles. The masterclass, extraction rule 3: "Machinery stays in
    the shell. It owns the gestures, the focus, the environment, and
    passes the core plain values", and on wrappers: "`@Environment` is
    the edge case. It carries data, but ambiently ... so it groups with
    machinery, not with the sources of truth". The method article, "Plug
    in the shell": "the shell reads a capability with `@Environment` and
    hands the core its closures ... The core's consumption is named at
    an initializer; the shell owns the one ambient read". Who said yes:
    CoreFlow's README copies `@Environment` onto `Core` verbatim and
    mocks it with `.environment(...)`, and the app rules say the core
    may freely use `@Binding` and `@Environment`. The articles' sentence
    was about naming the read at an initializer, and `.environment(...)`
    on a scenario names it as well as a constructor argument does.
    Consequence, ruled 2026-11-06: a core that reads the environment is
    tested hosted, through the scenario and the real runtime, which is
    the method's test anyway. Direct construction in a unit bundle sees
    the `@Entry` defaults and has almost no value. Environment entries
    belong to the data coupling layer.
  - **F24, the test host on the map.** The mapping law says one tree
    per `@main`, and the data-coupling skill says every app gets a
    second, test-only `@main`. The arena run proposed "one tree per
    shipped `@main`; a test host that selects scenarios is furniture, not
    a root", and it was never adopted. Unruled; the checker will demand
    a tree for the host until it is. Material, 2026-11-09: a cold agent
    running the engine prompt with swift-core-flow built
    `HabitsTestHost`, a second `@main` of one line, and left it off
    `APP-MAP.md`, reading the host as not a tree. The checker, which
    cannot see `@main`, said nothing. Ruled 2026-11-09: one tree per
    shipped `@main`; a test host that renders scenarios is not a tree
    and is drawn nowhere. One word, "shipped", in `notation.md`,
    `reverse-engineering.md`, and `AGENTS.md`.
  - **F25, a text draft under `@Shell`.** `@Shell` turns every private
    `@State` into `@TestState`, so a search field's draft logs every
    keystroke, and Search's block names only `isLoading`, `search`,
    `isLoading`, `error`. Two honest forms. The block gains a `loop` of
    `query` writes before the submit, which is "record the behavior
    as-is" and changes the map in both copies. Or the draft lives in a
    furniture view outside the cut, handing the text back through a
    closure, which keeps the map and moves the field's state one node
    down. Material, 2026-11-09: a cold agent rebuilding the book app on
    swift-core-flow, told the maps were fixed, chose the furniture form
    and proposed the loop. Ruled 2026-11-09: the furniture form. A draft
    no criterion names lives in the smallest view that edits it, below
    the core; under `@Shell` what the core owns is what its blocks
    declare. Applied to `data-coupling/SKILL.md`.
  - **F26, where a pure calculation is tested.** The Garden run's
    central behavior, plants sorted by how soon they need water, is a
    pure function of the plants and the day. The screen order is the
    aftermath and may not be asserted; a core constructed in a unit
    bundle proves almost nothing. A cold agent left the order untested.
    Ruled 2026-11-09, three readers agreeing (Opus, Codex Astra, a
    fresh Sonnet): the unit-bundle warning is about cores reading the
    environment; a pure calculation gets a plain test with literals;
    a sort or filter the store can perform is the query's job, proven
    at the shell with a seeded in-memory container; the hosted scenario
    still proves the core reacts to the sort state. Applied to
    `data-coupling/SKILL.md` and the swift-core-flow skill.
  - **F27, Apple's sealed actions on the label.** `\.dismiss` is a call
    the node makes, but the label grammar has no line for it, no
    cylinder sets it, and `@Shell` logs it as `dismiss`. The cold agent
    routed it through `navService.closeAdd()` instead. Ruled
    2026-11-09, the other way: a sealed action is a boundary call the
    node makes. It is a call line by its own name, `· dismiss()`, with
    no cylinder because Apple sets it, like native materialization; it
    logs under its own name, through `@TestEnvironment` under `@Shell`
    or the shell's closure by hand, and the test asserts the call, the
    "did it really dismiss" test CoreFlow's hosted suite already runs.
    The checker accepts a dotless call. Applied to `hypermodular/SKILL.md`,
    `notation.md`, `AGENTS.md`, `mapcheck.py`.
  - **F28, conditional children that are not alternatives.** A sheet
    shown while `isAdding` holds and a detail pushed while `path` is
    non-empty can both be on screen. Unlabeled arrows say both always
    exist; labeled arrows say one or the other. The cold agent drew
    them unlabeled and lost the condition. Ruled 2026-11-09, in the
    form Opus proposed and Astra endorsed: a labeled arrow is a presence
    condition; arrows labeled with the same deciding value are
    alternatives (complements are the binary case, three arrows on one
    enum a switch); arrows on different values are independent. No
    checker change. Applied to `hypermodular/SKILL.md`, `notation.md`,
    `AGENTS.md`, `README.md`.
  - **F29, a handed binding on the label.** Garden's `path` and
    `isAdding` arrive as bindings and are written, so they are evidence
    targets, yet no label line names them and the two copies cannot
    cross-check them. Related to F21. Ruled 2026-11-09, against the
    first proposal: a fifth line kind, `· $name`, a binding the parent
    handed down and the node writes. Deciding fact, from a fresh Sonnet
    read and Codex Astra: a parent turning a child's `let` into a
    writable `@Binding` hands it write authority over parent state, and
    without the line no map diff shows it, which breaks double entry.
    Opus and the first proposal preferred no line and the code-side
    checker later. The checker verifies `$` targets and warns when a
    `$` line is written in no block. Applied to the label grammar in
    `hypermodular/SKILL.md`, `notation.md`, `AGENTS.md`, `mapcheck.py`,
    and the book app's `BookShelf` label in both copies. F21 stays
    separate, a `dep.` line is not a handed one.
  - **F30, where a node's own navigation state lives.** The mapping
    skill says navigation state lives at the root and callers get
    closures. The first Garden pass obeyed it: `RealRoot` owned `path`
    and `isAdding`, handed them to `Garden` as bindings, and `navService`
    closures wrote them. The second pass, after F29, made `path`,
    `isAdding`, and `isShowingSettings` own state of `PlantsScreen` and
    dropped `navService`, because root-owned bindings would be `· $path`
    lines whose only writer is the system (back gesture, sheet
    dismissal), and it read that as undrivable. Both pass the checker.
    Proposed: state that presents a node's own children, a sheet it
    shows or a stack it owns, is the node's own; it is lifted to the
    root and handed down only when another node or the root must drive
    it, which is what `navService` is for. The system's writes into a
    handed binding are drivable in a hosted test (a back tap, a swipe)
    and log like any write. Ruled 2026-11-09 as proposed, by F32's
    "state nothing above can construct stays where it is used": a node's
    own sheet or stack is its own state, lifted only when another node
    must drive it, which is what `navService` is for. The mapping skill,
    `notation.md`, `AGENTS.md`, and the README now say so.
  - **F31, unordered out-arrows have no mark.** The test array is ruled
    "a set where the requirement names no order" (since revised, see
    F31), and the sequence
    diagram has only sequence. The cold agent drew every block ordered.
    Proposed: wrap the interchangeable out-arrows in a Mermaid `par`
    block; the test compares them as a set; the checker treats the
    block's arrows as one unordered group. Two Astra reviews
    (2026-11-09) rejected the set, which makes two identical writes
    one, and the `par` block, which the checker would not enforce.
    Ruled 2026-11-09: no new notation. The test sorts the
    interchangeable entries into one fixed order before comparing,
    duplicates kept, and the block shows that order. "Compare as a set" and "assert the
    decision and skip the log" are gone from both skills and the
    references.
  - **F32, constructability decides where a source of truth lives, usage
    decides what a feature receives.** The owner's rule, 2026-11-09,
    after an Astra audit counted 119 rule units in the two skills. A
    source lives at the highest node that can construct it.
    `@AppStorage` needs only a static key, so the root owns the app's
    finite set of keys and a feature receives a binding and never names
    a key; a SwiftData write is a closure, so a root contract; `@Query`
    needs its sort and predicate, so it lives where those arrive, a
    shared query at the common ancestor; `@SceneStorage` at its scene's
    root; everything else stays where it is used, and `@Shell` tests it
    there. State is not centralized on principle. Folded in the same
    day: rule 2 of the data-coupling skill rewritten; `· @AppStorage`
    off every feature label and example (the mapping skill's Library,
    four shell-core examples, the fixtures, now a `settings` cylinder
    and `$settings.x` lines); the macro named the preferred cut where
    the library is present; three do-not bullets that repeated the
    layer and open-state bullets folded back; the `@Sendable` do-not,
    the guard-and-assertion detail, the picked-photo clause, the
    child-shares-environment sentence, the host mechanics duplicated
    from the CoreFlow skill, the root-named-for-`@main` sentence, and
    "two or three findings" cut; AGENTS "never mock" became "never a
    mock object"; "every value" became "every app-provided value".
    Astra also proposed cutting fifty-one code rules as taste and a
    fourteen-sentence ruleset; both declined, the reader is the writer.
    A third Astra review the same day, against the first twelve
    commits and the HYPERLAMBDA notes, found the direction honors the
    original bet, the fence, the oracle, the human reader of the map,
    asked for the lifetime clause now in the rule ("a source that
    outlives the node"), corrected "a test overrides only the closure
    it spies on" to every closure the label names, and named the
    code-side registry check, F11, as the one thing the early notes
    wanted that is still unbuilt. Restated the same day in the owner's
    four keys, construction, usage, actions, mockability, after a fresh
    Sonnet 5.5 review of the current repo against the first five
    commits found the structural ideas kept nearly verbatim and three
    internal contradictions, now fixed: "No mocks, ever" against "the
    mock is a value" (README now says mock objects), `~~~` "semantic"
    against "carries no meaning" (now "constrains nothing"), and "fast
    feedback" against hosted UI tests ("fast" dropped). The example app
    adopted F32 the same day: `@AppStorage("sortByAuthor")` moved to
    `RealApp`, Library reads and hands `settings.sortByAuthor`, an
    eighth cylinder, label `· $settings.sortByAuthor` in both copies,
    no test array changed. Astra high then ran the same five-commit
    comparison against the repo as it stood after F11 and judged it
    "architectural maturation accompanied by drift in the testing
    guarantees"; its seven operative contradictions were fixed the same
    evening: "unexpected calls appear in the log" is now caught twice,
    by the log for a logged boundary and by `--sources` for an unnamed
    one; moving state across the core's edge is named a contract
    change, not a refactor; "own state never appears on a map" says
    structure map; the mapping skill's protocol ban points at the code
    skill's three exceptions; "a write is the last thing a node does"
    distinguishes the value that dies from the action that runs on
    through its awaits; a child's handed-binding write is the parent's
    own out-arrow, not a stimulus; and "the source wins" yields to the
    owner's later rulings (F23). Its two restore items, ruled the same
    evening with a fresh Sonnet 5.5 high read that agreed on all
    three: a dependent-step or compensation workflow is declared in
    one block by the node that decides the later call, result as a
    dashed arrow back, compensation as the next out-arrow, and it is a
    node of its own exactly when the node rule makes it one (the
    second commit's "its own node" was a second, vaguer node
    criterion); fast feedback is declined, speed is no argument, and
    the non-speed residue, unfakeable and ordered, is already stated in
    the README and the workflows. The contract-line criterion, open
    since the second commit, is deleted as moot: a label line is
    whatever the node's code materializes from a source that outlives
    it, calls, reads off a dependency, writes through a handed binding,
    or calls back, and the checker derives it from the Swift; a
    criterion decides only whether a block is drawn and whether a draft
    lives in the core or below it (F25), never what a label holds. One
    early sentence taken back into Diagram 3: the live value, the
    preview default, and the scenario's logger are member sets of one
    struct.
  - **F33, a consequence every write must carry.** The Garden brief's
    "every plant gets a reminder on its due day" landed on three labels
    as `reminderService.schedule()`, on the sheet, the detail, and the
    undo bar, because the cold agent found no notation for a cross-node
    invariant (third Garden pass, Sonnet medium, 2026-11-09, the first
    run gated by `--sources`: 0 errors, build clean, nothing
    unverified, every declared array matching its scenario, and the
    maps used `$settings.city`, presence conditions, own navigation
    state, and a subscription stream with `System` stimuli as ruled).
    Ruled the same day: it is the root's composition, a derived
    `dbService` listing `reminderService` as its ingredient, which the
    dependency column already draws; a node names only its write. One
    sentence in Diagram 3. Also from the run: the root node is named
    for the `@main` type or the view a package exports (restored in
    `notation.md`; the morning's cut of that sentence was premature);
    a `*Scenario` type is exempt from the checker's unmapped-view
    warning; the checker's unverified count is deduplicated; the
    CoreFlow skill names the package spelling of main-actor isolation.
    Judged no gap: the photo picker's load as a contract taking the
    system's item type, the stored `dueDate` on the model (a stored
    property is data), furniture between a node and its child node,
    and a stale `clock.today` (the root's business).
  - **F34, the rules went down with the draft.** The address-form run
    (Sonnet medium, 2026-11-09, `scripts/engine-run-prompt-address.md`,
    output in the owner's `~/Desktop/address-form`): gates green, the
    rules a pure extension on the model, no validator object, and the
    fields view owning the four drafts, trimming, validating, and
    gating Save, with the node above it an empty `let onSave`. The
    owner: "all implementation details need to be erased from the view,
    validation comes from above, we intercept the text field binding
    into validation above", and "this is worse than MVVM". F25 had said
    where the draft's storage goes and nothing about the rules, so the
    agent buried both. Ruled: what moves below the core is storage a
    criterion never names, never a rule; a rule runs above the view in
    the setter of the binding handed down; a form's node owns the draft
    and its errors, intercepts each field's binding, and the fields
    view is bindings and labels. Sentences in the data-coupling skill
    (F25's bullet and the interception-point bullet) and the CoreFlow
    skill; the Desktop app rewritten that way, both targets building,
    checker clean. Also from the run: a real mini app is an xcodegen
    project, never a package (template changed); the checker counts a
    callback handed down by name; the library target needs the
    isolation setting too. Rerun the same evening, same prompt, same
    model, empty directory, skills with the F34 sentences: the cold
    agent produced the shape unprompted, the node owning four drafts
    and four errors as `@State`, each field's binding intercepted in a
    setter that stores the text and writes the error, the rules static
    functions on the model, the field a binding and a label. The
    owner's brief in product words was enough once the sentence was
    there. Two more sentences from it: the error is stored, not
    derived, so the judgment is an event (the agent met "derive instead
    of store" against the setter writing the error); `TestScenario`
    lives in the host target when there is no bundle. Material for the
    owner's library, not the method: the agent ran the blocks in a
    throwaway UI bundle and found the macOS `TextField` writes its
    binding on focus, several times per keystroke, and on focus loss,
    so a one-character edit logs about ten entries and every field
    block became a `loop`; and the log element's accessibility label is
    capped near 512 characters, after which `JsonUtils.decode` fails on
    its `try!`, so a full-form log cannot be asserted through
    `logNames`. Third run the same evening, after the owner asked for
    "a special validator struct, raw bindings as inputs, error labels
    and intercepted bindings as output, unit-testable without the view
    runtime" and two sentences went into the skill (the interception
    is a transformer; a transformer of bindings gets a plain test): the
    cold agent wrote exactly that, `AddressFields`, eight raw bindings
    in, four `(text, error)` pairs out, a `judge()` for Save, no state,
    the rules static functions, the row a binding and a label, the node
    owning eight `@State`s. It ran every block in a throwaway UI bundle
    and every array matched exactly, because it added
    `guard $0 != text.wrappedValue` to the interception: the macOS
    `TextField` writes the held value on focus and on blur, and the
    guard makes a no-change write store nothing and judge nothing.
    Open as F35: is dropping a no-change write the method's answer to
    the system's write storm (the log shows changes, exact arrays, no
    `loop`), or must the storm be declared as-is. Also open: the brief
    asked for two application targets and the agent left its harness,
    a `bundle.ui-testing` target, in `project.yml`; and nobody wrote
    the plain test the transformer exists for, since the prompt names
    no unit-test target. Owner's call whether the template asks for
    one. Fourth run, after the owner asked for `@Binding` properties on
    the validator and a unit test, and the skill said so: the agent
    wrote `AddressFieldRules` with `@Binding var address` and
    `@Binding var errors`, four computed `Binding<String>` outputs, a
    `judgeAll()`, the same no-change guard, a pure fields view, and five
    Swift Testing tests over local variables with no view runtime,
    green under `xcodebuild test`; it removed its throwaway UI target
    this time. F35 ruled on that second independent appearance: a
    write of the value already held changes no source of truth, the
    interception drops it. Also from the run: a silence on a contract
    line is an edge event, so the criterion is drawn (notation); the
    host's mapped wrappers carry explicit types (CoreFlow skill); the
    template says the Swift 6 language mode, since "Swift 6.4" is a
    toolchain, not a mode. Fifth run, with the capability paragraph and
    the computed-node sentence in the skills: `@Capability struct
    AddressFieldsTransformer`, eight `@Binding` inputs, four field
    bindings, four messages, and `judge()` as outputs, the view handed
    `fields.capability` and nothing else, seven plain tests green,
    gates green. The whole shape the owner described arrived from the
    product-words brief and five sentences of doctrine across five
    runs, no output hand-fixed. One contradiction it found, fixed: the
    CoreFlow skill's do-not "keep a draft in a `@Shell` core" now says
    a draft no criterion names; a form's fields stay in the core behind
    a transformer. An Opus medium run of the same prompt produced the
    same shape, drove the live app and the host through the macOS
    accessibility API, and matched every block entry for entry. Four
    sentences from its list: a synthesized `Codable` cannot be declared
    from another file, so the root encodes a dictionary or writes
    `encode(to:)`; `@Capability` skips stored `@Binding`s, so labels are
    computed re-exports and output bindings take their own names; the
    isolation setting is never on the UI-test bundle, the unit bundle
    is fine; `@TestLog` also serves a logger that must read a given.
    Opus high, same prompt: two `@Binding`s, `draft` and `errors`, key
    paths per field, rules static on the transformer, `@Capability`,
    the node reading `.capability` itself, six tests, all four blocks
    matched in its throwaway bundle. It misread "drops" as dropping the
    text only and still ran the rule, so a focus write of "" judged an
    untouched field "Required" live; the sentence now says dropped
    whole, before the rule runs. Two more clauses: a callback alone
    makes a node, and a returning closure writes its result after the
    parens in the coupling diagram. Opus high then ran the drift review
    (`scripts/drift-review-prompt.md`) against `c02560c`: structural
    ideas kept nearly verbatim, the map side matured, the oracle
    drifted, fourteen contradictions, more than the early repo's seven
    and clustered in the day's additions. Twelve fixed the same
    evening: the protocol ban in AGENTS and the notation points at the
    code skill's three cases; "or callback" in the node criterion
    everywhere; "two or three findings" gone from AGENTS; focus is
    system state the node writes, so the node's write logs and the
    system's move does not; `async` marks what the core awaits and a
    fire-and-forget closure is a synchronous boundary; record-as-is
    gains "a write of the value already held is not behavior, an
    interception that drops it is code, and the log records what that
    code does"; a rule the feature owns is a pure function of its state
    and stays with it, beside "behavior is closures the app sets at the
    root"; a transformer has no state, so its methods make no object
    and its plain test is data in and data out while the node's log
    stays the node's test; the CoreFlow cut sentence notes
    `@AppStorage` stays at the uncut root; the fixture counts agree.
    And the first commit's "the deciding value is named on the label"
    is a check again: with `--sources` a presence-condition arrow whose
    label names nothing the node holds or reads is an error, with a
    fixture. Left to the owner, two of its restore items that are
    rulings: exact payload comparison by default against "a value is
    asserted as the test's author sees fit", and a compiled example app
    inside the doctrine repo, which the owner has kept out on purpose.
    Sonnet high then ran the committed template against `2ca6686`,
    same verdict, maturing maps and a drifting oracle, and eight live
    contradictions, five of them new: fixed the same evening. One
    precedence order now stands in AGENTS and the code skill, a ruling
    in `TODO.md`, then the skills, then AGENTS, then the articles, a
    disagreement flagged and never obeyed; "constructible from
    literals" names the scenario as the construction where the
    environment resolves; "never simulate behavior" adds that a stub
    returning supplied data simulates nothing; AGENTS names the two
    class cases beside the three protocol cases and says focus is the
    system's, written by the node; the `~~~` chain is semantic as the
    order the root sets them and constrains a derived service's place
    only; "the checker requires" became "reports", since a
    reverse-engineered map may lack the block; the validation
    reference's two stale lines (thirteen, unwritten) updated. Its
    restore item "a per-line contract criterion as a check" is built:
    the checker warns for every call or callback line no evidence block
    writes, and on the book app it found one, Search's
    `navService.showDetail()`, declared and never tested; the book app
    gained a second Search scenario, the block, and a ninth UI test.
    The owner then said fix all: the "one equality" sentences now say
    the names are compared whole with one equality and each value as
    the author spells it, one deterministic spelling, symbolic where a
    description is not stable, which is the names-over-values ruling
    and the early determinism rule in one breath; the do-not list is
    two marked groups, what breaks the method and how this code is
    written, nothing cut; the CoreFlow rerun clause names the one known
    flake instead of a rerun habit; "two or three findings" left the
    last reference. Not done, by ruling: a speed goal for the oracle,
    and a per-block declaration of the no-change guard, which the
    doctrine states once for every interception. Sonnet xhigh then ran
    the address prompt against the fixed skills: gates green, seven
    plain tests, the transformer and the capability as before, the live
    JSON write proven by a plain test of the extracted function, and
    one regression that was a reference's fault: it followed
    `shell-core.md`'s `.task(id: pendingSave)` example, which keys on a
    model array, and had to make `Address` `Equatable` against the
    layer rule. The example now keys on a count, with the sentence that
    a `.task(id:)` id is `Equatable` by nature and never a model made
    so, and a tap-started job is `@UnstructuredTask` under the library.
    Two more clauses: an error is written only when it changes, so
    `judge()` logs no `nil` storm; I/O with no inputs, a file write, is
    still a contract. The run's "a `@TestState` cannot be given an
    initial value" is `@State`'s own semantics, nothing the library or
    the method adds: `@TestState` is `@State` that logs, private as
    Apple asks, so out of the init; I relayed the complaint as a
    library finding and then explained Apple back in the skill, both
    wrong, both undone. The owner's ruling closes it: `@TestState` is a
    source of truth, so whoever would give it a value holds the truth,
    and then the right tool is a binding handed down, not own state. A
    given that would seed own state says the state is not the node's.
    One sentence in each skill. What stands of the run's complaint: a
    form whose draft is its own replays the typing as the given, and the
    512 cap then forces short test data. The address prompt then
    changed shape at the owner's word: the flat `Sources/AddressForm/`
    I had dictated became the method's graph, a package with
    `AddressData` (the layer, depending on nothing of yours) and
    `AddressFeatures` (the core, the scenarios, the public
    `TestScenario`, the plain tests under `swift test`), and two
    xcodegen app targets on top holding only the root, the live
    modifiers, and `main.swift`. A Sonnet medium run built it as asked,
    gates green, eight plain tests, the app linking `AddressFeatures`
    alone. Three clauses from its list: a leaf's evidence-only `MAP.md`
    sits in its own directory of the map tree when the sources are
    flat; the layer's "zero dependencies" means of your own, the macro
    library for its public inits excepted; `@UnstructuredTask` logs each
    assignment as `task` and the block declares it. The owner then
    corrected the layer twice more: it is its own package, since
    features, I/O packages, and the app all depend on it and a backend
    must never see a feature (the expenses app's graph, read critically
    the same evening: nineteen feature files reading `modelContext`,
    wire types in the shared layer, a ViewState umbrella, minted dates,
    redundant `defaultValue` statics); and the skill must explain the
    layer, not list it. The Layer section is now an explanation, what
    data coupling is, the package graph, the folders, what never goes
    in, no tests because no behavior, SwiftUI imported for its types
    because seeing is not dependency. The engine test, Opus high with
    the prompt saying only "the data coupling layer as the skill
    describes it", produced `Packages/DataCoupling` with one target and
    no dependencies, `Packages/Features`, the app with `Dependencies/`,
    gates green, every block driven and matched. It put the errors
    value in Features because the section said both "a validation's
    errors" in `Values/` and "a type one screen keeps to itself" stays
    out; the section now says values live in the layer even when one
    screen reads them, and what stays out is a helper that is not
    data. Three more clauses: the scenario's own `@TestState` carries a
    given; the test produces a child-callback stimulus by driving the
    real child; a path dependency's package name is the directory's.
    The owner then struck the errors struct itself: "why grouping? it is
    a mental retardation from OOP, why is it not in a proper view?"
    Four fields are four `String?` errors, each beside its field, state
    of the node and label of the row; gathering them into `AddressErrors`
    is the ViewState umbrella the do-not list already named, and it
    appeared because my `Values/` example said "a validation's errors".
    The example is gone, the do-not names an errors struct, and the form
    sentences say one error per field, never a struct. An Astra high
    run of the packages prompt (sandboxed, no network, so it designed
    and wrote from zero and the gates ran outside; a second short pass
    verified `swift test` and the checker inside, `xcodebuild` blocked
    by cache writes, no Swift changes) produced the loose-state form
    before the sentence existed: eight `@State`s, no errors struct, the
    model assembled in the Save closure, `@Capability`, the layer as
    its own package with two files. Two of its findings were reference
    contradictions, fixed: "a value creatable with no inputs does not
    belong in the environment" in `modules.md` and `notation.md` now
    exempts I/O, the boundary being the I/O not the inputs; and
    "each node's evidence holds before the next is started" now admits
    a block whose stimulus is a child's callback, proven with that
    child. A Sonnet medium run on the finished skills, the probe for
    the reflexes: none appeared, eight loose `@State`s, no errors
    struct, no class or protocol, the model assembled in Save, the
    layer its own package, the file write at the root; nine tests,
    every block driven and matched. Two clauses for the CoreFlow skill:
    an `@UnstructuredTask` writes state through a captured `$binding`,
    never `self`; the app links the features package where there is
    one. Then the draft
    too: "having the state Address is not right, we need fluffy states,
    only on clicking Save we should assemble the model; fluffy increases
    composability." A form's node owns one `String` per field, loose,
    never a model, because loose state composes, any field handed
    anywhere as a binding, and the model exists only when Save
    assembles it. Both skills say so; the CoreFlow example changed from
    `draft: Address` to `street: String`.
  - **F36, no invented model in a feature.** Ruled by the owner
    2026-11-10, from the reflexes an agent brings. An enum is a model,
    so one rule covers both: a model exists because the data layer
    already defines it, a `Decodable` from the backend, and a feature
    never invents one. Its state is loose fields. The reason is
    composability and orthogonality, the owner's words: "in swiftui we
    optimize for composability, we dont have objects, state lives
    outside the views", "its about orthogonality". The load-state enum
    with associated values, written so "impossible" states cannot be
    represented, is the named case: loading, error, and result cannot
    be handed down or animated apart once fused. The owner: "keep
    state fluffy", "don't artificially couple data pieces together so
    tomorrow they are hard to decompose". One bullet in the code
    skill's list, beside "Grouping for grouping's sake", and one in
    AGENTS. The agent's reading, not yet ruled: a feature-private sort
    option or sheet enum is one fact with a closed set of values, not
    a model, and stays. Open: no engine brief yet tempts the
    load-state enum.
  - **The test array**, ruled: the whole log, one equality, so an
    unnamed call fails; where the requirement names no order the test
    sorts those entries into one fixed order before comparing (F31);
    never a subsequence. The
    entry's string is the target's own name, a space, the payload.
    Refined 2026-11-09: the names are the contract, whole and in
    order; a value is asserted as the test's author sees fit, since a
    payload may be an optional, a model, or a class, and the author
    knows how to read it.

- **Open, the owner's decisions.** The skill folder name
  `data-coupling` stays (2026-11-09). Whether the public
  `swiftui-mv-architecture` repo points here or stays as it is; its
  installed skill symlink was moved to `~/.claude/skills/.trash/` on
  2026-11-05 and `~/.claude/skills/data-coupling` links here. Pushing
  `main`: one local commit over `a3a815c`, nothing pushed.

- **Next: both skills on a real project.** Map it with `hypermodular/`,
  review its nodes with `data-coupling/`, and let what the notation and
  the rules cannot express drive the next changes. Findings F21 onward
  go here. A miniature ran on 2026-11-09, `scripts/engine-run-prompt.md`
  on a cold agent: a habit tracker drawn, checked at zero errors,
  declared, and built with `swift build`, the declared arrays matching
  the scenarios' strings. Its eleven questions became sentences in both
  skills the same day (the clock as a `let`, a draft stays local, a
  sentence F25 later revised, givens as scenario parameters, live closures over
  `$state`, `defaultIsolation(MainActor.self)`, the root node's name).
  On 2026-11-09 the unseen brief ran, `scripts/engine-run-prompt-garden.md`,
  a plant-care app in product words with a state-keyed sort, a detail
  reached by tap and by notification, a timed undo, a photo picker, a
  sheet form, and a weather fetch with an offline path: eight nodes, six
  cylinders, twenty blocks, zero errors, a clean build, and fifteen
  findings. Eight became sentences (chain order against the column, the
  composition root is never cut, a scenario's loggers stop at the node's
  edge, a delay is an async effect, out-of-process system UI is
  machinery, a subscription logs once and its events are `System->>`
  stimuli, a new id is never minted in a node, `@TestState` typing in
  the CoreFlow skill). Four are rulings, F26 to F29. The brief now asks
  for SwiftData so the run exercises `@Query`. The second Garden pass,
  the same day against the ruled skills, passed its gates again with a
  different decomposition (five nodes, own navigation state) and
  thirteen findings: five became sentences (a child under a scenario
  shares its environment; a `System` stimulus is the scenario's to
  produce; the picked photo's load is I/O behind a contract; a
  framework-required delegate is a class private to its root modifier;
  a write may return a result), F21 got its material, and two new
  rulings opened, F30 and F31. The
  same day the book app itself was rebuilt on swift-core-flow in a
  scratch clone by a cold agent, maps and evidence fixed: seven
  evidence tests green on the simulator, the three aftermath
  assertions gone because `@TestState` logs the own-state writes, one
  map proposal (F25), and the macro findings in the CoreFlow skill's
  material. Whether the example adopts it is the owner's call.

- **DONE: the vocabulary table, and the name.** The log is the
  execution log. The masterclass, the method article, and CoreFlow all
  say so, and only the skill said evidence log. Evidence stays what the
  test wants and the name of the block that declares it
  (`%% Evidence:`, which the checker parses). The alignment table is
  `SKILL.md`, "Vocabulary".

- **DONE: split.** `SKILL.md` is 16KB of doctrine (rules, depth 1, the
  four diagrams with their examples, evidence essentials, workflows in
  short form). `references/` is organized by the two jobs plus the two
  bodies of detail: `architecting.md`, `reverse-engineering.md`,
  `notation.md`, `evidence.md`, and the existing validation run. Nothing
  deleted. Every moved passage is pointed at from where it left.
