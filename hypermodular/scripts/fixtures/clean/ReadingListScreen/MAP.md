```mermaid
%% Root: ReadingListScreen · Parent: App (../APP-MAP.md)
flowchart TD
    ReadingListScreen --> AddBookField["AddBookField<br/>· bookStore.insert"]
    ReadingListScreen --> BookList["BookList<br/>· @Query<br/>· @AppStorage<br/>· bookStore.delete"]
```
