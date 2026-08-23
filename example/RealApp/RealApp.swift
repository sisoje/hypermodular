import SwiftUI
import SwiftData

// The root: the ONE owner of app-level state, and the only place injection
// happens. loginState flows down as a fact; authService is a closure over
// that same root-owned state — how it is assembled is implementation
// detail and never drawn (the derived cylinder just lists its ingredient).
@main
struct BookApp: App {
    @State private var login = LoginState(isLoggedIn: false)

    var body: some Scene {
        WindowGroup {
            Landing()
                .modifier(LiveDb())
                .modelContainer(for: Book.self)
                .environment(\.loginState, login)
                .environment(\.authService, AuthService(logIn: { login.isLoggedIn = true }))
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
