import SwiftUI
import SwiftData

// The root, and the only place injection happens — one arrow into the
// Dependencies box. Every live closure is assembled here.
@main
struct BookApp: App {
    var body: some Scene {
        WindowGroup {
            Landing()
                .modifier(LiveDb())
                .modelContainer(for: Book.self)
                .environment(\.loginState, LoginState(isLoggedIn: true))
                .environment(\.imageLoader, ImageLoader(loadImage: { name in name }))
                .environment(\.searchAPI, SearchAPI(search: { _ in [] }))
                .environment(\.navService, NavService(showDetail: { _ in }))
        }
    }
}

// The live dbService, assembled beside the SwiftData it wires. The injector
// modifier is implementation detail — it never appears on a map.
private struct LiveDb: ViewModifier {
    @Environment(\.modelContext) private var context

    func body(content: Content) -> some View {
        content.environment(\.dbService, DbService(deleteBook: { context.delete($0) }))
    }
}
