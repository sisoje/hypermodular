import SwiftUI

// %% Root: BookShelf · Parent: Library
// Label: · onDelete — a callback the parent handed down.
// books is a value (a sorted fetch, eventually), sortByAuthor a binding
// (storage, eventually), onDelete a closure (a service, eventually).
// Constructible from literals, complete before any of the three exists.
struct BookShelf: View {
    let books: [Book]
    @Binding var sortByAuthor: Bool
    let onDelete: (Book) -> Void

    var body: some View {
        List {
            Toggle("Sort by author", isOn: $sortByAuthor)
                .accessibilityIdentifier("sortToggle")
            ForEach(books) { book in
                NavigationLink {
                    BookDetail(book: book)
                } label: {
                    VStack(alignment: .leading) {
                        Text(book.title).accessibilityIdentifier("bookTitle")
                        Text(book.author).font(.caption).foregroundStyle(.secondary)
                    }
                }
                .swipeActions {
                    Button("Delete", role: .destructive) { onDelete(book) }
                }
            }
        }
    }
}
