import SwiftUI
import SwiftData

// A scenario probing the query, as the CoreFlow skill prescribes. On no
// map by design; the checker must not warn about its QueryView.
struct BookListScenario: View {
    var body: some View {
        let byTitle = QueryUtilities.lazyQuery { Query(sort: \Book.title) }
        QueryView(byTitle()) { $books in
            Text("\(books.count)")
        }
        .modelContainer(for: Book.self, inMemory: true)
    }
}
