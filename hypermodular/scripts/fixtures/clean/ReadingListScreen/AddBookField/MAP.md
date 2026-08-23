## Evidence

```mermaid
%% Evidence: AddBookField · Parent: ReadingListScreen (../MAP.md)
%% Given: title ""
sequenceDiagram
    User->>AddBookField: tap titleField
    AddBookField->>"title": ""
    User->>AddBookField: type "Dune"
    AddBookField->>"title": Dune
    User->>AddBookField: tap addButton
    AddBookField->>bookStore.insert: Dune
    AddBookField->>"title": ""
```
