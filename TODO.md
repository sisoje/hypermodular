# TODO

- **DONE — validation run, findings recorded.** CoreFlowExample mapped with
  the skill as-is: `hypermodular/references/coreflow-example-validation.md`
  holds the maps (ready to drop into that repo), three doctrine passes, and
  six findings (F1 two-roots/unmounted components, F2 decision values with
  no contract line, F3 parent-supplied callbacks, F4 modifier hosts, F5
  @AppStorage naming tension, F6 wrapper-name collisions). Next: rule on
  F1–F3 and fold the rulings into SKILL.md.

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
