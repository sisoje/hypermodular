import SwiftUI
import SwiftData

// A scenario that asks the query service itself. On no map by design;
// the checker must not warn about the cylinder it reads.
struct BookListScenario: View {
    @Environment(\.bookQueries) private var bookQueries: BookQueries

    var body: some View {
        QueryView(bookQueries.sorted(false)) { $books in
            Text("\(books.count)")
        }
        .modelContainer(for: Book.self, inMemory: true)
    }
}
