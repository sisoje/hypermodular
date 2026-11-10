import SwiftUI

// planted: a view on no map that reads a cylinder
struct Furniture: View {
    @Environment(\.bookStore) private var bookStore: BookStore
    @StateObject private var model = SaveViewModel()   // planted: an object behind a wrapper
    var body: some View { Text("furniture") }
}
