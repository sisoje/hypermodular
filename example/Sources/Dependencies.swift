import SwiftUI

// Diagram 3, one struct per cylinder. Plain values composed of closures and
// lets — no protocols, no classes. The live implementation, the preview stub
// and the logging spec host are different member sets of the same struct.

struct LoginState: Equatable {
    var isLoggedIn: Bool
}

struct DbService {
    var deleteBook: (Book) -> Void
}

struct ImageLoader {
    var loadImage: (String) async throws -> String
}

struct SearchAPI {
    var search: (String) async throws -> [Book]
}

struct NavService {
    var showDetail: (String) -> Void
}

struct AuthService {
    var logIn: () -> Void
}

extension EnvironmentValues {
    @Entry var loginState = LoginState(isLoggedIn: true)
    @Entry var dbService = DbService(deleteBook: { _ in })
    @Entry var imageLoader = ImageLoader(loadImage: { _ in "" })
    @Entry var searchAPI = SearchAPI(search: { _ in [] })
    @Entry var navService = NavService(showDetail: { _ in })
    @Entry var authService = AuthService(logIn: { })
}
