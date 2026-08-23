```mermaid
%% Root: Library · Parent: Tabs (../MAP.md)
flowchart TD
    Library["Library<br/>· @Query<br/>· @AppStorage<br/>· dbService.deleteBook()"] --> BookShelf["BookShelf<br/>· onDelete"]
```

## Evidence

```mermaid
%% Evidence: Library · Parent: Tabs (../MAP.md)
%% Given: @Query [Dune] · sortByAuthor false
sequenceDiagram
    User->>Library: tap sort toggle
    Library->>sortByAuthor: true
    User->>Library: swipe delete Dune
    Library->>dbService.deleteBook: Dune
```

Library is the shelf's parent: the toggle and the swipe happen inside
its collapsed subtree, and at Library's edge they are a storage write
and a capability call. The shelf's own block shows the same two
interactions as a binding write and a callback — the same events, one
level down.
