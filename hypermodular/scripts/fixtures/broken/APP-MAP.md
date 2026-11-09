# Fixture: broken — DELIBERATELY WRONG, not an example

The clean fixture with fourteen errors and two warnings planted in it for
`scripts/test.sh`. Every block here violates the doctrine somewhere.
Never model a map on this directory.

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
        syncService[("syncService<br/>· bookStore<br/>· searchAPI")]
        bookStore[(bookStore)]
        searchAPI[(searchAPI)]
        settings[(settings)]
        bookStore ~~~ syncService ~~~ searchAPI ~~~ settings
    end
    App --> Dependencies
    classDef deps fill:none
    class Dependencies deps
```

## Unmounted

```mermaid
%% Root: App · Unmounted
flowchart TD
    SaveButton["SaveButton<br/>· onSave<br/>· getUserName<br/>· analytics.track()<br/>· $prefs.name"]
    FocusField["FocusField<br/>· $settings.toggleCount<br/>· @FocusState"]
```
