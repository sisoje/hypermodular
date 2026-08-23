#!/bin/sh
# Regression test for mapcheck.py: the clean fixture (CoreFlowExample's
# validated maps) must pass with zero errors; the broken fixture must
# report exactly the seven violations planted in it.
set -e
cd "$(dirname "$0")"
echo "clean:"  && python3 mapcheck.py fixtures/clean | tail -1 | grep -q " 0 errors" || { echo "FAIL: clean fixture has errors"; exit 1; }
echo "broken:" && python3 mapcheck.py fixtures/broken | grep '^ERROR' | sed 's/^ERROR *//' | sort > /tmp/mapcheck-got.txt || true
sort > /tmp/mapcheck-want.txt <<'WANT'
ReadingListScreen/MAP.md: arrow from 'AddBookField' in a block rooted at 'ReadingListScreen' (depth > 1)
ReadingListScreen/AddBookField/MAP.md: AddBookField: target 'title' is a mermaid reserved word — quote it
Orphan/MAP.md: Orphan: block has no Parent link
Orphan/MAP.md: orphan: no block in this file links to a parent
double-entry: ReadingListScreen: label differs between copies — (name only) @ child-of-App; · navService.showDetail @ root
cylinders: ReadingListScreen: '· navService.showDetail' names no cylinder 'navService' in the Dependencies box
cylinders: SaveButton: '· analytics.track' names no cylinder 'analytics' in the Dependencies box
ReadingListScreen/AddBookField/MAP.md: AddBookField: evidence target 'bookStore.upsert' is not a call line on the label
WANT
diff /tmp/mapcheck-want.txt /tmp/mapcheck-got.txt && echo "all planted violations caught, nothing extra" || { echo "FAIL: violations differ"; exit 1; }
