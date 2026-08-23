## Evidence

```mermaid
%% Evidence: SaveButton · Parent: Unmounted (../APP-MAP.md)
%% Given: getUserName throws
sequenceDiagram
    User->>SaveButton: tap saveDraftButton
    SaveButton->>onSave: draft
    SaveButton->>getUserName: 42
    getUserName-->>onSave: throws
    SaveButton->>userName: Error fetching user
```
