# example — the forward test

Everything in this repo so far was validated *backwards*, against an app
that already existed. This directory is the other direction: the book app
that `hypermodular/SKILL.md` uses for its examples, drawn here first and
built here afterwards, root-down, evidence before code — rule 1 and rule 3
applied to the method itself.

It is a directory in this repo on purpose. Code that the doctrine needs
for its own verification — the code-side half of the registry check, the
"does a map plus evidence actually specify a node" question — lives
beside the doctrine, not in another repository.

Order of work:

1. maps — `APP-MAP.md` and the `MAP.md` tree (this commit; passes
   `scripts/mapcheck.py`)
2. evidence — one block per criterion that crosses an edge, before any
   Swift
3. code — one node at a time, parent first, each node's evidence holding
   before the next is started
4. the code-side checker, run against what step 3 produced

Anything the maps could not express is a finding and goes in `TODO.md`.
