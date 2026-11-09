import SwiftUI

struct ReadingListScreen: View {
    @State private var isAdding = false

    var body: some View {
        VStack {
            if isAdding { AddBookField() }
            BookList()
            Button("Add") { isAdding = true }
        }
    }
}
