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
    Open is the terminal reaction alone.
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
