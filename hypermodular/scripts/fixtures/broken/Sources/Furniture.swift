import SwiftUI

// planted: a view on no map that reads a cylinder
struct Furniture: View {
    @Environment(\.bookStore) private var bookStore: BookStore
    @UnstructuredTask private var load: Task<Void, Never>?
    // planted: two lifecycle modifiers in a view
    var body: some View {
        Text("furniture")
            .onAppear { }
            .task(id: 1) { }
    }

    // not planted: a task assigned through an optional's map is held, on one line or two
    func pick(_ item: Int?) {
        load = item.map { item in Task { _ = item } }
        load = item.map { item in
            Task { _ = item }
        }
    }

    // planted: the only `=` on the line is a default argument, so nobody holds this task
    func each(_ items: [Int], limit: Int = 3) { items.map { item in Task { _ = item } } }
}
