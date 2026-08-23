# TODO

- **DONE — validation run, findings recorded.** CoreFlowExample mapped with
  the skill as-is: `hypermodular/references/coreflow-example-validation.md`
  holds the maps (ready to drop into that repo), three doctrine passes, and
  six findings (F1 two-roots/unmounted components, F2 decision values with
  no contract line, F3 parent-supplied callbacks, F4 modifier hosts, F5
  @AppStorage naming tension, F6 wrapper-name collisions). **Ruled and
  folded into SKILL.md** — see "Rulings applied" at the end of the
  reference. F5 remains for the vocabulary table.

- **DONE — Diagram 4 validated, findings recorded.** Evidence as a
  `sequenceDiagram` per acceptance criterion (in-arrows = when,
  out-arrows = the log, dashed = supplied data, `loop` = count unnamed,
  `Note` = silence). All eight CoreFlowExample logs transcribe and render
  (mermaid 11.16.0); Part 2 of the same reference file. Six new findings:
  F7 "who fired it" mispredicts — "whose source of truth" predicts; F8
  leaves with evidence get a MAP.md; F9 F3's bare `· name` is now
  load-bearing; F10 property target vs wrapper label (F6 with teeth); F11
  the registry check as three set comparisons; F12 mermaid reserved words
  (`title`!) must be quoted. **Ruled and folded into SKILL.md as
  Diagram 4** — optional iff own state only, `Evidence:` as the header
  word. Still open from it:
  - **F11, code-side half.** `scripts/mapcheck.py` covers everything
    the maps alone can verify. Still missing: every call in a node's
    Swift appears on its label; bare evidence targets are real stored
    properties. Needs a mapped repo with code — the first forward use
    of the method supplies it.
  - **`Parent->>Node` stimulus** — needs real material (a parent handing
    down a new value mid-scenario) before it is a rule. Two readings: a
    new parent value is a new *given* (the node dies in the wave and is
    re-created — "the network is reactive so the nodes don't have to
    be"), or an `.onChange(of: input)` reaction makes it a genuine
    *when*. `mapcheck.py` warns on it, never errors, until ruled.
  - **Flowchart reserved words** — `end` etc. as node ids, untested.

- **Aligned with the published manifesto** (*TDD: Death by a Thousand
  Mocks*, 2026-08): authority axis in rule 1, mock depth defined, a
  cylinder is a signature ("eventually"), refactor-stability as why the
  log is the contract, "constructible from literals", and the example
  tree reshaped to the article's lifted BookShelf (Library holds the
  fetch and the store; the shelf takes a value, a binding, a callback).
  The article's example is the better one — the earlier in-view sort was
  a hidden computation the evidence would have had to describe.

- **`example/` — the forward test, started.** The skill's own book app,
  drawn in this repo before it is built (see `example/README.md`). Maps
  pass `mapcheck.py`; evidence blocks for Landing and BookDetail are the
  next step, then code, node by node, then the code-side checker against
  that code. **First prospective finding, F15**, within a minute of
  starting: the skill's Diagram 2 example had no identity header while
  the doctrine says every block declares its place — fixed with
  `%% Root: App · Coupling`. **F16**, minutes later: a dot meant call,
  but `· loginState.isLoggedIn` is a read — ruled: parens mark a call
  (`· dbService.updateBook()`), a bare dot reads and owes no evidence.
  **F17**, at step 2: declaring Library's evidence asked who owns
  `sortByAuthor` — Library materializes it, so its label gained
  `· @AppStorage` in all four copies. A contract line appeared because
  an acceptance criterion named it: the contract-line criterion
  (below) just happened in practice, before it was adopted. Step 2 done;
  step 3 decided as macro-free compiling code (see `example/README.md`).
  **F18**, at step 2: the same physical event appears in a parent's and
  a child's evidence at different edges (Library's storage write and
  BookShelf's binding write are one toggle). Correct under
  whose-source-of-truth, not double-counting — and stated nowhere until
  now. Ruled in `evidence.md`, "One event, two edges".
  **F19**, found by demonstrating the method on a fresh app: a child
  firing a callback is a stimulus, and the doctrine had only ruled
  `User` and `System` — so a parent's evidence had no legal trigger from
  inside its own tree. Ruled: `Child->>Parent: callback payload`,
  checkable against the child's label. The `Parent->>Node` *value*
  question stays open and separate.
  Findings from here on go in this item.

- **CoreFlow notes** live at `COREFLOW.md` (repo root): the mechanics,
  the eight pinned logs, what the evidence chapter borrows from verified
  practice, and where the two documents use "dependency" differently
  (F5). Two things it surfaces for later: the unpublished doctrine in
  CoreFlow's chronicle ("material, not reactivity, bounds the method";
  "Ian Cooper inherited, not refuted") fits a why-this-works reference
  file; and the regeneration loop there is the proof mechanism for
  "maps replace the behavioral half of a spec" — recorded, not run, and
  not this repo's to run.

- **Hyperlambda notes** live at `HYPERLAMBDA.md` (repo root, not in the
  skill). The only doctrine it argues for is already in the item above:
  the map as a verified slot registry, and an execution half to the
  notation. Leave it outside the skill unless a reference-grade "why
  mermaid" piece is ever wanted.

- **Decide the contract-line criterion.** Candidate rule from the article
  corpus ("how high to lift", ideas file #24): a contract line exists iff an
  acceptance criterion names it — anything a given/when/then touches enters
  the contract; purely presentational state stays off the map. If adopted, it
  gives the cut rules a mechanical test for what earns a line on a label.
  **Collides with Diagram 4's optional rule** ("a criterion is drawn iff it
  targets a contract line") — each defined by the other. Resolution if
  adopted: criteria come first and *define* the contract lines; whether a
  criterion is drawn is then derived (it targets a line iff it names one
  that crosses the edge). Write that order into both rules in the same
  commit, or adopt neither.

- **Consider a vocabulary table.** A draft alignment table now sits in the
  validation reference's appendix — the one real decision it surfaces is
  *evidence log* (skill) vs *execution log* (published article); everything
  else aligns. Promote the table into SKILL.md once that name is picked.

- **DONE — split.** `SKILL.md` is 16KB of doctrine (rules, depth 1, the
  four diagrams with their examples, evidence essentials, workflows in
  short form). `references/` is organized by the two jobs plus the two
  bodies of detail: `architecting.md`, `reverse-engineering.md`,
  `notation.md`, `evidence.md`, and the existing validation run. Nothing
  deleted; every moved passage is pointed at from where it left.