import SwiftUI

// %% Root: Tabs · Parent: Landing
// Name-only label: receives everything, calls nothing. Pure composition.
struct Tabs: View {
    var body: some View {
        TabView {
            NavigationStack { Library() }
                .tabItem { Label("Library", systemImage: "books.vertical") }
            NavigationStack { Search() }
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
    }
}
