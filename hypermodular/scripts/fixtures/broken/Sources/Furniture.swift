import SwiftUI

// planted: a view on no map that reads a cylinder
struct Furniture: View {
    @Environment(\.bookStore) private var bookStore: BookStore
    // planted: two lifecycle modifiers in a view
    var body: some View {
        Text("furniture")
            .onAppear { }
            .task(id: 1) { }
    }
}
