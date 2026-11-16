# Fixture: clean — CoreFlowExample's validated maps

<!-- whole-app: drawn by mapcheck.py --write from the maps below and under Maps/, never by hand -->
```mermaid
%% Whole: App
flowchart TD
    App
    ReadingListScreen
    AddBookField["AddBookField<br/>· bookStore.insert()"]
    BookList["BookList<br/>· bookQueries.sorted<br/>· $settings.sortDescending<br/>· bookStore.delete()"]
    App --> ReadingListScreen
    ReadingListScreen -->|isAdding| AddBookField
    ReadingListScreen --> BookList
    subgraph Unmounted
        SaveButton["SaveButton<br/>· onSave<br/>· getUserName"]
        FocusField["FocusField<br/>· $settings.toggleCount<br/>· @FocusState"]
    end
    subgraph Dependencies
        direction TB
        bookStore[(bookStore)]
        bookQueries[(bookQueries)]
        settings[(settings)]
    end
    AddBookField -.-> bookStore
    BookList -.-> bookStore
    BookList -.-> bookQueries
    BookList -.-> settings
    FocusField -.-> settings
    classDef plain fill:none
    class Unmounted,Dependencies plain
```
<!-- /whole-app -->

Regression input for `scripts/mapcheck.py`; must pass with zero errors.
These maps are correct by the doctrine and may be read as examples.

```mermaid
%% Root: App
flowchart TD
    App --> ReadingListScreen
```

```mermaid
%% Root: App · Dependencies
flowchart LR
    subgraph Dependencies
        direction TB
        bookStore[(bookStore)]
        bookQueries[(bookQueries)]
        settings[(settings)]
        bookStore ~~~ bookQueries ~~~ settings
    end
    App --> Dependencies
    classDef deps fill:none
    class Dependencies deps
```

## Unmounted

```mermaid
%% Root: App · Unmounted
flowchart TD
    SaveButton["SaveButton<br/>· onSave<br/>· getUserName"]
    FocusField["FocusField<br/>· $settings.toggleCount<br/>· @FocusState"]
```
