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
    properties. The check itself is unwritten.
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

- **Notes files removed** in the repo cleanup: `COREFLOW.md` (a
  snapshot of CoreFlow at `d065fd7`, 140 commits stale, describing the
  since-removed CoreFlowExample) and `HYPERLAMBDA.md` (the argument for
  the map as a verified slot registry, already in `notation.md` and the
  checker). Both are in git history. What was worth keeping has landed.
  "Material, not framework" and "Cooper inherited, not refuted" are one
  sentence each in `hypermodular/SKILL.md` and `references/evidence.md`.
  CoreFlow's mechanics are in `data-coupling/references/shell-core.md`
  and `testing.md`, written from the current README. The regeneration
  loop ("maps replace the behavioral half of a spec") stays recorded
  here only: a proof mechanism, not run, and not this repo's to run.

- **Open, from a fresh agent's review (2026-11-05).** Three rulings
  and one notation gap.
  - **F21, a write through a dependency's binding has no line kind.**
    `modules.md` allows a contract that is a struct of bindings (a
    settings value the root builds over its own `@AppStorage`).
    `evidence.md` says a write into a handed binding logs. The label
    grammar has `· dep.value` for reads, which never log, and the
    checker rejects a dotted evidence target that is not a call line.
    Either writes through `· dep.value` log and the checker accepts them
    as targets, or the struct-of-bindings contract is out.
  - **F22, who may set a value below the root.** The mapping law says
    the root only, and a value set below it is a finding. Who said no:
    this skill, and only this skill. The sentence is the mapping skill's
    own (`SKILL.md`, the depth-1 law; `notation.md`, "a second arrow
    into the box means a value was set below the root";
    `reverse-engineering.md`, "every place a service enters the
    environment below the root is a finding"), written 2026-11-04. The
    masterclass and the method article do not state it, and the
    manifesto never names a root. The app rules this skill was distilled
    from say override at any subtree, one screen included. The skills
    now say previews and scenarios may; whether a shipped screen may is
    unruled.
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
    a tree for the host until it is.
  - **The test array**, ruled: the whole log, one equality, so an
    unnamed call fails; a set where the requirement names no order; the
    decision alone where only that matters; never a subsequence. The
    entry's string is the target's own name, a space, the payload.

- **Open, the owner's decisions.** The skill folder name:
  `data-coupling` is a placeholder. Whether the public
  `swiftui-mv-architecture` repo points here or stays as it is; its
  installed skill symlink was moved to `~/.claude/skills/.trash/` on
  2026-11-05 and `~/.claude/skills/data-coupling` links here. Pushing
  `main`: one local commit over `a3a815c`, nothing pushed.

- **Next: both skills on a real project.** Map it with `hypermodular/`,
  review its nodes with `data-coupling/`, and let what the notation and
  the rules cannot express drive the next changes. Findings F21 onward
  go here.

- **Decide the contract-line criterion.** Candidate rule from the
  article corpus ("how high to lift", ideas file #24): a contract line
  exists iff an acceptance criterion names it. Anything a
  given/when/then touches enters the contract; purely presentational
  state stays off the map. If adopted, it gives the cut rules a
  mechanical test for what earns a line on a label. It collides with
  Diagram 4's optional rule ("a criterion is drawn iff it targets a
  contract line"), each defined by the other. Resolution if adopted:
  criteria come first and define the contract lines; whether a
  criterion is drawn is then derived (it targets a line iff it names
  one that crosses the edge). Write that order into both rules in the
  same commit, or adopt neither.

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
