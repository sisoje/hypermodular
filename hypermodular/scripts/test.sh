#!/bin/sh
# Regression test for mapcheck.py: the clean fixture (CoreFlowExample's
# validated maps) must pass with zero errors; the broken fixture must
# report exactly the fourteen errors planted in it; of its two warnings,
# the Parent in-arrow is asserted (unruled, so never an error).
set -e
cd "$(dirname "$0")"
echo "clean:"  && python3 mapcheck.py fixtures/clean | tail -1 | grep -q " 0 errors" || { echo "FAIL: clean fixture has errors"; exit 1; }
echo "broken:" && python3 mapcheck.py fixtures/broken | grep '^ERROR' | sed 's/^ERROR *//' | sort > /tmp/mapcheck-got.txt || true
sort > /tmp/mapcheck-want.txt <<'WANT'
ReadingListScreen/MAP.md: arrow from 'AddBookField' in a block rooted at 'ReadingListScreen' (depth > 1)
ReadingListScreen/AddBookField/MAP.md: AddBookField: target 'title' is a mermaid reserved word — quote it
Orphan/MAP.md: Orphan: block has no Parent link
Orphan/MAP.md: orphan: no block in this file links to a parent
double-entry: ReadingListScreen: label differs between copies — (name only) @ child-of-App; · navService.showDetail() @ root
cylinders: ReadingListScreen: '· navService.showDetail()' names no cylinder 'navService' in the Dependencies box
cylinders: SaveButton: '· analytics.track()' names no cylinder 'analytics' in the Dependencies box
cylinders: SaveButton: '· $prefs.name' names no cylinder 'prefs' in the Dependencies box
ReadingListScreen/AddBookField/MAP.md: AddBookField: evidence target 'bookStore.upsert' is neither a call nor a $ line on the label
APP-MAP.md: Dependencies ~~~ chain disagrees with cylinder listing order
APP-MAP.md: syncService: ingredient 'searchAPI' sits below it (set order)
FocusField/MAP.md: FocusField: evidence block lacks '%% Given:' second line
ReadingListScreen/BookList/MAP.md: BookList: arrow 'Nobody->>somewhere' neither from the node nor a stimulus (depth > 1?)
SaveButton/MAP.md: SaveButton: dashed arrow must return to the node, got 'onSave'
WANT
diff /tmp/mapcheck-want.txt /tmp/mapcheck-got.txt && echo "all planted violations caught, nothing extra" || { echo "FAIL: violations differ"; exit 1; }
python3 mapcheck.py fixtures/broken | grep -q "^WARNING .*in-arrow from .Parent." && echo "parent in-arrow warns, as intended" || { echo "FAIL: Parent in-arrow should warn"; exit 1; }
# the code-side half: the clean Swift stubs verify every bare target; the broken ones plant one of each code finding
echo "clean + sources:" && python3 mapcheck.py fixtures/clean --sources fixtures/clean/Sources | tail -1 | grep -q " 0 errors, 0 warnings, 0 unverified" || { echo "FAIL: clean sources should verify everything"; exit 1; }
echo "broken + sources:" && python3 mapcheck.py fixtures/broken --sources fixtures/broken/Sources | grep -E '^(ERROR|WARNING) +(code:|SaveButton/MAP.md: SaveButton: evidence target)' | sed -E 's/^(ERROR|WARNING) +//' | sort > /tmp/mapcheck-code-got.txt || true
sort > /tmp/mapcheck-code-want.txt <<'WANT'
code: ReadingListScreen: label '· navService.showDetail()' has no such call in ReadingListScreen.swift
code: SaveButton: label '· analytics.track()' has no such call in SaveButton.swift
code: SaveButton: label '· $prefs.name' but SaveButton.swift never touches prefs.name
SaveButton/MAP.md: SaveButton: evidence target 'userName' is no stored property of SaveButton in SaveButton.swift
code: FocusField: label '· @FocusState' but FocusField.swift has no FocusState
code: AddBookField: AddBookField.swift calls bookStore.upsert() with no line on the label
code: BookList: @AppStorage below the root in BookList.swift (F32: the root owns the keys, a feature receives a binding)
code: Furniture (Furniture.swift): on no map, reads dependency bookStore
WANT
diff /tmp/mapcheck-code-want.txt /tmp/mapcheck-code-got.txt && echo "all planted code findings caught, nothing extra" || { echo "FAIL: code findings differ"; exit 1; }
