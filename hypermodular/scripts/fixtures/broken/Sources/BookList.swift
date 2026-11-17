import SwiftUI
import SwiftData

struct BookList: View {
    @Environment(\.bookStore) private var bookStore: BookStore
    @Environment(\.settings) private var settings: Settings
    @AppStorage("sortDescending") private var localCopy = false   // planted: F32, a key below the root

    var body: some View {
        let sorted = QueryUtilities.lazyQuery { (descending: Bool) in
            Query(sort: \Book.title, order: descending ? .reverse : .forward)
        }
        QueryView(sorted(settings.sortDescending.wrappedValue)) { $books in
            List {
                Toggle("Descending", isOn: settings.sortDescending)
                ForEach(books, id: \.title) { book in
                    Text(book.title)
                        .swipeActions { Button("Delete") { bookStore.delete(book) } }
                }
            }
        }
    }
}
