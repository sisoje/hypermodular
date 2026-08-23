## Evidence

```mermaid
%% Evidence: BookList · Parent: ReadingListScreen (../MAP.md)
%% Given: @Query [Dune, Anathem] · sortDescending false
sequenceDiagram
    User->>BookList: tap sortToggle
    BookList->>sortDescending: true
    User->>BookList: tap delete-Anathem
    BookList->>bookStore.delete: Anathem
```
