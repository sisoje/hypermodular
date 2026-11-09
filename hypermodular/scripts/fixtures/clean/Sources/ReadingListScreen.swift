import SwiftUI

struct ReadingListScreen: View {
    var body: some View {
        VStack {
            AddBookField()
            BookList()
        }
    }
}
