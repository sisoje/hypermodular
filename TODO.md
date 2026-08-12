# TODO

- **Validate the map notation against a real app.** Map `~/dev/CoreFlow/CoreFlowExample`
  (small, fully specified in its `SPEC.md`, ground truth known) using the skill
  as-is. The evidence doctrine is proven; the map grammar (depth-1 cuts,
  contract lines, merge-by-name, duplicated contracts) has never been applied
  to a real codebase. Where the notation creaks is the next round of skill
  fixes.

- **Decide the contract-line criterion.** Candidate rule from the article
  corpus ("how high to lift", ideas file #24): a contract line exists iff an
  acceptance criterion names it — anything a given/when/then touches enters
  the contract; purely presentational state stays off the map. If adopted, it
  gives the cut rules a mechanical test for what earns a line on a label.

- **Consider a vocabulary table.** Align the skill's terms with the trilogy's
  defined vocabulary (boundary event, execution log, mock depth, scenario,
  data coupling layer — Diagram 2 is named after it). One small table, so
  agents and readers share one glossary across skill, articles, and CoreFlow.

- **Split into SKILL.md + references/ when the content exists** (the
  mv-architecture pattern). Not before: at 17KB the skill is all
  load-bearing doctrine. The trigger is reference-grade content —
  the CoreFlowExample mapping walkthrough, an evidence cookbook, an
  exhaustive notation reference. First reference file = the validation
  exercise's output.
