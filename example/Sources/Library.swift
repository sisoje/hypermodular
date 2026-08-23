import SwiftUI
import SwiftData

// %% Root: Library · Parent: Tabs
// Label: · @Query  · @AppStorage  · dbService.deleteBook()
// The fetch and the store live here, lifted out of the shelf that shows them.
struct Library: View {
    @Query private var books: [Book]
    @AppStorage("sortByAuthor") private var sortByAuthor = false
    @Environment(\.dbService) private var dbService

    var body: some View {
        BookShelf(
            books: sortByAuthor
                ? books.sorted { $0.author < $1.author }
                : books.sorted { $0.title < $1.title },
            sortByAuthor: $sortByAuthor,
            onDelete: { dbService.deleteBook($0) })
    }
}
