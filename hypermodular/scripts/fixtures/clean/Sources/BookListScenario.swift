import SwiftUI
import SwiftData

// A scenario probing the query, as the CoreFlow skill prescribes. On no
// map by design; the checker must not warn about its QueryView.
struct BookListScenario: View {
    var body: some View {
        QueryView(query: Query(sort: \Book.title), dependencies: [false]) { $books in
            Text("\(books.count)")
        }
        .modelContainer(for: Book.self, inMemory: true)
    }
}
