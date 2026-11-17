import SwiftUI
import SwiftData

// planted: a query made in a view whose type lists View second. On no
// map by design, a scenario.
struct TitleCountScenario: Equatable, View {
    var body: some View {
        let titles = QueryUtilities.lazyQuery { Query(sort: \Book.title) }
        QueryView(titles()) { $books in
            Text("\(books.count)")
        }
        .modelContainer(for: Book.self, inMemory: true)
    }
}
