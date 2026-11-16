```mermaid
%% Evidence: BookList · Parent: ReadingListScreen (../MAP.md)
%% Given: bookQueries.sorted [Dune, Anathem] · settings.sortDescending false
sequenceDiagram
    User->>BookList: tap sortToggle
    BookList->>settings.sortDescending: true
    User->>BookList: tap delete-Anathem
    BookList->>bookStore.delete: Anathem
```
