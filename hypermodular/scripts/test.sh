#!/bin/sh
# Regression test for mapcheck.py: the clean fixture (CoreFlowExample's
# validated maps) must pass with zero errors; the broken fixture must
# report exactly the fourteen errors planted in it; of its two warnings,
# the Parent in-arrow is asserted (ruled no stimulus by F79; a warning,
# since a rule may be broken).
set -e
cd "$(dirname "$0")"
echo "clean:"  && python3 mapcheck.py fixtures/clean | tail -1 | grep -q " 0 errors" || { echo "FAIL: clean fixture has errors"; exit 1; }
echo "broken:" && python3 mapcheck.py fixtures/broken | grep '^ERROR' | sed 's/^ERROR *//' | sort > /tmp/mapcheck-got.txt || true
sort > /tmp/mapcheck-want.txt <<'WANT'
Maps/ReadingListScreen/MAP.md: arrow from 'AddBookField' in a block rooted at 'ReadingListScreen' (depth > 1)
Maps/ReadingListScreen/AddBookField/AddDune.md: AddBookField: target 'title' is a mermaid reserved word — quote it
Maps/Orphan/MAP.md: Orphan: block has no Parent link
Maps/Orphan/MAP.md: orphan: no block in this file links to a parent
double-entry: ReadingListScreen: label differs between copies — (name only) @ child-of-App; · navService.showDetail() @ root
cylinders: ReadingListScreen: '· navService.showDetail()' names no cylinder 'navService' in the Dependencies box
cylinders: SaveButton: '· analytics.track()' names no cylinder 'analytics' in the Dependencies box
cylinders: SaveButton: '· $prefs.name' names no cylinder 'prefs' in the Dependencies box
Maps/ReadingListScreen/AddBookField/AddDune.md: AddBookField: evidence target 'bookStore.upsert' is neither a call nor a $ line on the label
APP-MAP.md: Dependencies ~~~ chain disagrees with cylinder listing order
APP-MAP.md: syncService: ingredient 'searchAPI' sits below it (set order)
Maps/FocusField/ToggleFocus.md: FocusField: evidence block lacks '%% Given:' second line
Maps/ReadingListScreen/BookList/SortAndDelete.md: BookList: arrow 'Nobody->>somewhere' neither from the node nor a stimulus (depth > 1?)
Maps/SaveButton/SaveDraft.md: SaveButton: dashed arrow must return to the node, got 'onSave'
WANT
diff /tmp/mapcheck-want.txt /tmp/mapcheck-got.txt && echo "all planted violations caught, nothing extra" || { echo "FAIL: violations differ"; exit 1; }
python3 mapcheck.py fixtures/broken | grep -q "^WARNING .*in-arrow from .Parent." && echo "parent in-arrow warns, as intended" || { echo "FAIL: Parent in-arrow should warn"; exit 1; }
# the whole-app diagram: the clean fixture carries it, a changed map makes it stale, and --write redraws it
rm -rf /tmp/mapcheck-whole && cp -R fixtures/clean /tmp/mapcheck-whole
sed -i '' 's/|isAdding|/|isAddingBook|/' /tmp/mapcheck-whole/Maps/ReadingListScreen/MAP.md
python3 mapcheck.py /tmp/mapcheck-whole | grep -q "^ERROR .*the whole-app diagram is stale" && echo "a changed map makes the whole-app diagram stale" || { echo "FAIL: stale whole-app diagram not reported"; exit 1; }
python3 mapcheck.py /tmp/mapcheck-whole --write | tail -1 | grep -q " 0 errors" && python3 mapcheck.py /tmp/mapcheck-whole | tail -1 | grep -q " 0 errors" && echo "--write redraws it" || { echo "FAIL: --write did not redraw the whole-app diagram"; exit 1; }
python3 mapcheck.py fixtures/broken | grep -q "^WARNING .*no whole-app diagram" && echo "a missing whole-app diagram warns" || { echo "FAIL: a missing whole-app diagram should warn"; exit 1; }
# the code-side half: the clean Swift stubs verify every bare target; the broken ones plant one of each code finding
echo "clean + sources:" && python3 mapcheck.py fixtures/clean --sources fixtures/clean/Sources | tail -1 | grep -q " 0 errors, 0 warnings, 0 unverified" || { echo "FAIL: clean sources should verify everything"; exit 1; }
echo "broken + sources:" && python3 mapcheck.py fixtures/broken --sources fixtures/broken/Sources | grep -E '^(ERROR|WARNING) +(code:|Maps/SaveButton/SaveDraft.md: SaveButton: evidence target|Maps/ReadingListScreen/MAP.md: ReadingListScreen: arrow label)' | sed -E 's/^(ERROR|WARNING) +//' | sort > /tmp/mapcheck-code-got.txt || true
sort > /tmp/mapcheck-code-want.txt <<'WANT'
code: ReadingListScreen: label '· navService.showDetail()' has no such call in ReadingListScreen.swift
Maps/ReadingListScreen/MAP.md: ReadingListScreen: arrow label 'ghost' names no stored property or read of ReadingListScreen in ReadingListScreen.swift
code: SaveButton: label '· analytics.track()' has no such call in SaveButton.swift
code: SaveButton: label '· $prefs.name' but SaveButton.swift never touches prefs.name
Maps/SaveButton/SaveDraft.md: SaveButton: evidence target 'userName' is no stored property of SaveButton in SaveButton.swift
code: FocusField: label '· @FocusState' but FocusField.swift has no FocusState
code: AddBookField: AddBookField.swift calls bookStore.upsert() with no line on the label
code: BookList: @AppStorage below the root in BookList.swift (F32: the root owns the keys, a feature receives a binding)
code: Furniture (Furniture.swift): on no map, reads dependency bookStore
code: SaveButton.swift: a Task nobody holds, 'Task {' (F37: assign it to a slot the node holds)
code: SaveButton: SaveButton.swift calls deeplink() with no line on the label
code: Furniture.swift: a lifecycle modifier in a view, '.onAppear { }' (F77 to F81: the action that causes the work does it; a value the app does not control is heard in one modifier at the root)
code: Furniture.swift: a lifecycle modifier in a view, '.task(id: 1) { }' (F77 to F81: the action that causes the work does it; a value the app does not control is heard in one modifier at the root)
WANT
diff /tmp/mapcheck-code-want.txt /tmp/mapcheck-code-got.txt && echo "all planted code findings caught, nothing extra" || { echo "FAIL: code findings differ"; exit 1; }
