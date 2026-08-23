# Book app

```mermaid
%% Root: App
flowchart TD
    App --> Landing["Landing<br/>· loginState.isLoggedIn"]
```

```mermaid
%% Root: App · Dependencies
flowchart LR
    subgraph Dependencies
        direction TB
        imageLoader[(imageLoader)]
        searchAPI[(searchAPI)]
        dbService[(dbService)]
        navService[(navService)]
        loginState[(loginState)]
        authService[("authService<br/>· loginState")]
        syncService[("syncService<br/>· dbService<br/>· searchAPI")]
        imageLoader ~~~ searchAPI ~~~ dbService ~~~ navService ~~~ loginState ~~~ authService ~~~ syncService
    end

    App --> Dependencies

    classDef deps fill:none
    class Dependencies deps
```

```mermaid
%% Root: App · Coupling
classDiagram
    class Book {
        title
        author
    }
    class DbService {
        deleteBook(Book)
    }
    class NavService {
        showDetail(bookId)
    }
    class AuthService {
        logIn()
    }
    class SearchAPI {
        search(query)
    }

    Library ..> DbService
    LoginScreen ..> AuthService
    BookShelf ..> Book
    BookDetail ..> Book
    Search ..> SearchAPI
    Search ..> NavService
```
