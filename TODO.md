# TODO

- **DONE — validation run, findings recorded.** CoreFlowExample mapped with
  the skill as-is: `hypermodular/references/coreflow-example-validation.md`
  holds the maps (ready to drop into that repo), three doctrine passes, and
  six findings (F1 two-roots/unmounted components, F2 decision values with
  no contract line, F3 parent-supplied callbacks, F4 modifier hosts, F5
  @AppStorage naming tension, F6 wrapper-name collisions). Next: rule on
  F1–F3 and fold the rulings into SKILL.md.

- **DONE — Diagram 4 validated, findings recorded.** Evidence as a
  `sequenceDiagram` per acceptance criterion (in-arrows = when,
  out-arrows = the log, dashed = supplied data, `loop` = count unnamed,
  `Note` = silence). All eight CoreFlowExample logs transcribe and render
  (mermaid 11.16.0); Part 2 of the same reference file. Six new findings:
  F7 "who fired it" mispredicts — "whose source of truth" predicts; F8
  leaves with evidence get a MAP.md; F9 F3's bare `· name` is now
  load-bearing; F10 property target vs wrapper label (F6 with teeth); F11
  the registry check as three set comparisons; F12 mermaid reserved words
  (`title`!) must be quoted. Next: decide the cost question (N blocks per
  node), pick evidence/execution as the identity word, then write
  Diagram 4 + the registry check into SKILL.md with F7's ruling replacing
  the "who fired it" paragraph.

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

- **Split into SKILL.md + references/ when the content exists** (the
  mv-architecture pattern). Not before: at 17KB the skill is all
  load-bearing doctrine. The trigger is reference-grade content —
  the CoreFlowExample mapping walkthrough, an evidence cookbook, an
  exhaustive notation reference. First reference file = the validation
  exercise's output.
