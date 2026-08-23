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

// %% Root: LoginScreen · Parent: Landing
// Label: · authService.logIn()
// It calls; it never learns whether that worked. The root owns the login
// state, so the gate flipping is the root's wiring, not this node's.
struct LoginScreen: View {
    @Environment(\.authService) private var authService

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign in").accessibilityIdentifier("loginScreen")
            Button("Log in") { authService.logIn() }
                .accessibilityIdentifier("loginButton")
        }
    }
}
