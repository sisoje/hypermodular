import SwiftUI

// %% Root: Landing · Parent: App
// Label: · loginState.isLoggedIn  — a READ off a dependency: never logs.
struct Landing: View {
    @Environment(\.loginState) private var loginState

    var body: some View {
        if loginState.isLoggedIn {
            Tabs()
        } else {
            LoginScreen()
        }
    }
}

// A bare leaf on the map: mapped, reachable, empty. Finished design.
struct LoginScreen: View {
    var body: some View {
        Text("Sign in").accessibilityIdentifier("loginScreen")
    }
}
