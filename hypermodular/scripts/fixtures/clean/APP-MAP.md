# Fixture: clean — CoreFlowExample's validated maps

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
        settings[(settings)]
        bookStore ~~~ settings
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
