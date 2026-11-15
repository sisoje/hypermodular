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
    Half settled by F74. A reaction that writes the node's own state
    from the new value is the repair of a seeded copy and no when.
    The other half closed by F79. `Parent->>Node` is not a stimulus.
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
    AGENTS. Ruled the same day: an enum that names one choice from a
    finite set, a sort option, a fixed selection of visual components,
    is not a model and stays in the feature, and "enum can be
    conformed to view directly if needed". The Garden brief tempts the
    load-state enum, a fetch with an offline path, and the run of the
    same day kept the facts loose (F45).
  - **F37, no task nobody holds.** Ruled by the owner 2026-11-10, a
    separate rule from F36 and not about objects. An unstructured
    `Task` is never fire-and-forget. It is assigned to an
    `@UnstructuredTask` slot or a binding backed by one, which cancels
    on replacement and on node removal. `.task` is the runtime's
    lifecycle event, which the node does not control; a held
    assignment is controlled and tested. So `.task` stays for
    appearance and value-keyed work, and work an event starts is held.
    Two bullets in the code skill's first list, the sentence beside
    "one shell wherever the I/O is", one bullet in AGENTS, and
    `BookShelfShell` in `shell-core.md` rewritten from
    `.task(id: saveCount)` to a held save, the counter kept as the
    fallback without the library. On a `Task` inside a closure the root
    sets, the owner, the same day: "never add lifecycle things
    into creation", "creation goes by nodes and view lifecycle triggers
    as needed". So the rule has no exception at the root. The root
    builds values; a closure set there is a plain call and starts no
    `Task`; work is started by a node, by `.task` or by a held task; an
    asynchronous closure is `async` and the calling node owns the task.
    "The root's closure may start its own task" is gone from the
    black-hole passage. And the reason under it, the owner: "OOP
    idiots conflate struct-view with actual-view, swiftui is reactive,
    it is based on state (graph), so its values graph recomputes and
    lifecycle comes as effect on it". One bullet in the code skill's
    "Model", beside "the struct has no lifecycle". And later the same
    day: "in OOP worlds view is always physical, so they inject VM into
    it; in reactive world there is no view, it is flowing and not
    physical, it is recomputed and composed as needed from dependencies
    that are flowing", and "a view is just called the view". Four
    sentences in the code skill's "Lift", in the bullet on injection.
  - **F38, screen first.** Ruled by the owner 2026-11-10, from the
    address form: "what you see on screen you need to model directly",
    "textfield yields binding, error label yields let", "no
    overthinking", and "if figma or manager says 'if error then' its
    the core logic, we put it in core and is testable, we dont
    overgeneralize, simple screen by screen modeling", and "swiftui
    screens are cheap and need to be readable like a book". A core is
    read
    off the screen before anything that feeds it exists, one property
    per element; the design's own rules about the screen are branches
    in the core over values it was handed; whether there is an error
    is decided above, in a transformer between the state and the
    core's binding; nothing generic. It is rule 1 applied inside a
    node, the contract before what fulfils it. F34 stands and is
    renamed in one clause: its fields view is that core, no longer
    "nothing decided in it". A paragraph and a table in the code
    skill's "Cut", one bullet in `shell-core.md` and in AGENTS. Whether
    the state owner above is a `@Shell` or a hand-written shell is
    F39. Where own `@State` such as a sheet flag sits is F41. The
    CoreFlow skill carries it too, since the same day: its form
    passage ended "the fields view is bindings and labels" and now
    says the fields view is a core written by hand, read off the
    screen. Its sentence that a draft no criterion names lives in a
    furniture view is F25 and stands, since a furniture view owns the
    draft and a core owns nothing.
  - **F39, `@Shell` or by hand is a judgment per view.** Ruled by the
    owner 2026-11-10: "i invented shell mostly for legacy projects
    where we want to introduce testability piece by piece", "agent
    need to evaluate on the go whether is better to use shell or
    manually to write core and shell", "sometimes shell macro is simply
    practical and allows us to test in integration with core". This
    replaces "cut with `@Shell` wherever the library is present". The
    macro is for a view that already exists and for testing state and
    `body` together in one log; by hand is for a new screen modeled
    from the design (F38). And the three together, the owner the same
    day: "sometimes we need to have manual core plus manual shell along
    with shell macro because we want to test actual shell". The
    hand-written shell carries `@Shell`, so the real shell is proven,
    not only the core. The bullet in `shell-core.md`, "When to split", and
    one sentence in the code skill's "Screen first". The address
    brief no longer dictates the macro, so a cold run shows the
    agent's own choice; the CoreFlow and Garden briefs keep the
    sentence, since those runs exist to exercise `@Shell`. The CoreFlow
    skill said "with the library present it is the cut; a hand-written
    shell and core pair is for a project without it"; changed the same
    day, on the owner's word, to the per-view judgment, with the held
    task (F37), the direct preview of a core (F42), and F40's sentence.
    Committed on CoreFlow's `main`, not pushed.
  - **F36 to F39, the audit the owner asked for the same day.** Three
    things said and not written, now in: a binding into one enum case
    needs a case path, machinery that exists only because the facts
    were fused (F36); screen first is building top-down inside one
    node, in the skill's own text (F38); and the three pieces as code,
    "Worked example, screen first" in `shell-core.md`, core, then
    transformer, then shell, typechecked alone in the Swift 6 language
    mode, not run. One checklist line.
  - **F40, any rule may be broken.** The owner, 2026-11-10: "all rules
    can be broken if necessary", and, the same day, against the narrower
    wording "when the case needs it": "not only if case need it, any
    rule ever may be broken if saves time or brings practicality in
    entire skills". Practicality outranks the rule, in both skills.
    The sentence is at the head of the code skill's "Do not", after
    the three rules in the map skill, and in AGENTS. A break is said out
    loud, with the rule and the reason, so that it reads as a decision
    and not a miss, and the engine briefs ask a run to list them.
  - **F41, shells and cores cascade.** On where a sheet flag lives in
    a screen-first core, in the core or handed in from the shell, the
    owner, 2026-11-10: the question is wrong, "we can
    have cascade of shell/cores, why not, thats why we say
    hypermodular, we test each node as unit, and when composed the
    composition will work". State sits in the node that uses it, one
    more shell goes above when a scenario must hand it in, to any
    depth. F30 stands untouched. One bullet in `shell-core.md`, "When
    to split", and one sentence in the code skill's "Cut".
  - **F42, which previews need a scenario.** The owner, 2026-11-10:
    "we use scenario concept for previews, as a rule", and "core views
    can be previewed directly actually, shell
    views (with state or whatever) need a scenario". A core is
    constructed with literals in `#Preview`. A shell, or any view with
    state or a live wrapper, is previewed through a scenario that owns
    or sets what it needs. The direct core previews and `@Previewable
    @State` stand. Sentences in
    `shell-core.md` (the by-hand example, the naming bullets, the
    checklist) and in the code skill's test section.
  - **F43, converting a codebase that already exists.** The owner,
    2026-11-10, on conversion being a different job from writing new
    code: "didnt we had separate skill already? do it". There was
    none. The older `swiftui-mv-architecture` skill had
    a reference, `refactoring-from-mvvm.md`, whose "after" shapes are
    now this method's do-nots, a `State` struct beside a `Logic`
    struct, a phase enum, a `Task` in the button, a session object.
    Written new as the code skill's fifth reference,
    `references/converting.md`, the pair of the map skill's
    `reverse-engineering.md`: one node at a time, the two kinds of
    legacy view (own wrappers get `@Shell` as they stand, F39; an
    object is taken apart and the screen modeled again, F38), a table
    from each part of an object to where it goes, the order for one
    node, the service wrapped at the root and not rewritten, the edge
    with unconverted code, what the old habits propose instead, when
    to leave a screen alone, a checklist. Its signup example, before
    and after, builds against swift-core-flow in the Swift 6 language
    mode with the main-actor default; it was not run. Pointed at from
    both skills, AGENTS, and the README, and the code skill's
    description names the job so it loads for it. A reference and not
    a third skill, since the code skill already loads on "refactoring"
    and on every object word, and the rules it applies live there. It
    also says, from standing rulings: criteria are agreed before a
    node is converted,
    never read off the code (from "evidence is not reverse-engineered");
    a legacy parent may hand a converted child its object's method as a
    closure; each conversion moves one contract up to the root; a
    screen nobody is changing is left alone (F40). Not tried on a cold
    agent.
  - **F44, the checker sees a `Task` nobody holds.** The owner,
    2026-11-10, asked whether the checker should enforce the day's
    rules: "do as you think is best". The gates of an engine run were
    the checker, the build, and the arrays, and all three pass with a
    `Task` in a button. With `--sources` the checker now warns on a
    `Task` expression that is not assigned, returned, or awaited (F37).
    A warning and not an error, since F40 lets a rule be broken. The
    invented model (F36) is not checked: text cannot tell a fused enum
    from a finite choice, so it stays a review item. Tried on real
    code before it landed: the conversion example's "before" file
    raises it and its "after" does not; the Desktop address app raises
    none; swift-core-flow's own hosted suite raises two, in
    `FlowUpThrowsScenario.swift` and `TestActionScenario.swift`, both
    real. The clean fixture's `SaveButton` stub had the same `Task` in
    a button and now holds it in a slot, its block declaring the
    assignment; the broken fixture plants one. A second warning, on an
    object that owns state, was added and removed the same day on the
    owner's word: "we dont use observable object why you mention that
    all day". An app the method builds has none, and the only file
    that speaks of one is the legacy `converting.md`.
    `notation.md`, the fixtures' README, AGENTS, and one bullet of the
    code skill say what is left. The four engine
    briefs now ask the run to report every rule it broke on purpose and
    every warning it left standing, each with its reason, so a grader
    can tell a chosen break from a miss.
  - **F45, two cold runs on the day's rules.** Sonnet high through the
    Agent tool, 2026-11-10, the briefs filled in under
    `~/Desktop/engine-2026-11-10/` with the prompts saved beside the
    outputs. Address form, about 22 minutes: checker with sources 0
    errors 0 warnings 0 unverified, 15 plain tests green, `xcodebuild`
    succeeded, all three rerun by the agent that graded. The brief no
    longer dictates the cut, and the run chose the three pieces
    unasked: `AddressFormCore` written by hand, "read off the screen"
    in its own comment, a hand-written `AddressForm` above it carrying
    `@Shell`, eight loose `@State`s, the `Address` assembled on Save,
    the save a `Task` held in an `@UnstructuredTask` slot with a
    capture list and a binding write, no `Task` in the root's closure,
    the core previewed from literals and the shells through scenarios.
    It drove both hosted scenarios through macOS accessibility and
    reports all five arrays matching; the grader read one block
    against its scenario and ran none. Garden, about 24 minutes, the
    brief still dictating `@Shell`: 0 errors, a clean build, the arrays
    derived and not observed. The forecast is two loose facts, `low`
    and `isOffline`, no phase enum; the timed undo is a held task that
    awaits the delay and deletes, Undo writing `nil`; the forecast is
    `.task(id:)` on the city and the reminder taps a `.task` over a
    stream; nothing starts a `Task` in a root closure. Both runs
    listed the rules they broke on purpose, as the briefs now ask.
    Sentences made from them the same day: the "Save is disabled"
    line in "Screen first" is an example of a design and says so,
    since the address run read it as a rule and reported breaking it;
    with a hand-written core under a `@Shell` shell the scenario is
    owed to the shell's generated `Core`; a delete with undo is the held slot; the picked photo's
    load is I/O behind a contract, a clause cut on 2026-11-09 and put
    back because Garden put `loadTransferable` in furniture and said
    no rule placed it; a `QueryView` takes the `· @Query` line; the
    feature package's one public view is the top node of its own tree.
    And the checker: a root modifier that reads one cylinder to derive
    another no longer warns, the one warning Garden left standing.
    Ruled the same day, on what a no-op default returns for a closure
    that both throws and returns a value, where `modules.md` had
    forced `String?` and given the contract two ways to fail. The
    owner: "nop really doesnt matter, throw or fatal error". The
    default throws, or is a `fatalError` where it cannot throw, and the
    signature is never bent for it; "never a trap" is gone from
    `modules.md`. On whether a listener inside the feature that answers
    a notification still calls `navService`, the owner: "i have no idea
    ask astra in codex". Astra at high effort, read-only, given the
    Garden code and F30, F33, F37, F41, answered that it does not: F30
    lifts a stack only when another node must drive it, a subscription's
    events are `System->>Node` stimuli, and a notification's outside
    origin makes no second navigating node. It changes when another
    feature must open the same destination, or when delivery must
    outlive the stack's owner; then the `.task` moves to a node that is
    mounted and that node calls `navService`. It is F30 applied.
    Written as three sentences, in the map skill's
    navigation paragraph, beside `.task` in the code skill, and in
    AGENTS. Ruled by the owner the same day: "yes dude puting logic
    below the view is OOP brainwashed reflex". A fourth sentence in the
    map skill says so: moving the decision out of the node into a
    router or a service beneath it is the object reflex, the node is
    the logic.
  - **The address brief builds for the iPhone.** The owner, 2026-11-10:
    "i hate ui tests on my macbook it occupies my mouse, and iphone
    runs in simulator freely". The first cold run of the day had no
    bundle and proved its arrays by scripting the Mac's accessibility,
    which takes the mouse. `scripts/engine-run-prompt-address.md` now
    asks for an iPhone app on the iPhone 18 Pro simulator, a UI-test
    bundle with one method per evidence block, a derived data path
    inside the output directory, and forbids driving the Mac's own
    interface. The packages keep macOS 14 beside iOS 17 only so the
    plain tests run under `swift test`. Run the same day on Sonnet medium, about
    eight minutes, output `~/Desktop/engine-2026-11-10/address-form-ios`:
    checker with sources 0 errors 0 warnings 0 unverified, 8 plain
    tests green, the build clean, and five evidence tests green in the
    iPhone 18 Pro simulator, every gate rerun by the grader, the UI
    tests included. The same three pieces as the Sonnet high run,
    unasked, and the no-op default throws as ruled that afternoon, the
    result not optional. One difference between the two runs: this one
    made the save a synchronous `throws -> String` and wrote
    `savedPath = try? save(address)`, noting that the `async` form
    would have needed a held task. The owner asked for the code to be
    read "for the purpose of improving skill clarity and precision".
    Four sentences from it: the block's spelling and the macro's
    spelling of one value are no mismatch; with all three pieces
    `AddressFormCore` is the hand-written screen and `AddressForm.Core`
    the shell's generated twin; with several packages and an app the
    map tree stands at the repo root, a directory per node, which both
    address runs guessed; and in the CoreFlow skill, a UI-test bundle
    beside a package links the library that holds `TestScenario`. The
    agent read swift-core-flow's sources and hosted examples to set the
    bundle up, beyond what the brief allowed, and said so. The run
    wired the transformer by hand and left `@Capability` off, "as the
    `shell-core.md` worked example does"; the owner asked whether the
    rules do not hint at it. They do, in the code skill's form passage
    and the CoreFlow skill's "Transformers", and the example added that
    morning outweighed the hint. The example now names `@Capability`
    as its form under the library. A fifth
    sentence, that the service decides whether a returning write is
    synchronous or `async`, was written and removed the same day. The
    owner called the question wrong. The code skill already says a
    closure of any signature is a behavior, and the node that calls it
    dictates the signature. The old `swiftui-mv-architecture` skill's
    link was moved out of `~/.agents/skills` into its `.trash`, on the
    owner's word, so Codex no longer loads it beside this one.
  - **F46, most types get a file of their own.** The owner,
    2026-11-10, reading the iPhone address run, where the hand-written
    `AddressFormCore` sat in its shell's file: "deserves own file",
    "tell him most of types deserve own file". The cause was in the
    reference. The code skill said "the shell and the core are two
    types in two files", and `shell-core.md` said they "live in the
    same file until it grows past comfortable scrolling"; the run
    followed the second. That sentence is replaced, a bullet in the
    code skill's second do-not list states the rule with its one
    exception, small private furniture of a single view, and the
    worked examples in `shell-core.md` and `converting.md` name a file
    for each piece. The agent had put the scenario on the own-file
    list. The owner, the same day: "only scenario lives where the real
    view is, i mean it should, but hand written core is own",
    "generated core is generated obviously". A scenario lives in the
    file of the real view it stages, a hand-written core in its own
    file, and a generated `Core` has none. `testing.md` had said "one
    scenario per core, in its own file", and all four engine briefs
    sent the scenarios to a `Scenarios/` folder; both now say the file
    of the view it stages. The CoreFlow skill says the same. The
    owner's wording, used in all of them: "preview chain lives in one
    file with the view that is there". The chain is the scenario and
    the `#Preview` that shows it, and the vocabulary table has the
    term.
  - **F47, a dependency is a package.** The owner, 2026-11-10:
    "dependencies live in Dependencies directory and each one is a
    package, at least dependencies that touch outside world", "i think
    all heavy dependencies need package", "sometimes dependency just
    wires two existing ones into a new one, but it also can have a
    package", "dependency packages see only data coupling layer, so
    dependencies DO NOT see features", "a dependency will usually
    expose just a view modifier with inject prefix". And the name for
    it: "this is just simple dep inversion principle, people talking
    for decades about it and they never did it properly, they depend
    on protocols but protocol still sits in entire module". Checked
    against the expenses app by the agent and by Astra at high effort,
    read-only. It has three dependency packages, eight modifier files
    in the app target, every one exposing an `inject` function over an
    internal modifier, and a derived dependency, the sync engine, that
    is a package and reads its ingredients from the environment
    without importing the package that implements them. Three of the
    eight in-app files use symbols that live in the features, a sort
    enum, a parser, a user helper, and compile because the app target
    re-exports the features. A package boundary would have refused
    each. That is the reason written into the rule, and why the line
    is I/O and not size: the largest dependency there is an in-app
    file, and "heavy" has no threshold an agent can apply. Astra's two
    corrections are in the wording: "never another dependency" allows
    the transport or SDK library a dependency wraps, and the public
    surface is exactly one `inject` modifier. The rule: every
    dependency that does I/O is its own package under
    `Packages/Dependencies/`, a derived one too; it imports the layer
    and what it wraps, never the features, never another dependency;
    one public `inject` modifier; its integration test in its own
    target; a failure is thrown, never dressed as a result. The owner,
    on reading it: "your rule is correct, dependency sees data
    coupling and no other dependencies nor feature". It replaces "the
    modifiers need not be packages" and the app-resident
    `Dependencies/` folder. In the code skill's layer section,
    `modules.md` (the graph, the dependency bullet, the reason, the
    checklist), AGENTS, `converting.md`, and the address brief. The
    three one-package miniature briefs keep their modifiers in the
    library target.
  - **F48, the layout in one reference.** The owner, 2026-11-10, asked
    whether an app-structure skill is needed, then "wrapup these
    rules". Not a skill. `data-coupling/references/app-structure.md`
    is the code skill's sixth reference: the tree on disk, who sees
    whom, the two re-exports, a package manifest, a dependency package
    with its one `inject` function, the one-file app target, the
    project script, the test side, where a file goes, a checklist. A module is never named as its contract's type, and the
    `inject` function carries the dependency's own name, as in the
    owner's app, `injectBackend`, `injectSyncEngine`. On the
    owner's "xcodeproj is usually in root, but i dont like it" and
    "improve it best you can": of the well-known open apps only
    Point-Free's isowords keeps the project out of the root, in
    `App/`, with the modules at the root, and the reference does the
    same. `App/` holds the project and the script that writes it, the
    app's one file, the test host, and the UI tests (F50). The address brief lost its
    layout paragraph and points at the reference, as the owner asked
    on 2026-11-09, "the skill, not the prompt, carries the layer".
    Sentences from the day's address runs, all in: an iOS-only
    modifier sits behind `#if os(iOS)` since the features build for
    the Mac to run their plain tests; a dependency's integration test
    calls its internal function through `@testable import`; entries
    with no order are sorted by name and then by value; typed text in
    an evidence block is one stimulus followed by one out-arrow per
    write; the layer's contract and its entry are public in a package.
  - **F49, no fixtures target, and two re-exports.** For some hours on
    2026-11-10 the skills also said a target picks its dependencies:
    two packages answering one contract under one `inject` name, two
    app targets compiling one `@main` file, an `Exports.swift` per
    target. It was built and it worked, and two example apps on the
    owner's Desktop have that shape (`address-form-deps`,
    `address-form-app`). The owner, the same day: "this idea with
    shared app for prod and fixtures is bad, remove fixtures for now",
    then "you dont need to export nothing in the app because it will
    be one file or so, better reexport coreflow from data layer", and
    "feature package need to have visibility to data layer and
    coreflow from everywhere". Removed from the code skill,
    `modules.md`, AGENTS, the reference, and the brief: the second
    answer, the second target, the per-target exports file. Written
    in their place: the layer depends on swift-core-flow and
    re-exports it; the features package re-exports the layer; so a
    feature file imports neither by name, and the library sits in one
    manifest; the app target is one file that imports what it names.
    Built before it was written, from the passing iPhone run's code:
    no feature file imports the layer or the library, eight plain
    tests green, the app builds, five evidence tests green in the
    simulator. The CoreFlow skill says the same in its install
    section. The owner, for when fixtures return: "inject will
    sometime have parameters, for prod it may have params, but for
    fixtures may not". So two dependencies that answer one contract
    need not share a signature, which the removed rule had required. No new example was run. The owner: "wait for rerun".
  - **F50, the project is the output of a script, and a third
    skill.** The owner, 2026-11-10, asked whether xcodegen is right or
    "generative approach like in coreflow", then: "ok switch to this
    approach, explain it as a skill for agents maybe, you have example
    from coreflow, also you can point the skill to coreflow way".
    swift-core-flow writes its hosted project with Apple's own
    `xcrun xcodeproj`, in `CoreFlowHosted/generate.sh`. The engine
    now does the same. Reasons: the tool ships with Xcode and
    xcodegen does not; folders are synchronized with disk, so a new
    file changes nothing; the project is one JSON file of about four
    kilobytes, committed, so a repository opens without a step; the
    library the method builds on already works this way. The cost is
    that no agent knows the tool, so `xcode-project/SKILL.md` teaches
    it: the script for an app with a test host and a UI-test bundle
    over four local packages, a table of the commands, the facts that
    bite (a new target has no phases, a synchronized group is named
    for its directory, a package is addressed by identity, a product
    is linked per target, no scheme is written, the ids are made
    predictable), what is committed, and swift-core-flow's script as
    the worked example. Read from the tool's own help and proven
    before it was written: the script in the skill generated the
    address layout's project, the app built, five evidence tests
    passed in the simulator under the test bundle's own scheme, and a
    second run of the script gave the same bytes. `app-structure.md`
    carries the script in short and points at the skill; the address
    brief names the skill and `App/generate.sh`; xcodegen, its spec,
    and its target template are gone from the reference. The skill is
    linked into `~/.claude/skills` and `~/.agents/skills` beside the
    other two. Rerun cold on the owner's word, 2026-11-12, Sonnet medium,
    about twelve minutes, output
    `~/Desktop/engine-2026-11-12/address-form`: the first cold run to
    use the xcode-project skill, the two re-exports, and the one-file
    app. Every gate green and rerun by the grader: checker with
    sources 0 errors 0 warnings 0 unverified, seven plain tests, two
    integration tests in the `AddressFile` package, the app build, and
    five evidence tests in the simulator under the `UITests` scheme.
    `App/generate.sh` is the skill's script and regenerates the same
    bytes; no feature file imports the layer or the library; the app
    is one file calling `injectAddressFile()`; the dependency throws
    and the screen node decides what a failed save shows; the core is
    in its own file and the preview chain sits with each view;
    `@Capability` is on the transformer. Nothing in its list of
    unclear places called for a new sentence, the first run of the
    week of which that is true. A second run on Sonnet xhigh died when
    the Mac slept and was not graded.
  - **F51, the node maps are one folder, `Maps/`.** The owner,
    2026-11-12, reading the rerun: "but why address screen has its own
    folder". It had one because two runs on 2026-11-10 guessed a place
    for a node's `MAP.md` when the features are flat in one package,
    and the agent wrote the guess down as "the tree stands at the repo
    root". The agent proposed moving each map beside its code. The
    owner: "i am not sure if map md files belong near code". They do
    not: the checker matches a node to its Swift type by name, so the
    place of the file ties nothing, and one map tree spans the app
    target, the features, and the dependency packages. So
    `APP-MAP.md` stays at the repo root, where an agent and the
    mapping skill look first, and every node's map is under `Maps/`,
    one folder per node, each child's inside its parent's, the top
    node's link `(../../APP-MAP.md)`. Checked on the rerun's own maps
    moved that way: 0 errors, 0 warnings, 0 unverified. In the mapping
    skill's opening and in `app-structure.md`.
  - **F52, the whole app in one diagram.** The owner, 2026-11-12:
    "my goal was to see entire app structure node-like so each node is
    a mini-feature mini-module, thats why its hyper modular", "i am
    not sure if we can keep one big md file or separate like you did,
    or maybe we can keep both variants", and on seeing a sample, "i
    like having this big md". The skill had promised it in one
    sentence, "the global view is always derivable and never
    maintained", and no tool derived it. `mapcheck.py --write` now
    does. It merges the depth-1 structure blocks on node names and
    puts one flowchart first in `APP-MAP.md`, headed `%% Whole:`:
    every node with its label, every condition, the unmounted nodes
    and the dependencies as subgraphs, and a dotted arrow from a node
    to each dependency its label names. The per-node maps stay as
    they are, the modules, each with its contract and its evidence.
    Without `--write` the checker compares, a stale diagram an error
    and a missing one a warning; a second write changes nothing. The
    agent first proposed making `APP-MAP.md` wholly generated and
    moving the root's diagrams under `Maps/`; the owner did not follow
    that, and what was built is the smaller thing, one more diagram in
    the file that already exists. In the mapping skill's opening,
    `notation.md`, AGENTS, the fixtures with three new test lines, and
    the four briefs.
  - **F53, `body` is a view's capability, and a transformer's is its
    own.** The owner, 2026-11-12, asked whether the skills say clearly
    that "swiftui view is a node where body is its capability and
    runtime uses it", and that "transformer nodes are ours, they are
    not persisted in the graph, but they may have custom capability,
    thats why we use macro". They did not. The code skill called
    `body` a transformation and never a capability, said a transformer
    has no slot and never that it is ours, and named `@Capability`
    with no reason for it. The two bullets of "Model" now say it: a
    view is the runtime's node, its capability is `body`, the runtime
    is its one user; a transformer is our node, unknown to the runtime,
    its capability is what its consumer needs, and `@Capability`
    declares that as one tuple, to a transformer what `body` is to a
    view. One vocabulary row, and one sentence in the CoreFlow skill's
    "Transformers".
  - **F54, lift, and why MVVM is wrong, precisely.** The owner,
    2026-11-12: "to be very precise why MVVM is bad because view /
    node generally does not exist physically, so all he does is also
    transforming dependencies, but is diffed managed and rendered by
    runtime, who cares, but the point is unlike uikit physical views
    we lift state and we lift logic also, and we keep them separate
    always", and "agent needs to know immediately whatever he is
    making to do that to lift". The code skill said to lift in its
    second section and gave MVVM's fault as "separates logic from
    logic". Now the first paragraph of the skill is the instruction,
    lift the state, lift the logic, keep the two apart, before
    anything else and for every view. The rule's paragraph gives the
    reason as the owner states it: a UIKit view is an object that
    stays, so an object was put beside it; a SwiftUI node only
    transforms its dependencies and nothing stays to attach a
    ViewModel to. The first hard rule in AGENTS says the same.
  - **F55, a brief is given as to a person.** The owner, 2026-11-12:
    "adress form is over instructing, isnt it? generaly prompt need to
    be simple as you give it to a human and agent need to conclude
    architecture from my skill". It was. The address brief was 640
    words, most of them architecture: the order of work, the layout,
    "the save is a dependency package of its own", six forbidden
    patterns, and five gate commands. A run that passes with those in
    the prompt shows the prompt works, not the skills. The address and
    Garden briefs are now four short paragraphs, about 200 words: the
    skills to read, the app in the product's words, the machine's
    limits (the iPhone simulator, never the Mac's own interface), and
    what to report. The address brief no longer says the address "is
    handed to the app as one value", which told the agent the save is
    a boundary. The gate commands the briefs carried are the skills'
    own, and one that was only in the brief, the derived data path,
    went into the xcode-project skill. AGENTS says what a brief holds.
    The two one-package miniature briefs are as they were. Run the
    same day on the short address brief, Sonnet medium, six minutes,
    output `~/Desktop/engine-2026-11-12/address-form-short`. With no
    architecture in the prompt it produced, from the skills: the maps
    first with the whole-app diagram, `Maps/`, the layer re-exporting
    the library and the features re-exporting the layer, the save as
    the `AddressFile` package with `injectAddressFile()`, the one-file
    app, `App/generate.sh`, a hand-written `AddressFormCore` in its
    own file, the `AddressFields` transformer with `@Capability`, nine
    loose `@State`s, no `Task`, the preview chain in the view's file.
    Every check green and rerun by the grader: three plain tests, one
    integration test, the app build, three evidence tests in the
    simulator, the checker at 0 errors 0 warnings 0 unverified. It
    drew one node where the long brief's runs drew two, the form's
    state and the save in `AddressScreen`, the rest furniture. It
    swallowed a failed save with `try?`, and its contract's default
    returns an empty string where `modules.md` asks it to throw. The
    owner asked whether everything the long prompt carried is now in
    a skill. Four things were not, and are now: the checker's command
    for an app, `--sources Packages App`; `--write` in the new-app
    steps; the build and test commands with their destination; and
    what to do when the notation cannot draw something, which is to
    build it plainly and report the gap. Found by the grader's rerun:
    a derived data folder under `App/` was read as source, 2059 types
    and 18 warnings, so the checker now skips `.build`, `DerivedData`,
    and `SourcePackages`. From the run's list: the worked example's
    `judge()` writes an error only when it changes, like its field
    setters; the example's swift-core-flow path is marked as wherever
    the checkout is; the CoreFlow skill says `waitUntil` takes any key
    path and how a block that ends in silence is asserted. The owner
    also asked why `AGENTS.md` should be hidden from a run. It should
    not. Twenty of its facts were checked against the skills,
    seventeen there word for word, two in other words, one missing,
    that there is no mock object to write, now in the code skill.
  - **F56, no strong words.** The owner, 2026-11-12: "i prefer not to
    use strong words like never, and you also got confused, all rules
    may need to be broken maybe". F40 lets any rule be broken, and the
    skills said "never" 205 times, so each rule read as an absolute
    and two of them meeting read as a contradiction to ask about.
    Every "never" in the prose of the three skills, their references,
    AGENTS, and the CoreFlow skill is reworded to what the method
    does: "is not drawn", "does not log", "not a model". Code is
    untouched, `Task<Void, Never>` included. The rule-like "always" is
    gone too, as in "mermaid id = node name", and so is "must" where
    it stated a rule, "a contract change touches both maps", while a
    "must" that only describes a condition, "when another node must
    drive it", stands. No fact was dropped. A
    script did the rewording and every changed line was read after it,
    about 180, with a dozen fixed by hand.
  - **F57, a contract's closure is a `@TestAction`.** The owner,
    2026-11-12, on a scenario from the day's run that set a contract
    with a closure calling `log("save", ...)` over a string it built
    from the address's four fields: "in my articles and examples and
    core flow i made test action to avoid testlog usage manually, this
    is garbage". The cause was the CoreFlow skill itself. Its one
    scenario example logged `deleteBook` by hand with `@TestLog`, and
    its text sent a scenario to `@TestLog` whenever "a payload needs
    the spelling the criterion uses". Every address run but one
    followed that. The example now declares
    `@TestAction private var deleteBook`, the text says a contract's
    closure is a `@TestAction` with the stub's answer as its default,
    handed to the contract, and the hand-written form is shown as what
    a scenario does not hold. A different answer is another scenario,
    since a default cannot read a parameter. `@TestLog` is named as
    the seam under the wrappers. The code skill's test section and
    `testing.md` say the same. Run cold the same day, 2026-11-12,
    Sonnet xhigh on the short brief, eighteen minutes, output
    `~/Desktop/address-form-clean`: both scenarios declare the
    contract's closure as `@TestAction` and hand it over, the failing
    save is a second scenario with its own default, and no `log(...)`
    call is written anywhere. Every gate green and rerun by the
    grader, the checker at 0 errors 0 warnings 0 unverified, four
    plain tests, two integration tests, the script regenerating the
    same bytes, the app build, seven evidence tests in the simulator.
    It is also the first run after the strong words went (F56), and
    the first whose layer takes `@Flowable` through the re-export. It
    drew two nodes. It broke two rules and said so: it built the nodes
    in one batch, and it launched the shipped app once from a
    throwaway test, because no check the skills name proves the root
    applies the `inject` chain. From its list, into the layout
    reference: the layer's two manifest lines for the library, that
    its types take `@Flowable`, and that the features' top node is
    `public` with a `public init()` written out, which six runs in a
    row had to work out. And into the xcode-project skill's script,
    one line, `ALWAYS_SEARCH_USER_PATHS NO`: the run reported that
    every build warned about the traditional header map. Checked on a
    copy of the run before it went in, one warning without the line
    and none with it, the app building, the seven evidence tests
    passing, and the script still regenerating the same bytes.
  - **F58, Garden on the short brief.** 2026-11-12, Sonnet medium,
    twenty-two minutes, output `~/Desktop/garden-clean`, the first
    Garden with no architecture in the prompt and the first in the new
    layout. It produced, from the skills: the maps first with the
    whole-app diagram, five nodes and six cylinders under `Maps/`,
    the layer with an `@Model` and six `@Flowable` contracts, five
    dependency packages each with one `inject` function and its own
    tests (`PlantStore`, `Reminders`, `Weather`, `PhotoLibrary`,
    `SystemClock`), a one-file root, `App/generate.sh`, the add form
    as a hand-written core with a transformer, the forecast as loose
    facts on `.task(id: city)`, the undo and the photo load as held
    tasks, the reminder taps as a `.task` over a stream. Every gate
    green and rerun by the grader: the checker at 0 errors 0 warnings
    0 unverified, twelve package tests across six packages, the script
    regenerating the same bytes, the app build, thirteen evidence
    tests in the simulator. One real flaw in its output, from where it
    put a held task: the delete's slot is in `PlantDetail`, so going
    back within the five seconds cancels the delete. The skill now
    says the slot sits in the node whose lifetime the work shares.
    One claim of the run was tested and not confirmed. It reported
    that the root's `$city`, handed straight into the environment
    inside a struct, left readers below stale, and worked around it
    with a `Binding(get:set:)` over a value read in the root's body.
    A minimal app in the simulator, the binding handed straight in
    from the `App` struct, showed the write to an always-mounted
    reader and to a reader on a pushed screen after a writer in a
    sheet. The rule stands as written and the workaround is not in
    the skill. From the run's list, in: a layer type takes a name
    SwiftUI does not have, since `Settings` is SwiftUI's own on the
    Mac (first written as the run's own name, `AppSettings`, and
    struck by F59); a
    contract may take a system type the screen hands it and the layer
    imports that framework for the type; a `$settings.city` line is
    `settings.city` handed on in the Swift; a test that drives the
    photo picker needs a photo in the simulator's library; an
    `Info.plist` key is a build setting. In the CoreFlow skill: a
    subscription's stub is a `@TestAction` whose default returns a
    stream that yields the given events and finishes.
  - **F59, a skill is general purpose.** The owner, 2026-11-12: "skill
    need to be general purpose, how is appsettings general?" F58 had
    written the Garden run's own type name, `AppSettings`, into the
    layer's list as the settings type. A run's finding goes into a
    skill as the rule that holds for any app. The run's own names, its
    targets, and its workarounds stay out. Out: `AppSettings` in the
    code skill, `--target GardenApp` in the xcode-project skill's
    `Info.plist` line, and "plant" in the mapping skill's sentence on
    a derived service. In, as the general fact: a type in the layer
    takes a name SwiftUI does not have, since a feature file sees the
    layer and SwiftUI both and a shared name is ambiguous there.
    Checked with a two-module package. A layer type named `Settings`
    fails on the Mac build and compiles for the iPhone simulator, and
    one named `Label` fails for the simulator too. The layer's list
    now says "the settings" and names no type. `AGENTS.md` carries the
    rule beside the engine runs. Rechecked the same day on the owner's
    request: the ambiguity is in a type position, `var settings:
    Settings`. A node named `Settings` compiles in its own module and
    from the app file on the Mac, since `Settings()` resolves by its
    arguments, so the rule stays scoped to the layer and says so. The
    recheck also found `README.md` still saying two skills, now three,
    and put the settings bullet of the layer's list in `Services/`,
    where a contract with its `@Entry` goes.
  - **F60, every dependency has two parts.** The owner, 2026-11-12,
    thinking out loud: "each dependency has two parts - how its
    constructed (the app know that and what input dependencies to
    provide plus datalayer is free to use)... the second part is how
    its used, so for example we inject all the appstorage properties
    at app level, then we just use bindings in the feature, we
    probably inject set of bindings like a struct in environment
    entry.... similar networking, we may need token bindinga to
    construct it but feature will se a struct of closures... every
    dependency on earth follows same principles that is dependency
    inversion from bob". Construction is the app's knowledge, what the
    dependency is built from and the inputs the root supplies, and the
    code that builds it may use the layer. Usage is all a feature
    sees, the contract read from its environment entry. The settings
    and the backend are the two examples, and no dependency is a
    special case. The code skill had the parts in separate places, the
    four keys, the dependency package, the `inject` parameters, and
    dependency inversion in the layer's first paragraph. It now states
    them as one rule, first in the layer's list of rules, and
    `AGENTS.md` has it under the dependencies rule. The owner said
    "probably" of the struct of bindings, so the settings stay as the
    skill already had them. The owner, the same hour: "so yes you can
    give example of appstorage.. but also maybe mention networking?"
    and "how its used - its called capabilities". The second part is
    named so in the rule. `modules.md` has the example, the book
    app's `@AppStorage` key in three pieces, the capabilities in the
    layer, the construction at the root, the use in a feature, and
    the backend beside it in a paragraph, `injectBackend(baseURL:
    token:)` and a struct of closures. The example's struct is
    `BookSettings`, the example app's own name, and the mapping
    skill's coupling diagram takes the same name in place of
    `Settings`, which F59 found does not compile on the Mac. The
    shape was read from the owner's expenses app, a layer struct of
    bindings set by one modifier that owns every key.
  - **F61, `Maps/` is the one placement.** The owner, 2026-11-12, on
    the map changes: "my ask was to have entire app possible as
    mermaid... but also separate md per feature per flow", then "ok do
    whats best". The skill had two placements, beside the code when
    the sources were flat and under `Maps/` when the code was packages
    and an app, and `AGENTS.md` still gave "beside each mapped subtree"
    as the default. Two placements is one more decision for an agent,
    and the method's output is packages and an app. Now one rule:
    `APP-MAP.md` at the repo root, every node's `MAP.md` under
    `Maps/`, a directory per node, each child's inside its parent's,
    the top node's parent link `(../../APP-MAP.md)`. The fixtures
    moved under `Maps/` with their links, the test's paths followed,
    and `architecting.md`, `reverse-engineering.md`, and the two long
    briefs say the same.
  - **F62, state apart from the behavior that mutates it.** The owner,
    2026-11-12: "separation of state and mutating behaviour is the key
    - is it clear from skills? so not separating ui from logic as
    there is no fucking ui in swiftui its wrong mental model to think
    about ui in swiftui... an 'logic' is fuzzy word... so separating
    state from muatating behaviour is the key... and its simlle
    basically operating on bindings and if you must then observable
    class reference mutating", and "because state driver the swiftui
    nodes... and we separate the driver from it". It was half clear.
    The rule section said "Decouple state from behavior. Not UI from
    logic", but the opening paragraph, the `AGENTS.md` lift rule, and
    both ViewModel do-nots named the lifted thing "logic", fourteen
    times in the code skill, "separates logic from logic" among them,
    and the mechanism was stated only under the binding bullet. Now
    the opening paragraph, the rule, the two do-nots, and `AGENTS.md`
    say it in the owner's words: the state is kept apart from the
    behavior that mutates it, state drives a node and the driver is
    kept apart from it, mutating behavior operates on bindings or,
    where it must hold a reference, on an `@Observable` class it
    mutates, and "logic" names nothing precise. "Pure logic" for a
    calculation with no effects stays in the references, where it
    means a pure function.
  - **F63, a flow is a file of its own.** The owner, 2026-11-12: "my
    ask was to have entire app possible as mermaid... but also separate
    md per feature per flow", then "ok do whats best". The whole app
    was F52 and the file per feature was F51. A flow in the method is
    an evidence block, one per acceptance criterion, and those sat
    inside the node's `MAP.md` under `## Evidence`. Now each block is
    a flow file in the node's directory under `Maps/`, beside its
    `MAP.md`, named for the criterion, `Maps/Search/Offline.md`,
    holding that one block and nothing else, with the parent link its
    node's `MAP.md` carries. A leaf's directory holds flow files and
    no `MAP.md`. The checker reads every `.md` under `Maps/` besides
    the `MAP.md` files and warns on an evidence block left inside a
    `MAP.md`. The fixtures' four evidence blocks are flow files now,
    the test's paths followed, and the code skill's tree, the mapping
    skill, `notation.md`, `architecting.md`, `AGENTS.md`, and the two
    long briefs say the same. A user journey across several nodes
    gets no hand-written file, by the depth-1 law.
  - **F64, a scenario is a file of its own, the previews stay with the
    view.** The owner, 2026-11-12: "i am just not sure where to put
    scenario structs and previews... because i preferd one type per
    file but apple mesed me up because core macro can not be used
    without scenario... and so we need main view + scenarios +
    previews and maybe its not nice in one file?", then "ok". F46 had
    the preview chain, the scenario and its `#Preview`, in one file
    with the view. Now a scenario is a file of its own, named for the
    scenario, beside the view it stages, since it is a test fixture
    and the view is the product, and the generated `Core` is a nested
    type any file of the module constructs. The `#Preview` lines stay
    in the view's file, each naming a scenario, since Xcode's canvas
    shows the previews of the file that is open. The code skill and
    its glossary, `shell-core.md`, `testing.md`, `app-structure.md`,
    and the CoreFlow skill say the same.
  - **F65, a brief carries no technical hint; the skills carry the
    defaults.** The owner, 2026-11-12, asked of the Garden brief "is
    the prompt human sounding - free of tech hints?" and ruled "all
    tech hints ideally should be in skills". The Garden brief had
    four: "a form in a sheet", "the fetch fails", "a weather web
    service", and "Plants persist in SwiftData". The first three are
    now "opens a form over the list", "when it cannot be reached", and
    "an online weather service", each with its home in a skill, the
    sheet as the node's own state, a service on the net as a contract
    of async closures, a failure thrown. The fourth stays, the owner
    the same hour: "swiftdata is ok to mention dude?". A technology
    the product is committed to may be named in a brief, and the
    address brief keeps its JSON file and the path it shows. The code
    skill's `Models/` bullet says what a brief keeps on the device is
    SwiftData unless the brief says otherwise, and `AGENTS.md` says
    which technical words a brief may carry.
  - **F66, Garden on the flow-file layout.** 2026-11-12, Sonnet
    medium, twenty minutes, output `~/Desktop/garden-flows`, the
    brief as F65 left it, the first run after F59 to F65. From the
    skills alone it produced the layout as ruled: `APP-MAP.md` with
    the drawn whole-app diagram, `Maps/PlantList/MAP.md` the one
    structure map, sixteen flow files, one evidence block each,
    `PlantDetail` and `AddPlantForm` as leaves with five and four flow
    files and no `MAP.md`, seven scenarios each in a file of its own
    and the `#Preview` lines in the three view files, the settings
    type `GardenSettings`, the undo window held in the list, five
    dependency packages. Every gate rerun by the grader: the checker
    with sources at 0 errors 0 warnings 0 unverified, nineteen package
    tests across six packages, the script regenerating the same
    bytes, the app build with no warning, fifteen evidence tests in the simulator, 0 failures in 86 seconds. From its
    report, into the skills: a layer type takes a name SwiftUI,
    Foundation, and the standard library do not have, `Calendar` and
    `Clock` beside `Label` and `Settings`; a package is not named as
    the framework it wraps, `Photos`; a single value the root
    supplies, the date, is a contract of one `let`; the log is not a
    reason to change a signature from the model to its id; a second
    delete while one waits for its undo first commits the waiting
    one; a task captures the contract and calls it, not the closure,
    which reads as a read; a call made on appearance is in every
    block of the node after `System->>Node: appears`; the photo
    picker's cells are `app.images` with `PXGGridLayout-Info`; in the
    CoreFlow skill, `switchOrCheckBox(_:)` is on the app and returns
    the element. Into both briefs: nobody answers during the run, so
    where a skill says to agree with the owner the agent decides and
    reports. Reported and left: the date is built once at the root
    and is stale past midnight, as in F58; a reminder already overdue
    fires in five seconds, which the brief does not cover; the real
    photo load and the real notification delivery are untested, since
    a `PhotosPickerItem` cannot be built in a test and a notification
    needs an app bundle.
  - **F67, the drift review after F36 to F66.** 2026-11-12, the owner:
    "can you check the drift versus original mission of this repo?"
    Run by `scripts/drift-review-prompt.md` on Opus high against the
    state at `e8d550c`, the first five commits exported as trees. Of
    sixty-six early ideas it called thirty-one kept, fourteen
    transformed, seven weakened, two lost (the mv-architecture
    pointer, the `@AppStorage(key)` label), and nine reversed, every
    reversal a recorded ruling: the maps apart from the code (F51,
    F61), `@AppStorage` as the root's through a `settings` cylinder
    (F32), sets as sorted arrays (F31), the workflow node and the
    contract-line criterion and "who fired it" (F21 to F30), the
    test host drawn nowhere (F24), rulings outranking the skills
    (`AGENTS.md`). Verdict: the structural bet kept nearly verbatim,
    the evidence oracle matured, three moves it calls drift rather
    than maturing, rulings in `TODO.md` outranking the skills, any
    rule breakable for practicality (F40), and the engine run with
    nobody agreeing the map (F66). Fifteen live contradictions, most
    from the day's layout and vocabulary rulings applied to some
    files and not others. Eleven were text and are fixed in this
    commit: "No map knows more than one level" now says hand-written
    map and names the whole-app diagram a derived view; "beside its
    code" in the mapping skill and the README; the top node's example
    link `(../../APP-MAP.md)` in both; `notation.md`'s two sentences
    giving a leaf a `MAP.md`; the README's four questions; "exactly
    those arrows" in the README and `notation.md`, now the names
    exactly and the values as the author sees fit (F31); the three
    "ever"s F56 missed; Diagram 3's "no usage lines" scoped to that
    diagram; "the node is the logic", "the core's logic" twice, "its
    own logic", and "or logic" reworded (F62); the vocabulary table's
    "source of truth" row renamed "input"; "stays with it" made "stays
    with the feature, run above the view"; the `inject` name
    reconciled with "neither is injection"; the `@Observable` clause
    of F62 bound to the two class cases; "a method" in the layer's
    list made "a method written by hand" (`@Flowable`); the
    architecting workflow says the agent decides and reports when
    nobody is there to agree (F66); the checker's docstring says map
    file. Its restore list, for the owner: fold the standing rulings
    into the skills and make `TODO.md` history that never outranks
    them; a hard stop for the map diff in engine runs; payload
    determinism as equality between the block and the test array; a
    compiled ground-truth app in reach of the repo. The fourth item,
    depth 1 restated to be true, is done above.
    The second reader, Codex Astra at high effort, read-only, on the
    state after those fixes, `a09828c`, the owner: "should we run
    prompt with astra?". Forty ideas, one lost (fast feedback), four
    reversed, all rulings, and the same three moves called drift,
    speed discarded, payload checking discretionary, agreement
    yielding to practicality, under a rulings log that outranks the
    skills. Six contradictions, four text and fixed in this commit:
    "fails on any node built from objects" now names the object that
    owns state and behavior and admits a model class read as data;
    the README's "before the next is started" carries the callback
    exception the skill has; the README's "No protocols, no classes"
    names the exceptions; `notation.md` no longer says an id that
    differs from its name fails "with no error", since the checker
    reports it. Two need a ruling and are open: the CoreFlow skill
    puts a draft no criterion names in "a furniture view, a form or a
    row that is no node on the map", handing the value back through a
    plain closure, while the cut rule says a callback makes a node
    (TODO, "a callback alone makes a node"); and `loop` when the
    requirement names no count, "the test then asserts the decision",
    has no stated assertion shape beside the whole-log equality. Its
    restore list adds to Opus's: a speed objective for feedback, and
    one assertion grammar for order and count. It also found the
    export script wrote one commit line into `commits.txt`, the range
    was the fifth commit alone; fixed to the first five lines of the
    log.
  - **F68, every ViewModel converts with no remainder.** The owner,
    2026-11-12, thinking out loud: "basicaly every viewmodel can be
    transformed: rip it off into state and logic, lift both, consume
    let or bindings or even reference model as pure model... but also
    lift logic and do mutation in same way - operating on bindings to
    perform mutation.... is it? it fits to this 'how its consumed'
    philosophy?". It does. A ViewModel holds state and the behavior
    that mutates it and nothing else. The state lifts and is consumed
    as a `let`, a `@Binding`, or a reference model read as data. The
    behavior lifts and is consumed the same way, as a closure that
    mutates through the same bindings the view reads, or the same
    model object. Both halves arrive as values, construction above
    and capabilities below (F60), they meet in the binding, and
    nothing is left over that needs an object. The code skill's rule
    paragraph, `converting.md`'s table introduction, and the
    `AGENTS.md` lift rule say so. The owner, next: "and also about
    reverse engineering it can help". It does. An object found on the
    walk is the node's contract in object form and is read as one,
    its properties the node's state or handed bindings, its service
    calls the `· dep.func()` lines, its writes to shared state the
    `· $path` lines, its parent-given closures the `· name` lines.
    The object gets no node and no cylinder. `reverse-engineering.md`
    says so under the walk.
  - **F69, the repo read against the articles.** The owner,
    2026-11-12: "check if this repo aligns with articles, what is
    this repo missing or what is this repo wrong". Codex Astra was to
    read and hit its usage limit before the first line, so a fresh
    Opus at high effort read the seven articles and the two proposals
    under `~/dev/articles`, then both skills, every reference, and
    the CoreFlow skill, and listed 105 ideas, each marked aligned,
    transformed, weakened, missing, or reversed. A Fable agent
    checked that report line by line, and the cited lines were then
    read once more by hand. Verdict: a faithful distillation of the
    masterclass and the method article, much of it word for word,
    with every large departure a recorded ruling (F22, F23, F31, F32,
    F36, F37). The report quoted exactly and classified too strongly.
    Of its five missing items, the plan as data was already refused,
    as Wlaschin's interpretation, "too clever", in `modules.md`; the
    sectioned-results mock is in the swift-core-flow README; the
    token refresh has its parts in the skill; "Mock Roles, Not
    Objects" is an argument and not a rule; and the client generated
    from the server's document became the second ruling below.
    Three rulings came out of the discussion. Closures in the
    environment, the owner: "environment closures are fine because
    we inject them high at hierarchy". Apple's guidance advises
    against a closure in a custom environment key, since a closure
    cannot be compared and setting it again invalidates its readers.
    A contract is set high in the tree, at the root, where that is
    rare, and the contract bullet now says so. The backend, the
    owner: "backend contract normaly is generated with openspec api",
    "bckend is just struct of closures", and "backend models go to
    data layer". This reverses `32c1b6a`, "wire types stay in the
    backend package". The generated contract and its models live in
    the layer, the backend package holds the wiring, and the
    networking bullet carries the networking draft's reason, that a
    contract typed by hand is a second copy of the server's document.
    One sentence there is the agent's and not the owner's, that what
    a generator or a macro writes is taken as it is, since a
    generated file carries members the layer rule would refuse from
    a hand. Conformances, the owner, first on `Codable` and then
    "similar with identifiable as long you dont introduce behaviour
    to models or computed properties". This reverses "they conform to
    nothing" and the sentence that the root encodes a dictionary
    because a synthesized `Codable` cannot be declared from another
    file. A model may conform where the conformance adds no behavior,
    and one that needs a method or a computed property is not
    declared on it. `id: \.id` at the call site stays a fine
    spelling, and the two older engine prompts no longer forbid
    `Identifiable`.
    One question needed no ruling. The networking draft creates its
    single-flight refresh task in a closure the root builds, and the
    F37 do-not read as refusing any `Task { }` there. F37 is about a
    task nobody holds. That task is assigned through a binding to a
    slot the root owns, a held form the rule already names, so the
    do-not now says "nobody holds" and gives the case. Two more were
    the skill's own answers and stand: who owns the load is a choice
    per feature, so the core that owns its loading flow stays, and
    "closures the root sets" are the owner's words in the four keys.
    Text that had fallen behind a ruling or a fact, fixed. "Inside a
    class they do nothing" now excepts `@Binding`, which a
    transformer is built from, and says what the others do; measured
    on the 27.2 SDK, `@State` in a class drops the write and
    `@AppStorage` writes to the defaults and does not follow them.
    The wireframe sentence names the `@Environment` read (F23).
    `shell-core.md` no longer calls `@Query` a source of truth (F32),
    and the first I/O shape is "input" in its table and in
    `testing.md`'s (F67). `data-flow.md` no longer passes a form's
    fields as one bundle (F36). The one integration test of a
    boundary was "at the shell" in five places and is now where the
    live value is built, the dependency's own test target. The
    direct-construction section of `testing.md` gave its verdict and
    then the article's praise, and the two paragraphs are in order
    now. Its sentence that a nonisolated test "traps under strict
    concurrency" was measured false on Swift 6.4, and so was both
    readers' correction, a compile-time error. The call compiles
    with a warning and runs off the main actor. `data-flow.md` said,
    with the masterclass, that a `@State` initial value is "evaluated
    at every creation". Measured on the same SDK, a private one is
    not evaluated at creation, zero times over three creations
    against three for one that is not private. `shell-core.md` says
    what a value left out of `dependencies:` costs. The validation
    record carries a note that its printed maps predate F32 and F61.
    The README's three strong words are reworded, F56 having named
    the skills and not the README.
    Not done. A stateful fake, which only the manifesto's draft
    proposes. An exemption for a stateless helper, since the skill
    already says a stateless struct's methods make no object. A
    README sentence on who draws the map in an engine run, open
    under F67. The Query article in the source lists, since it is
    published unlisted. The `dependencies:` sentence in the CoreFlow
    skill, which is another repository.
    Where the articles now say otherwise, kept as F23 keeps its
    record. The masterclass: `@Query` among the sources of truth and
    the environment among the machinery (F23, F32), `@AppStorage` in
    the feature's shell (F32), two levels of one unit (F23), and the
    `@State` initial value. The method article: the shell owns the
    one ambient read (F23), `.task(id: pendingSave)` (F37), the log
    as a set (F31), "When unsure, lift" (F32), and `let id = UUID()`
    on a model its literals build inside `body`, a new identity each
    wave. The Query article: "`Query` is a source of truth" (F32).
    The networking draft agrees with the layer after this ruling.
  - **F70, the address form after F69.** The owner, 2026-11-12: "run
    sonet medium adress form prompt". `scripts/engine-run-prompt-address.md`
    verbatim, Sonnet at medium effort, an empty directory, six
    minutes. Every gate green, rerun by hand: `mapcheck.py --sources`
    3 files, 5 blocks, 2 nodes, 1 cylinder, 0 errors, 0 warnings,
    0 unverified; the dependency's integration test and four plain
    tests of the transformer; `generate.sh` twice byte-identical; the
    app built and three hosted tests green in the iPhone 18 Pro
    simulator, the valid save's sixteen entries in order, the four
    required errors sorted, and one own-state array. The shape is the
    one the earlier runs reached, a `@Shell` node with loose state, a
    `@Capability` transformer, a core read off the screen, the model
    assembled on Save. F69 shows in it: `Address` is `Codable` in the
    layer and the dependency encodes it, with no dictionary. What the
    run does not show is the generated backend and the shared task,
    since the form has no server. A brief with one is not written yet.
    Of its eight notes two were text. `@Shell` rejects an optional
    `@State` that has no `= nil`, "needs an inline default", and the
    CoreFlow skill said only "explicit type"; it now names the
    default. The test host's links disagreed: the module table and
    the prose said the features and the host product, and the two
    scripts also linked `CoreFlow`. The run built and tested without
    that line, and swift-core-flow's own hosted project has no such
    line, so the scripts lose it, and the CoreFlow skill says the
    host reaches `CoreFlow` as the app does. One note was wrong, that
    no skill gives the sorted comparison, which the CoreFlow skill
    states. The rest were the design's to decide: the core's name,
    the error a default closure throws, and a failed save that shows
    nothing because the brief shows nothing. The CoreFlow skill also
    gained F69's sentence on a value left out of `dependencies`.
  - **F71, the address list, and what a test does not prove.**
    `scripts/engine-run-prompt-addresses.md` verbatim on 2026-11-13,
    Sonnet at medium effort (16 minutes, 219k tokens) and Opus at high
    effort (13 minutes, 256k tokens), each in an empty directory.
    Both green on every gate, rerun by hand: `mapcheck.py --sources`
    6 files, 8 blocks, 3 nodes, 1 cylinder, 0 errors, 0 warnings,
    0 unverified; the plain test of the Save rule and the dependency's
    integration test; `generate.sh` twice byte-identical; the app
    built and eight hosted tests green in the iPhone 18 Pro simulator.
    Both drew the same map, the root, the list, and the form under
    `isAdding`, with one cylinder, each screen a `@Shell` node over a
    hand-written core, the query a static expression proven against a
    seeded in-memory container. Opus tested its dependency against a
    store on disk, closed and opened again, and called `save()` in
    both writes. Sonnet tested in memory and left saving to the
    context. The owner, the same day: "integration shell test with
    swiftdata is best inmemory", and "maybe clear rule - dont test
    fucking apple". Ruled: a test proves what the app wrote, not what
    Apple's framework promises. The dependency's own test stays, one
    line of code or not, the owner again: "we are testing not apple -
    but we test if insert did its job - thats fine", and "we can check
    by reading directly - not trough query", so that test fetches from
    the context and has no view. The sentence is in
    `data-coupling/SKILL.md`, `references/app-structure.md`,
    `references/testing.md`, and `AGENTS.md`. Open from the two runs,
    not ruled: a `@Model` logs as its type name, so neither delete
    test can tell which row was handed on, and Sonnet reshaped `add`
    into two strings for the log's sake; a text field also writes
    twice on focus and twice when focus leaves it; the two runs
    opened the container in different places, Sonnet inside `inject`
    and Opus in the app file; `Query(sort: \Book.title, order:)` in
    `shell-core.md` sorts case-sensitively, measured with swiftc on
    the generic key-path descriptor, `["Birch", "Cedar", "alder"]`,
    while `SortDescriptor(\.street)` does not; a `loop` block has no
    test shape (F67); and whether a node may swallow a thrown failure
    the brief does not mention.
  - **F72, a value built from an input.** The owner, 2026-11-13: "see
    my critique of pointfree and propose if you find anynew rules from
    my repo", the repo being
    [LazyStateAntipattern](https://github.com/sisoje/LazyStateAntipattern),
    and after the proposals, "ok do whats best". The critique takes a
    child that builds a model from its parent's value and holds it
    three ways, `@State` built in an `init`, Point-Free's
    `@LazyState`, and a Memo keyed by the input, one UI test each.
    The skill had the trap and `MemoView` in one paragraph of
    `data-flow.md`. That paragraph is now a section, "A value built
    from an input", with what the critique says beyond it. The two
    requirements, follows the input and kept otherwise. A seed made
    lazy removes the waste and keeps the staleness. The repairs by
    name, `.id()`, `.onChange(of:)`, `.task(id:)`. The first way out,
    which the skill did not have, that the event which mounts the node
    or changes the input builds the value above and hands it down. The
    second, derived in the child, a computed property or a Memo. The
    Memo's two limits, that a changed dependency replaces the whole
    value and that a value left out of `dependencies:` is not
    followed. And that a binding shares a value and does not rebuild
    what was built from it. A do-not in `SKILL.md` and a hard rule in
    `AGENTS.md` carry the short form, and step 3 of the `.onChange`
    ladder says a reaction that writes own state from an input is not
    terminal. `.task(id:)` is still the event for a load, whose
    result is new data and not the input again. Two sentences are the
    agent's and not the owner's. That the first way is the default,
    which follows from the lift and from the README's "needs no
    machinery". And the editor example, a field filled by the tap
    that presents the editor, which applies the ruling recorded under
    F34, that a given which would seed own state says the state is
    not the node's. The proposal had said that failing either
    requirement makes a second source of truth. Only failing the
    first does, and the section says so.
    Measured before it went in, with a scratch app of the agent's
    own, ten UI tests green on the iPhone 18 Pro simulator, iOS 27.2,
    Xcode 27.2 (27B52), Swift 6.4.2. The script is one unrelated
    write in the parent and then one write of the input, which ends
    at 2. `@State` built in an `init` showed input 1 and 3 models
    built. A hand-written lazy box in `@State` showed 1 and 1.
    `.id(input)` over the first showed 2 and 3, and a counter in the
    child's own `@State` went back to 0. The parent's event showed 2
    and 2. A Memo showed 2 and 2 and the child's counter kept its 1.
    `.onChange(of: input)` ran `body` with the pairs 1/1, 2/1, 2/2,
    input beside model. `.task(id: input)` ran 1/1, 1/1, 2/1, 2/2 and
    built a second model for the first input at appearance. The
    critique's own three tests were not run here. The permission
    layer refused to build a clone that fetches a third-party
    package, so the `@LazyState` row stands on the critique's README
    and its CI, and the lazy row measured here is the hand-written
    box. swift-core-flow's README already had the left-out
    dependency, and its hosted scenario already pins the replaced
    instance, `taps 0` after the seed changes. Its README and its
    skill row gained the sentence the same day.
    Read cold the same day by a fresh agent given `SKILL.md`,
    `data-flow.md`, and `notation.md`, ten questions and one design
    task. All ten answers and the design, a title written by the Edit
    tap into the list's own state and handed to the editor as a
    binding, were the intended ones. It listed 32 sentences it had
    read twice, and each was reworded. What the rewording added. The
    second requirement counts only for a thing that holds state or
    costs something, so a computed property is no breach of it. Who
    may know how the thing is built decides between the two ways, the
    parent or the child, which is the README's "the child stays dumb"
    and "the parent stays dumb". The value is built into `@State` of
    the node that mounts the child, not of whoever owns the input's
    own source of truth. `MemoView`'s first argument is an
    autoclosure. A binding to the input is not a third way. In F73's
    bullets, a run's registration is in place only when the run ends,
    which is why the first run does not loop, measured with swiftc on
    Swift 6.4.2, `withObservationTracking` around `count += 1` three
    times, the change handler fired 0, 1, and 2 times. One pull it
    found is not resolved here. `SKILL.md` allows an `.onChange` that
    makes a terminal call, and `notation.md` asks a block of every
    node with a call on its label, so that node owes a block whose
    when F74 leaves open.
  - **F73, what a read in `body` registers.** From the same repo, two
    comments in its `Model.swift`, each measured with the F72 scratch
    app before it entered the execution scheme in `data-flow.md` and
    the dependencies bullet in `SKILL.md`. A static read in `body` is
    no dependency. A row whose one input was the kept model showed a
    plain static count of 1 while three models had been built, and
    its parent, whose `body` had run again, showed 3. An observed
    property read and then written by code a `body` runs, `count += 1`
    in an `init`, registers that `body` against what it writes. At
    launch the count was 1. After one unrelated tap the `init` had
    run to 300, the cap set for the measurement, each run
    invalidating the next. The same count written with no observed
    read grew by one per creation. The same read and write inside a
    Memo's build ran twice for two inputs, since the second run of
    that `body` did not build again, so the loop needs every run to
    repeat the write.
  - **F74, `Parent->>Node`, the half the critique settles.** The item
    near the top of this file had two readings and waited for real
    material, a parent handing down a new value mid-scenario. The
    critique is that material for one of them. A node that answers
    the new value by writing its own state is repairing a seeded copy
    (F72), so the reaction is no when and no block is declared for
    it. `notation.md` says so. The other half the critique does not
    reach. A terminal reaction, `.onChange(of: selection) {
    haptics.play() }` on a selection the parent owns, makes a
    boundary call that logs, and the block has no stimulus to name
    for it but `Parent->>Node`. That stays open, and the checker
    still warns. The proposal to the owner had said the critique
    settles the whole item. It settles this half.
  - **F75, the common forms beside what replaces each.** The owner,
    2026-11-13: "we maybe need to list common antipatterns and porper
    solutions like init-query and onappear hacks... did we?" The
    do-not list in `SKILL.md` is that list for the method, and seeded
    state had entered it under F72. The query built in an `init` was
    prose in `shell-core.md` only, and `.onAppear` did not occur in
    either skill. `data-flow.md` now ends its section with a table,
    eight forms, what each does, and what replaces it, and the do-not
    names the `.onAppear` seed, the query built in an `init`, and
    `.onAppear { Task { } }`. The owner again: "apple already
    released ways how to patch code for ios27 when they added state
    macro... but they only propose workarrounds not root cause and
    proper solutions". Apple's note on the macro answers "variable
    used before being initialized" with "Drop the initial value
    expression at `@State` decleration, only assign it in the init."
    That spelling is the table's second row. Measured with the F72
    script on the same simulator. `self.model = Model(input: input)`
    in an `init` with no initial value at the declaration showed
    input 1 and 3 built, the same as `State(wrappedValue:)`.
    `.onAppear { model = Model(input: input) }` over an optional ran
    `body` with the pairs 1/nil, 1/1, 1/1, 2/1 and built 1.
    `Query(filter:sort:)` built in a child's `init` over a seeded
    in-memory container showed the items for the new input, was
    constructed 3 times, and left the child's own counter at 1. The
    last row, the `Task` in `.onAppear`, is F37 and was not measured.
  - **F76, a struct's creation is not a lifetime.** The owner,
    2026-11-13, three messages while F75 was written:
    "struct-creation is absoulytely a nono for class init lifecycle",
    "query init or viewmodel init inside struct init are absolute
    idiotic", and "imo apple introduced macro to be lazy not because
    of lifecycle hacks, but simply because heap alloc is expensive".
    This is the cause the forms of F75 share, and the skill had it
    for work, "nothing that creates a value starts work", and not for
    construction. The lifecycle bullet in `SKILL.md` now says that
    creation builds nothing that has a lifetime, a class instance or
    a query, and that what has one is built by an event, by the root,
    as a private `@State`'s initial value, or as a Memo's build. The macro's deferral is written as the owner reads
    it, a saving of the allocation at every creation and no licence
    for a lifetime started at creation, in that bullet and beside the
    measured sentence in `data-flow.md`. The table of forms names the
    one cause, `AGENTS.md` carries a sentence, and `converting.md`
    has a row for the object built in a view's `init`, the legacy
    form, measured the same way, a `StateObject(wrappedValue:)` over
    a class built from the input showed input 1 and 1 built.
    Two more messages the same hour. "yes people conflating
    view-struct with a real view, and confuse real-view lifecycle
    events with struct lifecycle". The lifecycle bullet had the first
    half, "taking the one for the other is the object habit". The
    cause paragraph over F75's table now says both halves. And, of
    the critique's "create it on the event": "never ask where to
    execute code on first appear - execute it on that action that
    cause the struct to appear on the graph!" That is F72's first
    way, and its bullet and the do-not now say it in those terms.
    Where it meets F37, the text keeps F37. A load that belongs to
    appearance is still `.task`, and what moves to the action is what
    the node is to hold when it first appears.
    Read cold a second time by a fresh agent given `SKILL.md`,
    `data-flow.md`, `converting.md`, and `shell-core.md`, nine
    questions and a design task on F72 to F76. Nine of nine as
    intended, and the design kept its timer in a `MemoView` keyed by
    the id. It listed 41 sentences read twice, reworded the same
    day. Two of them were wrong and not only unclear. "The view on
    screen appears once and goes once" was unmeasured and false, and
    the cause paragraph had put the `.onAppear`, `.onChange`, and
    `.id()` rows under creation, where they are the screen's
    lifecycle asked to make up for it. Both readers found the same
    pull and it is not resolved here. A draft no criterion names
    lives below the core (F25), and a draft that starts from an item
    is written by the tap above the form, which is F67's open item.
  - **F77, the action that mounts a node does its work, not the
    lifecycle of the view on screen.** The owner, 2026-11-13: "dude
    view modifiers are abusing physical-view lifecycle and are
    hacks... if we can determing what triggered struct to popup into
    graoh then we need to ro action there only... task will refire on
    reappear - we need to do state handling our own not let the
    physica-view do that for us its lame". This reverses the half of
    F37 that kept `.task` "for appearance and for a value that
    already exists". Measured first, on the same simulator. A screen
    under a `NavigationStack` with a `.task`, an `.onAppear`, and a
    `.task(id:)` over a constant ran each of them once at launch and
    a second time after a push and a pop. Under a `TabView` the
    `.task` and the `.onAppear` ran a second time after the other tab
    was selected and left. A count written by the tap that pushed a
    detail stayed at 1 after a deeper push and a pop. Written as fact
    in the lifecycle bullet and the task paragraph of `SKILL.md`, in
    the do-not that was "`.task` for work an event starts" and is now
    "A lifecycle modifier for work an action starts", in the task
    hard rule of `AGENTS.md`, in three places in `data-flow.md`, the
    first way's bullet, the last row of the table of forms, and step
    2 of the `.onChange` ladder, and in two rows of `converting.md`.
    `shell-core.md`, "Who owns the load", opens with the worked form,
    a list whose tap assigns the load to a slot it holds and hands
    the detail a `let`, type-checked with swiftc in Swift 6 mode with
    a plain `@State` in place of the slot. `.task` is what is left
    when no action can be determined, the first screen at launch and
    a subscription the root holds. What the owner did not say and the
    text now does. `.task(id:)` is treated the same, since it is a
    view modifier and measured the same, so a refetch is started by
    the write of the value, in the setter of the binding its owner
    hands down, which the `.onChange` ladder already said. F69's
    "who owns the load is a choice per feature" now holds only for a
    node no action mounts. The two older examples in that section
    were first kept as that node with a sentence beside them, and a
    third cold reader, the same day, called that the worst pull in
    the text, since the one refetch shown in code was
    `.task(id: sortByAuthor)` and the rule beside it sends a refetch
    to the setter. `BookShelfShell` is rewritten. It holds the
    `NavigationStack`, its `.task` hangs above the stack, and the
    refetch is assigned by the setter of the binding it hands the
    core. Measured for it, a `.task` on the `NavigationStack` itself
    and one on the `TabView` itself each ran once across a push and a
    pop and across a change of tab, and the rewritten shell
    type-checks with swiftc. That reader answered nine of nine as
    the text intends and put the launch load on the node above the
    tabs unprompted. What else its 40 notes changed. `.onChange` is
    out of the sentences about reappearance, where it does not run
    again. The lifecycle bullet says creation first and the screen's
    lifecycle second. The do-not says the method names no use for
    `.onAppear`. "Another tab is left" is "the user comes back from
    another tab". Left open there and closed by F79, a subscription
    in a node that a tap mounts.
  - **F78, the rules under their older names.** The owner,
    2026-11-13: "dude why is this so hard to define all these rules?
    boundaries, effects,,, is there some book from data-flow
    programming from 1970 or later that explains this? we can not
    continue with this OOP garbage in our heads". The answer given
    named three reasons and a list of sources, and its third reason
    was wrong, that SwiftUI is not pure data flow. The owner:
    "SwiftUI is not pure dataflow. - this is fucking wrong, swiftui
    is absolute pure fucking data flow, it just offers you free
    introduction of "source of truth" so a new data comes out of
    nowhere!? so can you help agents by noting your references
    somehow?" And of the first reason: "this is awesome", quoting
    "each rule first has to un-say a word that carries the UIKit
    model". `data-flow.md` now has a section before its source list,
    "The rules under their older names". It opens with the owner's
    sentence on pure data flow and with the un-say sentence, and it
    is one table of eleven rules, each beside its older name and its
    source, a process in a dataflow network, a data flow diagram,
    information hiding, essential against accidental state, change
    propagation, a correct and minimal build, a behavior against an
    event, a reactive against a transformational system, an output on
    the transition against one on the state, and values as the
    boundary. `SKILL.md` points at it from its references. Every
    citation was checked against the web the same day, author,
    title, venue, and year. Two details were left general because
    the check did not reach the primary text. The table names the
    four parts of a data flow diagram in today's common words and
    not as DeMarco's own, and it cites Harel's statecharts only for
    an event that triggers a transition. The pairing of each rule
    with its older name is the agent's reading of those sources. The
    third cold reader found two of the older words turned against the
    skill's own, "behavior", which there is a value over time and
    here is closures, and a build's "task". The table now says a
    step, and says whose behavior it means. It also found "pure data
    flow" beside "Neither is data flow" in the section on boundary
    events, and the opening now says what pure means, that nothing
    but values couples the nodes, and that a boundary event comes
    back into the flow only through a source of truth.
    What the table is for, the owner, 2026-11-14, after the agent had
    called its hedged rows a weakness and proposed keeping only the
    five solid ones: "as penrose said the key of understanding is
    knwing "WHY" rules are true, not knowin just "THAT" they are
    true... maybe my rules are wrong or misinterpreted, thats why wee
    need references you recognized so if anyone wants to know WHY
    rules is the way it is he can read the reference for more
    details". The table stays whole. Its lead now says it is for the
    why, that a rule here may be wrong or misread, and that a row
    which says the method goes further than its source marks the
    method's own claim, the first place to doubt. `SKILL.md` points
    at it in the same terms. No sentence of Penrose's is quoted in
    the skill, since a search found his argument and no such
    sentence. The nearest is that a reasoner has to see that each
    rule is valid and not only follow it, in *Shadows of the Mind*
    (1994).
    Codex Astra at high effort then judged the table row by row, the
    owner: "can you ask astra and lets discuss after answer?". Two
    rows correct, six loose, three wrong as equivalences. A
    dependency that reaches outside the app is a terminator in a data
    flow diagram and not a data store. Mealy, Moore, and Harel name
    both places an effect can hang and prefer neither, so the choice
    of the transition is the method's and not theirs. And the core
    here calls closures it was handed, so it is not Bernhardt's pure
    core. The three rows are rewritten, each loose row says where the
    method goes further than its source, and the lead says a pairing
    is a lineage and not an equivalence. Astra also found that "none
    of the repairs removes the second source of truth" did not fit
    `.id()`, which does follow, and the sentence now says the copy.
  - **F79, a lifecycle modifier only on a value the app's code does
    not control.** Astra had been asked four questions the agent
    called open, and the agent then put the first one to the owner as
    a choice, the write starting the refetch or `.task(id:)` above
    the stack, and recommended the second. The owner, 2026-11-14:
    "dude are you moron?", then "you can use task with id only if id
    value is not controllable by your code", and "if the id is
    calcualted by your own data - then why the fuck you need
    UI-runtime to drive your actions further???" F77 had answered
    it, and the question was not one to ask. Written as he said it,
    with the reason, in the task paragraph and the lifecycle do-not
    of `SKILL.md`, in `AGENTS.md`, and beside the shelf example. The
    same rule closes what F77 had not reached, without another
    question. A subscription a mounted node needs is started by the
    action that mounts it and cleared by the write that ends its
    interval, through the binding that presents the node, and only
    the root's, for the life of the app, starts in `.task`.
    `.onChange` is what is left for a terminal reaction to a value
    the app's code does not control, the scene phase, so step 3 of
    the ladder and the `.onChange` do-not now send a haptic, a
    scroll, and a dismissal to the write. `Parent->>Node` is not a
    stimulus, since a parent's value changed by a write and the node
    that handles the write makes the call. `notation.md` says so, the
    checker's warning says so in place of "open question", and a
    value the system supplies is a `System` stimulus. Astra's two
    findings on the rewritten shelf are fixed inside the rule. Launch
    and the setter go through one function and one slot, so a toggle
    during the first fetch replaces it and a replaced fetch writes
    nothing, type-checked with swiftc. And the text says who builds
    the setter, the node every write of the value passes through, its
    owner when it is written in more than one place. Not changed,
    "the first way is the default" in F72, which Astra called
    unsupported and the owner has not spoken to.
  - **F80, the app does not observe its own changes through the UI
    runtime.** The owner, 2026-11-14, after F79: "same thing with
    onchange... you dont observe your changes trought ui-runtime, you
    need to intercept and controll them like a normal person, and not
    like an idiot that doesnt know who mutates what". F79 had already
    carried the rule to `.onChange` as its own consequence, and this
    is the owner saying it, with the reason, that the app knows who
    mutates what. The do-not that was "A chain of `.onChange`
    modifiers" is now "`.onChange` on a value the app writes", with
    the chain as its worst form. Step 2 of the ladder in
    `data-flow.md` and the task hard rule in `AGENTS.md` carry the
    sentence. Measured under F72 and still the fact behind "a wave
    late", a `body` ran with the new input beside the old value
    before the `.onChange` write landed.
  - **F81, the system is heard in one place and handled by a core.**
    The owner, 2026-11-14: "but even for the scene phase, whichever
    view uses that it is the shell we need to be carefull of how to
    test it. we may decide to use flowup and make a core that habdles
    scene change? so our sc enario test can simulate scene change",
    then "similar is with onopenurl - we can not tes really
    onopenurl, but we can make a core with flowup and test core by
    making own modifier and shell will just redirect onurl to the
    defined flowup?", and "itsthe same underlying problem, the shell
    modifier that relies on external system, wee need to extract the
    core so we can test core, only leave onopenurl at one place up in
    the app hierarchy and scene change also up". Written as one rule.
    A modifier only the system fires is a shell no test can drive, so
    it is one line in a modifier at the root that forwards the event
    into a `@FlowUp` flow, the handling is a core that listens with
    `.onFlow`, and its scenario emits the flow with a control. In the
    scenario bullet and the `.onChange` do-not of `SKILL.md`, with
    the form and its code in `modules.md` beside the paragraph that
    already taught `@FlowUp`, in step 3 of the ladder, in
    `notation.md` where a `System` stimulus is named, and as a hard
    rule in `AGENTS.md`. Two limits are the agent's and not the
    owner's. The scene phase as a fact is still data a node reads,
    and the root's accumulators are for the few events that are the
    system's and app-wide. Measured with swift-core-flow from the
    local checkout in the scratch app, iOS 27.2 simulator. A listener
    in a stack's first screen heard an event emitted from a screen
    pushed over it, and one in the first tab heard an event emitted
    from the second. With the root modifier in place and no control,
    pressing Home and coming back left the listener's own log at
    active, inactive, background, inactive, active, the first of
    them from launch. That a control calling a flow reaches the
    listeners was already pinned by the library's own
    `FlowUpUITests`. The modifier's `.onOpenURL` line was fired last,
    with the scheme registered and the system opening
    `flowmeasure://book/42`. The listener showed the link with the
    app running and again from a cold launch.
    The owner, after the first wording: "the rule need
    to be clear so that agent can recognize if dealing with external
    system data in modifier-  he needs a flowup to make testable
    core". The rule is now a do-not of its own in `SKILL.md`, "A
    modifier fed by the external system, inside a feature", which
    opens with the test an agent applies, who can make the modifier's
    closure run, names the modifiers, and gives the four steps. The
    scenario bullet keeps a pointer, and `modules.md` and `AGENTS.md`
    open with the same test. A fresh agent then designed a link and a
    timer that pauses in the background by the rule, with a prompt
    F82 disowns, so only its list of sentences was used. One was
    false. "Only the system runs the closure, so no scenario can" does
    not hold for the scene phase, which a scenario can set through
    the environment, type-checked. The test is now the owner's own
    criterion, where the modifier's event or data comes from. Closed
    with it, a reading in which `.task(id: scenePhase)` in a feature
    was licensed by F79's sentence. Added, the scenario's own code in
    `modules.md`, where the accumulator is the scenario's to apply
    and the control sits below it, that the forwarding modifier is a
    dependency package like any other with the flows declared in the
    layer, and that the listener sits in the node that owns the state
    the handling writes.
    The run by F82's brief came back last, the product, the two
    requirements, and the stack, with no word of architecture. It
    recognized the case. Two flows declared in the layer, one
    `SystemEvents` modifier at the root with a forwarding line for
    `.onOpenURL` and one for the scene phase, the handling in the
    library's node with `.onFlow`, a scenario with controls below its
    own accumulators, and no `.task`, `.task(id:)`, or `.onAppear` in
    a feature. It also took F79 unprompted, a slot cleared in the
    setter of the binding that presents the reader. It named the two
    forwarding lines as what is left untested, and a link on a cold
    launch as a risk the skill is silent on, which was then measured
    and holds. Seven of its 23 sentences were the new text's and are
    reworded. "Every write that ends the interval" had no interval and
    left out an event. "Below the accumulators" meant deeper in the
    tree and earlier in the chain. "The same `EnvironmentValues`
    extension" named none. The sentence against a root accumulator
    read as a ban on the two the rule asks for. And the naming rule
    had no place for `scenePhaseChanged`.
    The owner, told that a scenario can set the scene phase: "yes the
    system can set scene phase but anyway... what if it could not? i
    mean ok dont be specific frame it in general?" The do-not, the
    paragraph in `modules.md`, and the hard rule now state the rule
    first and in general, the source of the event or the data being
    outside the app, with the three modifiers as examples and not the
    list, and say that whether a test could fake the source does not
    enter into it.
  - **F82, a brief is in a manager's technical language.** The agent
    tested F81 on a fresh reader with a prompt that named forbidden
    patterns and whose follow-up questions gave the design away, one
    of them saying outright that a UI test cannot make Safari open a
    link. The owner, 2026-11-14: "so prompt need to be in a mostly
    manager technical language hat knows what tech stack he wants,
    but architecture is up to the rules and agent". This is F65 said
    of every prompt that tests a rule, not only of the engine briefs.
    `AGENTS.md` carries the sentence. The test was run again with a
    brief of that kind, the product, two requirements in the
    product's words, the stack, and what to hand back.
  - **F83, the principle by its name.** The owner, 2026-11-14: "dude
    ofcorse, we making rules so any agent need to follow 'functional
    core, imperative shell' principles". `shell-core.md` had it under
    "The lineage", Bernhardt, Wlaschin, and Seemann, "Pure logic
    inside, I/O at the edges", and `SKILL.md` did not say the name.
    The section "Cut: shell and core" now opens with it, as the one
    principle every rule serves, and F81's do-not says it is that cut
    again for the system's modifiers. One row of the older-names
    table is put back. After Astra's review the agent had rewritten
    it to say "the core here is not pure, since it calls the
    closures", which is Astra's stricter use of the word and
    contradicts the lineage paragraph, where the core decides as a
    pure function of its inputs and the handed-in closure does the
    write. The row names functional core, imperative shell again,
    with the three sources the lineage gives.
  - **F84, the check after F83.** The owner, 2026-11-14: "check if we
    did not forget something? maybe we overdid something? was all
    clear and common sense?", and of the list that came back, "again
    what to do about htis". Done without a ruling, since each follows
    from one. The lifecycle bullet of `SKILL.md`, 34 lines and six
    ideas after three passes, is three bullets with the same
    sentences, that lifecycle is an effect of the graph, that
    creation builds nothing with a lifetime, and that the action
    starts the work. `LoadingShelf` in `shell-core.md`, the last
    example to load from a `.task` on the screen itself, hangs it
    above the stack. A tap that goes through the navigation contract
    has its load started by the node that answers the route. "The
    first is the default" is gone from `data-flow.md`. It was the
    agent's inference under F72, Astra called it unsupported, and the
    owner's README ranks neither way. Left as it is, "appearance
    work" as a reason to cut a node, which is still true of legacy
    code and of the node at launch. Still the agent's and not ruled,
    that the forwarding modifier of F81 is a dependency package. Not
    consolidated, the action rule's several statements, since each
    carries a fact the others lack.
  - **F85, the checker knows a flow and a lifecycle modifier.** From
    the same list. The map skill had no word for `@FlowUp`. By F27,
    which put Apple's sealed actions on the label as calls with no
    cylinder, a flow a node calls is written the same way,
    `· deeplink()`, and `mapcheck.py --sources` now derives it from
    an environment closure called by name and reports one with no
    line. A flow's event is a `System` stimulus in the listener's
    block, whoever emitted it, and listening adds no line. Both are
    the agent's defaults from F27 and from the three stimulus kinds,
    not the owner's words. The habits check gained a second warning
    beside the unheld `Task`, a lifecycle modifier in a view,
    `.task(id:)`, `.onChange`, `.onAppear`, `.onOpenURL`, or
    `.onContinueUserActivity` in a file that declares no
    `ViewModifier`, so the root's forwarding modifier and a plain
    `.task` pass. The unheld `Task` warning no longer ends "or use
    .task". Three findings planted in the broken fixture and asserted
    by `test.sh`, the clean fixture still at zero.
  - **F86, a third comprehension prompt.** From the same list. None
    of F72 to F83 had a question in either prompt of the code skill.
    `data-coupling/scripts/comprehension-prompt-3.md` has ten, on the
    seed, the lazy seed, a query or an object built in an `init`, the
    load started by the action, `.task(id:)`, `.onChange`, the launch
    load, an event from the external system, the struct against the
    view on screen, and the principle by name. Its design task is a
    brief as F82 asks, a recipes app, a link, and a timer that stops
    in the background, with no word of architecture. The two older
    prompts and their baselines are untouched. Run the same day on
    Sonnet at medium effort, which read `SKILL.md` alone and no
    reference. Ten of ten. Its design had the shape, a node above the
    stack that holds the load and the timer, a screen made of `let`s,
    listeners with `.onFlow`, a scenario that sends the events, and no
    lifecycle modifier in a feature. It had one error. It declared
    the two flows inside the root modifier and applied no collector,
    since the do-not gave four steps and said neither where a flow is
    declared nor that it is collected. The do-not gives five steps
    now. Four more sentences came from its list. A task writes state
    through a binding it captured. A repeating tick is a stream whose
    default finishes, not a delay awaited in a loop, which spins on a
    no-op default, and the F82 run had tripped on the same. A first
    screen that reads its list with `@Query` carries no `.task`. And
    state that a node's own action writes is reached in a scenario by
    driving that action, with the driven prefix in the log, which
    three readers had asked about. Measured for F79's sentence that a
    dismissal is a write through the binding that presents the node,
    which had gone in unmeasured, on the iPhone 18 Pro Max simulator.
    A pop by the back button wrote an empty path through the setter
    of the `NavigationStack`'s path binding, and a sheet swiped down
    wrote `false` through the setter of its `isPresented` binding.
  - **F87, Garden on the rules of F72 to F86.** The first whole app
    built since F71, `scripts/engine-run-prompt-garden.md` verbatim on
    2026-11-14, Opus at high effort, an empty directory, 37 minutes
    and 375k tokens. Every gate green, rerun by hand.
    `mapcheck.py --sources` 16 files, 18 blocks, 5 nodes, 6
    cylinders, 55 Swift types, 0 errors, 0 warnings, 0 unverified,
    with F85's warning active. `swift test` in the features and the
    five dependencies, 6, 3, 2, 2, 1, and 2. `generate.sh` twice, the
    same project. Eighteen hosted tests green in the iPhone 18 Pro
    simulator. What the new rules produced. No `.task`, `.task(id:)`,
    `.onChange`, `.onAppear`, or `.onOpenURL` in the app, no seeded
    state, and three `Task` expressions, each assigned to a slot with
    its bindings captured. A tap and a notification tap open a plant
    through one function of the list, which starts the weather load
    in a slot the list holds and hands the detail `let`s (F77). The
    notification tap is a flow, declared in the layer, collected at
    the root and in the scenario, forwarded by the Reminders
    dependency, and heard by the list with `.onFlow`, and its block
    opens `System->>PlantList: reminderTapped fern` (F81, F85). The
    sort is a `QueryView` keyed on its flag. The list holds seven
    `@State` and two slots, which is F77's cost and is readable at
    this size.
    Four findings became sentences. The system's event came through
    a delegate and not a modifier, which F81's form did not show, so
    `modules.md` and the do-not say the dependency hands the delegate
    the flow's closure and the delegate only forwards. A flow
    declared in a package is `@FlowUp public var` in an extension not
    itself marked `public`, the form the run compiled. Five
    dependencies each named their modifier `Injector` as the example
    in `app-structure.md` did, and the checker reads a type by its
    name and merged them, so the example names it for its package.
    The CoreFlow skill carries the package form too.
    Open from the run, not ruled. A `@Model` logs as its type name,
    so no test can tell which plant a delete was handed, the third
    run to say so after the two of F71. Diagram 2 has no form for a
    flow, and the run drew it as a class marked `<<flow>>`. Today's
    date as a `let` from the root is stale past midnight, as F58
    noted. Under `@Shell` the resets an opening writes are in every
    block of the list, which makes them long, and undo took three
    scenarios that differ in one stub. A plant inserted just before
    the test killed the app was lost, SwiftData's own saving, which
    no sentence warns a test about. A stepper is one element in
    XCUITest on iOS 27, so the run tapped its plus by coordinate.
    That a notification tap which launches the app reaches the
    listener was not measured. Rules the run broke and said so, a
    `static let` for `@Model` fixtures, since a row needs the same
    instance across waves, and a write to the delegate's forwarder
    during `body`, to a plain class.
  - **F88, the sequence is the test, and a model's entry is its
    name.** Three runs had reported that a `@Model` logs as its type
    name, so that no test can tell which record was handed on, F71's
    two and F87, and the agent listed it each time as open for a
    ruling. The owner, 2026-11-14: "i always said, actual values do
    not matter so much for the test, more important is the sequence".
    It was ruled on 2026-11-09, the names are the contract and a
    value is asserted as the author sees fit, and the skill then
    undid it with an example, "a model by its title", which no log
    can give. That example is gone from `SKILL.md`, and it, the map
    skill, and `notation.md` say the sequence is what the test
    proves and a model's entry is asserted by its name alone. F71's
    and F87's open notes on it are closed by this. Of the rest of
    F87's list the owner said he did not understand what he was
    being asked, and nothing was his to answer. The coupling
    diagram's form for a flow is the one the run drew, a class marked
    `<<flow>>` with its signature, written into Diagram 2 as the
    agent's default. The forwarding code sitting in a dependency
    package is what the run did on its own, so that default stands.
    A notification tap that launches the app is a measurement the
    agent owes and no sentence of a skill claims.
  - **F89, a notification tap, measured, and the form F87 wrote is
    wrong.** F87 took the Garden run's form into `modules.md`, a
    delegate made in the `@State` of the dependency's root modifier
    and handed the flow's closure in `body`, without measuring it.
    Measured on 2026-11-14 with the scratch app, a local notification
    scheduled, its banner tapped through SpringBoard, the screen
    read. With the delegate made that way, the tap that launched the
    app did not reach the delegate, twice of twice, and a tap with
    the app in the background reached it once of twice. Apple's
    documentation says the delegate is assigned before the app
    finishes launching. With the delegate made in the `App`'s `init`
    and the delegate's methods as Garden wrote them, `nonisolated`
    and `async`, the delegate heard the tap and the app crashed,
    SIGABRT on the cooperative pool inside
    `-[UIApplication _performBlockAfterCATransactionCommitSynchronizes:]`
    called from the method's bridged completion. With the
    completion-handler forms finished on the main thread there was no
    crash, the delegate heard the tap, and the listening view got
    nothing, since the tap came before the forwarder had the flow's
    closure. With the delegate keeping such a tap and the root's
    `.task` handing it over, the listener got it, once of once. The
    owner, 2026-11-14: "you can ask astra for asistance on some
    questions like that". Astra at high effort, given the code and
    the first two results, agreed on all three layers, named
    `@UIApplicationDelegateAdaptor` and `didFinishLaunching` as the
    place to assign, and said no ordering guarantees a listener is
    registered by the first `body` or by a `.task`, so that the
    handover needs the collector to say when a listener exists, an
    addition to swift-core-flow. One correction of Astra's is not
    taken. It said a `@State` initial value runs when the modifier is
    constructed. F69 measured that a private one does not, on this
    SDK. `modules.md`, the do-not, and the class bullet now state the
    three measured facts and no longer the losing form. Garden as
    built loses a tap that launches it.
    How the kept tap reaches the tree. The agent proposed, in turn,
    the root's `.task`, a callback on `.collectFlow` for the moment a
    listener registers, which was Astra's idea, and the root's
    forwarding of the scene becoming active. The owner, 2026-11-14:
    "but why we use task at all? we said it is physical-view
    lifecycle but physical view is just a side effect of some
    mutation that caused a struct to be inserted into graph ... so
    intercept mutation and run unstructired task ?", then "i am not
    sure you understood collectFlow who the fuck needs calllback?",
    and "you need to eliminate that brainwashed aproach to use view
    lifecycle events for driving own states". The agent had not read
    `FlowUp.swift`. The collector's environment value is the array of
    registered listeners, data that flows down, so there is nothing
    for a callback to add. All three proposals waited for a view to
    exist and then pushed an event at it. `modules.md` and the do-not
    now say the tap is a mutation, written as state by the handler
    that hears it, with the tree a projection of that state. The
    third proposal was measured before it was withdrawn and is not
    adopted: with no `.task` anywhere, a first screen that loads on
    the forwarded "active" loaded once and stayed at one after Home
    and back, and a notification tap and a link each reached the
    listener from a cold launch. Not decided, and the owner's, where
    the handler lives that an event with no view to receive it
    writes through, at launch and on such a tap, and what replaces
    the `.task` the skill still gives a first screen.
  - **F90, the drift review after F72 to F89.** `scripts/drift-review-prompt.md`
    on 2026-11-14, a fresh agent against the first five commits, as
    `AGENTS.md` asks after a stretch of rulings. Of 64 early ideas it
    counted 27 kept, 19 transformed, 9 weakened, 7 reversed, and 2
    lost. Its verdict. The structural bet is kept almost word for
    word, depth-1 maps, the label as contract, double entry, the
    merge on names, values set at the root, behavior declared as a
    log, and the two things the first commits only imagined, the
    check and the derived whole, exist as code. The map notation
    matured, each change from a named finding. The rest it calls
    drift and not maturing. Authority moved from the skill to this
    file, which reverses itself. Every rule became a default that may
    be broken. The map diff has no human reviewer in an engine run.
    The oracle went from one equality over name and payload to names
    in order with values at the author's discretion. And of 159
    commits 131 landed on five November days, with rules added "from
    single cold runs and one-line messages", so that the live
    contradictions it could cite grew from about seven to thirty-two,
    most of them in the newest rulings. Fixed from it, each an
    oversight of this stretch. F84 to F89 had been filed inside F78
    and before F79, and the entries are in order again. Two counts of
    planted findings were stale after F85. The example of a call on
    appearance was a subscription to notification taps, which F81
    and F89 make a flow. "The one sanctioned upward path" now says
    between a child and its parent. Not acted on, since each is a
    ruling it disagrees with and not an oversight: the order of
    authority, that any rule may be broken (F40), names over values
    (F88), `@AppStorage` at the root (F32), who fired it. Its restore
    list, for the owner. One source of truth, with standing rulings
    folded into the skills and this file as history. The payload
    back in the equality. An engine run that stops after the maps or
    marks them unreviewed. A label line for a flow a node listens
    to. The three rules and depth 1 exempt from "may be broken".
    "Fast", as a stated time budget for the evidence loop. An app
    with ground truth the skills did not write. The no-change guard
    declared in a block's `Given` and not global. And the test for
    what belongs in `SKILL.md`, moved to a reference and not cut. It
    also noted that Diagram 2, which the map skill calls what the
    method is for, is the one diagram the checker does not read.
    The owner, of the review: "i have no time to read ask astra to
    read". Astra at high effort read it against the standing rulings,
    listed for it as settled. Of the 32 contradictions it found 18
    ruled, 4 already fixed, and 10 to fix. Five of the ten are
    wording that follows from a ruling and are fixed. "One scenario
    per core" is now a core with its scenarios, a stub that answers
    differently being another one. The query's proof is no longer
    called the integration test of a cylinder it does not have. The
    README says a label carries the outbound contract. In the
    swift-core-flow skill a value assertion no longer names a model's
    title (F88), and `dismiss` in the log proves the node asked, not
    that the sheet closed (F71). Three of the ten are F67's open
    items and are left, the by-hand cut and own-state writes, the
    `loop` assertion, and furniture with a callback. Two are the
    owner's slogans and are left, "cannot rot" and "nothing depends
    on where a map sits". Of the restore list it said no to six,
    since each reopens a ruling, already to one, and do to two, a
    label line for a flow a node listens to, which F85 had left
    without one as the agent's default, and an app whose spec the
    skills did not write, which is the standing "Next" below.
  - **F91, there is no view to be outside of.** The agent had asked
    where a handler lives for an event that comes when "no view
    exists yet". The owner, 2026-11-14: "how can sometghin exists
    before the app ?", and "you reminded me of an idiot colleague
    question "what if you are not in a view" well you are never in a
    view because there is none, but you are probably always under app
    which is swiftui runtime". `data-flow.md` already said that `App`
    and `Scene` are nodes with their own `@State` and that there is
    no layer above the network, and it now says the consequence. An
    event that comes before any screen is a write to the `App`'s own
    state, and the screens are a projection of it. Measured with the
    scratch app, a tap on a notification that launched the app, four
    of four. The `App` held the tapped reminder as its `@State`, the
    delegate was a private `@State` of the `App` handed a closure in
    the `App`'s `body` that writes that state, and the first screen
    showed the tap from the value it was handed, with no flow, no
    listener, and no lifecycle modifier. `modules.md` gives that form
    with its code in place of F89's sentences, and the do-not and the
    class bullet say the delegate is kept by the `App`. Astra's
    sketch for the same question put the state at the app level too.
    Also measured, the order at launch, `App.init`, then the
    application delegate's `didFinishLaunching`, then the `App`'s
    first `body`, then the content's. So a closure assigned in the
    `App`'s `body` is in place for a notification's tap and is not
    yet in place for `didFinishLaunching`, where a load counted 0.
    The `App`'s `init` ran once in each run, and its `body` once at
    launch and once more after its state was written.
    Left for F92, what starts a first screen's load at launch, since
    before the `App`'s first `body` its `@State` cannot be written.
  - **F92, the `App` is where the app's lifecycle is handled.** The
    owner, 2026-11-14, on the form F91 gave, a delegate named
    `reminders` handed a closure in the `App`'s `body`: "what is
    reminders?" and "the code looks so weird". Then: "i think i see
    your point since app is a root and its basically singleton
    struct... we need to use it for the lifecycle", then "we can make
    exception maybe for that - on the app level we maybe easierst use
    the task or whatever?", then "keep in ming that app has init",
    and of the delegate "i coul not understand fucking delegate thing
    sounds like objectivec". Two things follow. The first screen's
    load at launch keeps its `.task` on the node above the stack and
    the tabs. That is the app level, the `App` is made once per
    launch, and nothing above that node removes it and puts it back,
    so the rule against the lifecycle of the view on screen does not
    reach it (F77 measured that `.task` once through pushes, pops, and
    tab changes). And the `App`'s `init` and stored properties may
    build what lives as long as the app, which no view's `init` may.
    Measured the same day with the scratch app, six forms of keeping
    the notification delegate at the `App`, each with a tap that
    launched the app and a tap with the app in the background.
    Arrived both times: an `@Observable` delegate that holds the
    tapped value, as a private `@State` of the `App`; the same as a
    plain `let`; the same with its methods left on the main actor and
    no `Task` inside; a closure assigned in the `App`'s `body` that
    writes the `App`'s `@State`; a closure made in the `App`'s `init`
    that writes a data-only `@Observable` object the `App` keeps as a
    `let`. Lost both times: a closure made in the `App`'s `init` that
    writes the `App`'s `@State`. The order at launch with the
    delegate as `@State` was `App.init`, `didFinishLaunching`, the
    delegate made, the `App`'s `body`, the delegate's callback on the
    main thread, the first screen's `body`. So the runtime makes the
    `App`'s `@State` before its first `body` whether or not `body`
    reads it, and the tap is written before the first screen is
    built. `modules.md` now gives the form with the fewest parts, the
    `@Observable` delegate as the `App`'s `@State`, its class shown,
    named for what it holds, its methods plain. That object holds a
    value and the callback that writes it. The text says so, bounds
    it (its stored properties are what the system's callbacks write,
    nothing in the app calls a method on it, a feature gets the value
    as a fact or a binding), and names the form that keeps the value
    apart, the data-only object written by a closure from `init`.
    The agent chose the first as the default on the owner's "easierst".
    F93 replaced that form the same day.
  - **F93, no information is lost, a fact is not a binding, and the
    delegate is a dependency in its two parts.** F92's snippet stored
    `response.notification.request.identifier` and handed the first
    screen a binding to it. The owner, 2026-11-14: "why you loss of
    information? system gave you full response and you only use id
    out of it", "this is the first principle - never lose
    information", "why you passing tapped as a binding", "binding is
    for mutating, why you want to mutate a data from delegate? it is
    other way arround you want to react on data change?", "remember
    "how we consume it" and "how we construct it"", "you need a view
    modifier that injects delegate behavior", "you maybe need
    flowup", and "how will other agents understand what is
    capability, how to consume ti how to construct it how to organize
    data flow". The agent's account of the binding, asked for: F91's
    form had made the tapped id double as the state of which plant is
    open, written by the notification, by a row of the list, and by a
    dismissal. When the value became the system's own, nothing in the
    app wrote it, and the binding was carried over without asking who
    mutates it. Three things are written. The first, in the skill and
    in `AGENTS.md`, no information is lost where a value enters the
    app, the boundary keeps or forwards the whole value and narrowing
    is a projection made afterwards. The second, a binding is handed
    where the receiver writes, and what it only reads is a fact. Both
    have a row in `data-flow.md`'s table of older names. The third,
    `modules.md` gives the notification as F60's two parts, the
    capabilities as a contract in the layer, the construction as the
    package's `inject` modifier over a delegate that keeps the whole
    response and that the `App` keeps, the use as a fact read from
    the environment, and one paragraph on how the data flows.
    Measured the same day, each with a tap that launched the app and
    a tap with the app in the background. The delegate keeping the
    whole response and the window's closure handing down a fact,
    arrived both times, the second response replacing the first on
    the screen. The same delegate read by a modifier that sets a
    contract's value into the environment, and a feature that reads
    the entry, arrived both times. The response forwarded from the
    root's modifier into a `@FlowUp` flow, by `.task(id:)` and by
    `.onChange` with its initial run, reached the listener from the
    background and did not reach it from a cold launch, both
    variants, since the forward ran with the closure of the first
    `body`, when no listener had registered. So the flow was not
    taken. The agent's reading, where the owner's words leave room:
    the contract carries what features use, the reminder's id, and
    not the framework's type. UserNotifications appears in one
    package by the existing rule, the nodes that consume a contract
    dictate its members, and `UNNotificationResponse` has no
    initializer the app may call (the compiler, "'init()' is
    unavailable"), so a scenario could not set a contract that
    carried it. The whole response stays in the delegate, inside the
    package, for the modifier to project from. The delegate's class
    is the package's second public declaration, since the instance
    is made in time only as the `App`'s own stored property.
  - **F94, the delegate holds a binding, the state is beside it, and
    the `App`'s `init` is creation.** F93's form had the delegate
    hold the response. The owner, 2026-11-14 and 15: "you broke the
    basic rule - you coupled state and behavior - never do that,
    there is no reason to do that", "ReminderDelegate needs to hold
    Binding to the state thats it", and of the agent's forms that
    built the delegate as a `let` of the `App` or wired it in the
    `App`'s `init`, "you are conflating the ap struct with the real
    objet and messing with init lifecycle". So F92's sentences that
    the `App` is "the one struct made once per launch" and that its
    `init` and stored properties may build what lives as long as the
    app are withdrawn from the skill, `AGENTS.md`, and `data-flow.md`.
    The agent had read "keep in ming that app has init" as permission.
    F92's other half stands, the launch load keeps its `.task` at the
    app level. Of a dynamic property the agent sketched, the owner:
    "can you probe that dynamic property it looks ugly and suspicios,
    you are reassigning the binding is that ok?", then, on moving the
    state out of it, "keep state in dynproperty". Probed with the
    scratch app, each with a tap that launched the app and a tap with
    the app in the background. The dynamic property's two `@State`
    were made before its first `update()`, `update()` ran before the
    `App`'s first `body`, and the delegate's callback came after that
    `body` and before the first screen. `update()` ran two times by
    the first screen and three after the second tap, assigning the
    binding each time. A variant that assigned it once delivered the
    later tap too. With the value read inside the window's closure
    the tap that launched the app was not shown, in the dynamic
    property and with a plain `@State` of the `App` alike, and the
    tap from the background was. With the value read in the `App`'s
    `body`, by a `let` before the `WindowGroup` or by the scene's own
    `.environment` modifier, both were shown. Read in a child through
    a binding, both were shown and the `App`'s `body` did not run
    again. A binding handed over by a view modifier inside the window
    did not deliver the tap that launched the app. `modules.md` gives
    the form: the state and the delegate as two private `@State` of
    a dynamic property the package exposes, the hand-over in
    `update()`, the contract projected from the state, the root
    setting it with the scene's modifier. The package's public
    declaration is then the dynamic property and not an `inject`
    view modifier, the one departure, since the modifier is too late.
  - **F95, the delegate is handed a closure, and the closure is the
    flow's.** The owner, 2026-11-15, on F94's form: "this looks to be
    more natural with flowup", "make some view modifier or something
    dude dont put dyn prop in app no nneed", "you dont need state or
    binding in dyn prop, you need a closure that you need to call
    from the flow", "and dont use onchange", and "this modifier maybe
    not need to modify nothing, remove this service dud we use flow".
    `modules.md` now gives that form. The delegate holds no state and
    calls a closure. The dependency's `inject` view modifier keeps it
    in a private `@State` and hands it the closure in `body`, and the
    closure calls a `@FlowUp` flow with what the listeners use. A
    feature listens with `.onFlow`. The contract with a fact in it is
    gone. Probed with the scratch app. A modifier whose `body`
    returned `content` untouched did not run at all, its `body` was
    not called and its `@State` was not made, twice with a log and
    once with a print to the console, so "modify nothing" is not
    literal and the modifier sets the dependency's contract. With the
    `body` running, the hand-over ran nine times before a tap, since
    the flow's closure changes as listeners register, and a tap with
    the app in the background went delegate, closure, flow, listener,
    in the plain modifier and in a dynamic property inside it alike.
    A tap that launched the app was not delivered, in both, since the
    delegate was made after the first screen's `body`. The same was
    measured with state and `.onChange` in the modifier, two of two.
    The agent told the owner three times before the form went in and
    the text says it. F94's form, the dynamic property the `App`
    declares, stays in `modules.md` as what an app does when it has
    to open on that tap.
    The same night the owner asked why the injector could not hold
    the dynamic property and return its content unchanged, and of the
    contract the agent had made it set, "wtf is this". That contract
    was invented to make the modifier run and is removed. Probed: a
    view that holds its content, declares the dynamic property, and
    returns the content ran as it stands, `update()` ten times before
    a tap, the tap from the background heard. So the injector is that
    view, behind the same `injectReminders()`.
    The owner, of that view: "this is not swiftui, looks weird and
    need to be viewmodifier not view", and "it is dyn prop so use
    "@ ReminderTaps var... "". So the injector is a view modifier
    again and the dynamic property is a property wrapper. Probed with
    console prints, which bodies make a modifier that carries a
    dynamic property run: `content`, `Group { content }`, and
    `content.modifier(EmptyModifier())` did not, no `update()` and no
    `@State`; `content.transformEnvironment(\.self) { _ in }` did, and
    with it a tap from the background went delegate, closure, flow,
    listener. The modifier's `body` is that line.
    The owner called that line a hack and asked for `.collectFlow`
    inside the modifier. Probed: the modifier ran, the delegate got
    the tap and called its closure, and no listener heard it, since
    the modifier reads the flow from above its own collector. He
    then asked for `.background { Color.clear }` or
    `.background { EmptyView() }`. Probed: with the clear color the
    modifier ran and a tap from the background reached the listener;
    with the empty view it did not run. The modifier's `body` is
    `content.background { Color.clear }`, and the collector stays at
    the root.
    Then, "we dont need dynamic property dude? do we?". It is not
    needed. The hand-over as a line in the modifier's `body`, with
    the clear background, ran and delivered the tap from the
    background the same way, and that is the form in the text.
    Then, "maybe we need to encapsulate .injectReminders()
    .collectFlow(\.reminderTapped) in injector dependency". Done. The
    package's `inject` function applies the modifier and then the
    collector, the same two in the same order as measured, and the
    root writes one call.
    Asked "or not?", the agent argued against it, a collector belongs
    to a subtree and not to one emitter, and the owner pasted the
    root's chain with `.collectFlow` in it as the form that worked.
    The collector is back at the root. Probed on the way, for a tap
    that launches the app to reach a flow: the response kept at the
    `App` and forwarded by a `.task(id:)` through the closure handed
    over last, lost, two of two, the task ran three passes before the
    listener registered; the delegate at the `App` feeding an
    `AsyncStream`, read by a `.task(id:)` that starts only when the
    flow has a listener, heard, two of two from a cold launch and two
    of two from the background, the listener count read through a
    property written in the file that declares the flow; the same
    with a plain `.task` and no check, not heard at all, four of
    four. The owner: "this is hell". None of it is in the skill. The
    form is the simple injector, and the text says it does not
    deliver a tap that launches the app.
  - **F96, the delegate on the `App` feeds a stream, and a task that
    runs forever emits on the flow.** The owner, 2026-11-15: "we need
    just that version and to mode delegate on top of app, and pass
    stream down to wmiter via task that runs forvere", after "if we
    can kindow suspend delegate from emiting until someone unsuspend
    it?" and "combination of AsyncStream and flowup?". The agent had
    told him a check for listeners was needed, and he, "you are
    wrong, "only if the flow has listeners" is wrong worry". He was
    right. Measured with the scratch app: the delegate as a private
    `@State` of the `App` yielding into an `AsyncStream`, the stream
    passed to the injector, a plain `.task` there reading it and
    calling a closure that `body` hands over on every pass. A tap
    that launched the app was heard by the listener, two of two, and
    a tap from the background, two of two. The order at launch was
    the delegate's callback, the modifier's `body`, the task
    starting, one more `body`, the task emitting, the listener
    called. The agent's own wrong prediction came from the run where
    the same hand-over was driven by `.task(id:)` over state and no
    stream, which emitted three passes before the listener
    registered. With the stream the read is a suspension and the
    emission came one pass later, after the listener. This is a
    measured order and not a documented one. `modules.md` gives the
    form and its eight facts. `UNNotificationResponse` is not
    `Sendable`, the compiler refused to yield it, so it rides in a
    box the package declares. F95's injector with the delegate inside
    the window, which did not deliver the launch tap, is replaced.
    Not measured: every listener going away and coming back, and a
    tap on a banner with the app in the foreground.
    The owner, of the box: "some struct looks excessive, you can pass
    UNNotificationResponse complete because we do not use state nor
    binding now". The box is gone. The stream carries the response
    itself, marked `nonisolated(unsafe)` in the callback before it is
    yielded, which compiles under Swift 6 with the main actor as the
    default isolation. That spelling was compiled and not run again,
    the run was with the box.
  - **F97, what has to exist before the runtime is a class, held by
    the `App` as a `let`.** The owner, 2026-11-15: "even the app is a
    struct, there is only one value of it, riht its the root... so if
    we put state to it it can be let, which means we can do stuff in
    app init and we can put public let taps: AsyncStream<...> direct
    into app wrapped into an observable class because observable work
    even without state, the shove that observable into environment
    from body... also construct celegate as that state as a param",
    then "so this may be a rule whenever something need to exist
    before the swift runtime - we need to use classes", and "so is
    the app like a singleton ?". This turns F94's sentence around,
    that the `App`'s `init` builds no class instance, which had been
    written on his "you are conflating the ap struct with the real
    objet". The rule as written, with three limits: the root alone,
    since there is one `App` value and its `init` ran once in every
    measured launch; only what the system reaches before the first
    screen; each class data or behavior, not both. The `App` struct
    stays a value, a copy shares the instances and not its `@State`.
    Probed, the form of F96 with the stream's holder as an
    `@Observable` class and the delegate constructed with it, both
    `let`s of the `App` built in `init`, the holder put into the
    environment and read by the injector: a tap that launched the app
    heard, two of two, a tap from the background, two of two.
    `modules.md` gives that form. Of the emitter, the owner: "what is
    this garbage", then "maybe i have a design flow in flowup because
    calling a flow should not need this workaround with emiter?". The
    agent read the macro: a flow's closure captures the array of
    listeners at the pass it is read in, so anything that holds it
    longer than a pass calls the old list. A stable box per collector
    that the closure reads at call time would remove the emitter and
    the hand-over, and would stop every reader of a flow from running
    again when a listener registers. Not built. The owner: "dont
    change flowup now, go with emiter workaround in the app itself".
    It is the open item for swift-core-flow.
    Then: "observable is not needed dude for ReminderTaps why you put
    it? also taps you can init inline, so you can make it a state
    also to look nicer?". It had been put there for `.environment`,
    which takes an `@Observable` class. Probed: the holder as a plain
    class, a `let` with an inline value, handed to the injector as a
    parameter, a tap that launched the app heard, two of two, and
    from the background, two of two. As `@State` it does not build,
    "variable 'self.reminderDelegate' used before being initialized"
    at the read in `init`. A plain `-typecheck` did not show that
    error, a full compile did. The text has the `let` form.
  - **F98, a flow's closure looks up its listeners when it is called,
    and the emitter is gone.** The owner, 2026-11-15, of the emitter:
    "maybe i have a design flow in flowup because calling a flow
    should not need this workaround with emiter?", then "maybe we
    need to expose a caller class in environment directly and never a
    closur?", then "d local cjange in coreflow dont commit". The
    change is in the `~/dev/CoreFlow` working copy, three files, not
    committed: a caller object per collector that holds the current
    listeners and is the collector's one value in the environment,
    the generated closure reading it at call time, and the four
    expected expansions updated. The declared type of a flow and
    every call site are unchanged. The library's tests pass, 85 and
    38. Probed against that working copy: a plain `.task` that calls
    the flow, with no emitter, heard a tap that launched the app and
    a tap from the background, and the stack flow test passes. One
    behavior change: a listener now hears an event emitted very
    early, the first `active` scene phase at launch, which the
    earlier closure dropped. Then, "does delegate need continuation?
    and does ReminderTaps need to be a class?". The delegate needs
    the continuation and only that. The holder class is not needed,
    the pair `AsyncStream.makeStream()` returns is kept by the `App`
    as one inline `let`. Probed in that shape, a tap that launched
    the app heard, two of two, a tap from the background, two of two.
    `modules.md` and the skill give that form. It depends on the
    library change, which is the owner's to commit. Until then the
    released library needs the emitter, as F96 and F97 record. Not
    checked in the library: nested collectors, a flow with `async` or
    `throws` at run time, listeners going away and coming back.
    The owner: "listeners going away and coming back - we need to
    check". Checked with the scratch app, two listeners under one
    collector, a task holding the flow's closure from its first pass
    and fed by a stream. With the listeners in, both heard. With them
    out, nothing was heard and nothing failed. Put back, the two new
    ones heard, and again after a second round. Then "commit
    coreflow?". The library's `test.sh` passed, its unit tests and 23
    hosted UI tests, its `AGENTS.md` says what the closure captures
    now, and the change is committed in `~/dev/CoreFlow` on `main`,
    not pushed. The owner: "can that be a tests in coreflow?". It is
    one now, `FlowUpHeldScenario` and `FlowUpHeldUITests` in
    `CoreFlowHosted`: a sender whose task holds the flow's closure
    from its first pass, two listeners a toggle removes and puts
    back, the log pinned. It passes on the library as it is and was
    run once against the code before the change, where the log shows
    no listener reached. The library's `test.sh` passed with it, 24
    hosted UI tests, and it is committed there, not pushed.
    Nested collectors of one flow, which the agent had listed as
    unchecked, are out of scope by the owner's ruling the same day: a
    flow is collected once, and collecting it twice on one branch is
    a mistake in the app, not a case the library guards for. Left
    unchecked on purpose. Still unchecked and in scope: a flow with
    `async` or `throws` called through a held closure.
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
  `data-coupling` stays (2026-11-09). The public
  `swiftui-mv-architecture` repo is deprecated, the owner,
  2026-11-14: "we need to deprecate swiftui-mv-architecture and stop
  reling on it". Its README, its skill's description, and its
  changelog say so and point here, committed in that repo and not
  pushed. Nothing in these skills relied on it. The one pointer left
  was in swift-core-flow's `AGENTS.md`, which now names the
  `data-coupling` skill. Its
  installed skill symlink was moved to `~/.claude/skills/.trash/` on
  2026-11-05, and out of `~/.agents/skills` the same way on
  2026-11-10, and `~/.claude/skills/data-coupling` links here. Pushing
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
