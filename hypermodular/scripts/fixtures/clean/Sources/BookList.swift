import SwiftUI
import SwiftData

struct BookList: View {
    @Environment(\.bookStore) private var bookStore: BookStore
    @Environment(\.bookQueries) private var bookQueries: BookQueries
    @Environment(\.settings) private var settings: Settings

    var body: some View {
        QueryView(bookQueries.sorted(settings.sortDescending.wrappedValue)) { $books in
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
