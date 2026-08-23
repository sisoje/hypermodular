import SwiftUI

// %% Root: Search · Parent: Tabs
// Label: · searchAPI.search()  · navService.showDetail()
struct Search: View {
    @Environment(\.searchAPI) private var searchAPI
    @Environment(\.navService) private var navService
    @State private var query = ""
    @State private var isLoading = false
    @State private var error: String?
    @State private var results: [Book] = []

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $query)
                    .accessibilityIdentifier("searchField")
                Button("Go") { Task { await run() } }
                    .accessibilityIdentifier("searchButton")
            }
            .padding(.horizontal)

            Text(error ?? (isLoading ? "loading" : "idle"))
                .accessibilityIdentifier("statusLabel")

            List(results) { book in
                Text(book.title).onTapGesture { navService.showDetail(book.title) }
            }
        }
    }

    private func run() async {
        isLoading = true
        error = nil
        do {
            results = try await searchAPI.search(query)
        } catch {
            self.error = "offline"
        }
        isLoading = false
    }
}
