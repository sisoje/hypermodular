import SwiftUI
import SwiftData

// The root, and the only place injection happens — one arrow into the
// Dependencies box. Every live closure is assembled here.
@main
struct BookApp: App {
    var body: some Scene {
        WindowGroup {
            Landing()
                .modelContainer(for: Book.self)
                .environment(\.loginState, LoginState(isLoggedIn: true))
                .environment(\.imageLoader, ImageLoader(loadImage: { name in name }))
                .environment(\.searchAPI, SearchAPI(search: { _ in [] }))
                .environment(\.navService, NavService(showDetail: { _ in }))
        }
    }
}
