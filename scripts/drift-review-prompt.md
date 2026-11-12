# The drift review

Measures the current repo against its first five commits, the
brainstorming phase, with a fresh model that has read neither. Run it
after a stretch of rulings. Export the five commits first, then fill
the two placeholders and hand the rest to a cold agent verbatim.

```sh
# <EARLY> is an empty directory outside the repo
i=0; for c in $(git rev-list --reverse HEAD | head -5); do i=$((i+1)); d=<EARLY>/commit-$i-${c:0:7}
  git ls-tree -r --name-only $c | while read f; do mkdir -p "$d/$(dirname "$f")"; git show "$c:$f" > "$d/$f"; done
  git show -s --format='%h %ad%n%s%n%n%b' --date=short $c > $d/COMMIT-MESSAGE.txt; done
git log --reverse --format='%h %ad %s' --date=short | head -5 > <EARLY>/commits.txt
```

Grade the answer by what it calls LOST, REVERSED, and contradictory, and
fix the sentence or rule the ruling, never the review. The prompt:

---

You are a fresh reviewer with no prior exposure to this project. Compare a method's first five commits, its brainstorming phase, with its current state, and say whether the original ideas were kept, transformed, weakened, lost, or reversed. Do not edit any file. Read everything named below in full before writing. Do not read any other review or notes; judge from the sources alone.

The five early commits are exported as complete trees under `<EARLY>/`:

- `commits.txt`, the five commit lines.
- `commit-1-*/`, the initial commit: `README.md`, `hypermodular/SKILL.md`, `CLAUDE.md`.
- `commit-2-*/`, `commit-3-*/`, `commit-4-*/`: the same files plus `TODO.md`, each refining the previous. Each folder has `COMMIT-MESSAGE.txt`, the commit's own explanation.
- `commit-5-*/`: adds `hypermodular/references/coreflow-example-validation.md`, the first validation of the notation against a real app.

Read the five in order, every file, and keep notes of every distinct idea: a rule, a principle, a notation choice, a claim about what the method is for, who reads it, what it refuses to do. Use the commit messages and the TODO.md evolution to see what the authors themselves considered the ideas.

Then read the current state in `<REPO>/`: `README.md`, `AGENTS.md`, `hypermodular/SKILL.md`, `data-coupling/SKILL.md`, `hypermodular/references/notation.md`, `hypermodular/references/evidence.md`, the docstring at the top of `hypermodular/scripts/mapcheck.py` and `hypermodular/scripts/fixtures/README.md` (the checker, which the early commits only imagined), and `TODO.md` (the running log of findings and rulings). Also read the companion skill for the macro library the method leans on, `<COREFLOW>/skill/SKILL.md`. The current repo has a second skill, `data-coupling/`, that did not exist early.

Report, as your final message, in markdown, no preamble:

1. **The initial ideas**, numbered, one line each, with the commit and file where each first appears, quoting the sentence. Completeness over brevity; twenty to forty items is expected.

2. **A table**: for each idea, one of KEPT (same sentence or meaning, cite the current file and line), TRANSFORMED (kept in substance, changed in form or scope, say how), WEAKENED (still present but hedged, demoted, or contradicted elsewhere, cite both), LOST (absent from the current repo), REVERSED (the current repo says the opposite, cite it). Be strict: a sentence that moved into a reference file is KEPT; a sentence that survives only in TODO.md history is LOST.

3. **What was lost**, each with a judgment: a gain, a loss, or neutral, and why, in two sentences. Where a lost idea solved a problem the current repo now has no answer for, say so.

4. **What is new** that the early commits would have rejected or did not imagine, with the early sentence that would have objected, if any. For each of the newest additions, the ones the latest TODO entries record, say whether it is a consequence of the early bet or a departure from it.

5. **Internal contradictions** in the current repo, sentence against sentence, with both citations. The early commits had few; say whether the current one has more.

6. **Verdict** in five sentences: did the repo keep its initial ideas or diverge, and is the divergence a maturing or a drift.

7. **Restore list**: anything from the early commits worth bringing back, one line each, or "nothing" if that is your honest reading.

Quote exactly; cite file and line for every current-state claim. Do not soften; the owner wants to know what was lost.
