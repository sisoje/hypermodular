import SwiftUI
import SwiftData

@main
struct ReadingListApp: App {
    @AppStorage("sortDescending") private var sortDescending = false
    @AppStorage("toggleCount") private var toggleCount = 0

    var body: some Scene {
        WindowGroup {
            ReadingListScreen()
                .modifier(LiveStore())
                .modelContainer(for: Book.self)
                .environment(\.settings, Settings(sortDescending: $sortDescending, toggleCount: $toggleCount))
        }
    }
}

private struct LiveStore: ViewModifier {
    @Environment(\.modelContext) private var context

    func body(content: Content) -> some View {
        content.environment(\.bookStore, BookStore(insert: { context.insert($0) }, delete: { context.delete($0) }))
    }
}
