#!/bin/sh
# Regression test for mapcheck.py: the clean fixture (CoreFlowExample's
# validated maps) must pass with zero errors; the broken fixture must
# report exactly the thirteen errors planted in it; of its two warnings,
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
ReadingListScreen/AddBookField/MAP.md: AddBookField: evidence target 'bookStore.upsert' is not a call line on the label
APP-MAP.md: Dependencies ~~~ chain disagrees with cylinder listing order
APP-MAP.md: syncService: ingredient 'searchAPI' sits below it (injection order)
FocusField/MAP.md: FocusField: evidence block lacks '%% Given:' second line
ReadingListScreen/BookList/MAP.md: BookList: arrow 'Nobody->>somewhere' neither from the node nor a stimulus (depth > 1?)
SaveButton/MAP.md: SaveButton: dashed arrow must return to the node, got 'onSave'
WANT
diff /tmp/mapcheck-want.txt /tmp/mapcheck-got.txt && echo "all planted violations caught, nothing extra" || { echo "FAIL: violations differ"; exit 1; }
python3 mapcheck.py fixtures/broken | grep -q "^WARNING .*in-arrow from .Parent." && echo "parent in-arrow warns, as intended" || { echo "FAIL: Parent in-arrow should warn"; exit 1; }
