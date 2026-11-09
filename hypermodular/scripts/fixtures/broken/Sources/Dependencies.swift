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

// The root's @AppStorage keys, as bindings.
struct Settings {
    var sortDescending: Binding<Bool> = .constant(false)
    var toggleCount: Binding<Int> = .constant(0)
}

extension EnvironmentValues {
    @Entry var bookStore = BookStore()
    @Entry var settings = Settings()
}
