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
