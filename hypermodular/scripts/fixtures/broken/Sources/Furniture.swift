import SwiftUI

// planted: a view on no map that reads a cylinder
struct Furniture: View {
    @Environment(\.bookStore) private var bookStore: BookStore
    var body: some View { Text("furniture") }
}
