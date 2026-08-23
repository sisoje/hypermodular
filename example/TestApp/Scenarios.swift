import SwiftUI
import SwiftData

// A scenario is the hand-written stage that supplies one node's boundaries.
// Macro-free, exactly as the article writes it: values for data, closures
// that record the call instead of performing it, and — where the node was
// handed a binding — a binding that logs its writes.

struct BookShelfScenario: View {
    let log: (String) -> Void
    @State private var sortByAuthor = false

    var body: some View {
        NavigationStack {
            BookShelf(
                books: [Book(title: "Dune", author: "Herbert")],
                sortByAuthor: Binding(
                    get: { sortByAuthor },
                    set: { log("sortByAuthor \($0)"); sortByAuthor = $0 }),
                onDelete: { log("onDelete \($0.title)") })
        }
    }
}

struct BookDetailScenario: View {
    let log: (String) -> Void

    var body: some View {
        BookDetail(book: Book(title: "Dune", author: "Herbert", coverName: "dune.jpg"))
            .environment(\.imageLoader, ImageLoader(loadImage: { name in
                log("loadImage \(name)")
                return "cover"
            }))
    }
}

struct BookDetailFailingScenario: View {
    let log: (String) -> Void

    var body: some View {
        BookDetail(book: Book(title: "Dune", author: "Herbert", coverName: "dune.jpg"))
            .environment(\.imageLoader, ImageLoader(loadImage: { name in
                log("loadImage \(name)")
                throw CancellationError()
            }))
    }
}

struct SearchScenario: View {
    let log: (String) -> Void

    var body: some View {
        Search()
            .environment(\.searchAPI, SearchAPI(search: { query in
                log("search \(query)")
                throw CancellationError()
            }))
            .environment(\.navService, NavService(showDetail: { id in
                log("showDetail \(id)")
            }))
    }
}

struct LibraryScenario: View {
    let log: (String) -> Void
    @State private var container: ModelContainer = {
        let container = try! ModelContainer(
            for: Book.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        container.mainContext.insert(Book(title: "Dune", author: "Herbert"))
        return container
    }()

    var body: some View {
        NavigationStack { Library() }
            .modelContainer(container)
            .environment(\.dbService, DbService(deleteBook: { log("deleteBook \($0.title)") }))
    }
}

struct LandingScenario: View {
    let log: (String) -> Void

    var body: some View {
        Landing()
            .environment(\.loginState, LoginState(isLoggedIn: false))
    }
}
