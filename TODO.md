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

- **Consider a vocabulary table.** A draft alignment table now sits in the
  validation reference's appendix — the one real decision it surfaces is
  *evidence log* (skill) vs *execution log* (published article); everything
  else aligns. Promote the table into SKILL.md once that name is picked.

- **Split SKILL.md — the trigger is now met.** Written when the skill was
  17KB: "split when reference-grade content exists." It is 25KB, up 44%
  in a day, with a 587-line `references/` file and a `scripts/` dir
  beside it. Candidates to move out: the full Diagram 4 bullet list
  (keep the example and the two-sentence rule), the reserved-word list,
  the Combining-maps identity rules. Decide what stays load-bearing
  before it grows again; not urgent, but due.
