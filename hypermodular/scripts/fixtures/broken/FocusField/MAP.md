## Evidence

```mermaid
%% Evidence: FocusField · Parent: Unmounted (../APP-MAP.md)
%% Given: toggleCount 0 · unfocused
sequenceDiagram
    User->>FocusField: tap focusTextField
    Note over FocusField: focus moved by the system — nothing logged
    User->>FocusField: tap toggleFocusButton
    FocusField->>isFocused: false
    FocusField->>toggleCount: 1
```
