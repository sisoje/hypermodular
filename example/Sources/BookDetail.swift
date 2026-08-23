import SwiftUI

// %% Root: BookDetail · Parent: BookShelf
// Label: · imageLoader.loadImage()
// Two criteria: the cover arrives, or the loader throws and nothing is
// written — silence is the evidence.
struct BookDetail: View {
    let book: Book
    @Environment(\.imageLoader) private var imageLoader
    @State private var cover: String?

    var body: some View {
        VStack(spacing: 12) {
            Text(cover ?? "no cover")
                .accessibilityIdentifier("coverLabel")
            Text(book.title).font(.headline)
        }
        .task {
            if let loaded = try? await imageLoader.loadImage(book.coverName) {
                cover = loaded
            }
        }
    }
}
