## Evidence

```mermaid
%% Evidence: Search · Parent: Tabs (../MAP.md)
%% Given: searchAPI offline
sequenceDiagram
    User->>Search: submit "dune"
    Search->>isLoading: true
    Search->>searchAPI.search: dune
    searchAPI.search-->>Search: throws offline
    Search->>isLoading: false
    Search->>error: offline
```
