import SwiftUI

struct AddBookField: View {
    @Environment(\.bookStore) private var bookStore: BookStore
    @State private var title = ""

    var body: some View {
        HStack {
            TextField("Title", text: $title)
            Button("Add") {
                bookStore.insert(Book(title: title))
                title = ""
            }
        }
    }
}
