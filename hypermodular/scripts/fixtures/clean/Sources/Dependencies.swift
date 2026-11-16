import SwiftUI

// The data coupling layer of the reading-list fixture. Never compiled;
// read by mapcheck.py --sources.
struct Book {
    var title: String
}

struct BookStore {
    var insert: (Book) -> Void = { _ in }
    var delete: (Book) -> Void = { _ in }
}

// The store's reads, the query service. A member takes what its query
// depends on and answers the query not built yet.
@LazyQueries
struct BookQueries {
    var sorted: (_ descending: Bool) -> LazyQuery<Book, [Book]>
}

// The root's @AppStorage keys, as bindings.
struct Settings {
    var sortDescending: Binding<Bool> = .constant(false)
    var toggleCount: Binding<Int> = .constant(0)
}

extension EnvironmentValues {
    @Entry var bookStore = BookStore()
    @Entry var bookQueries = BookQueries.defaultQueries
    @Entry var settings = Settings()
}
