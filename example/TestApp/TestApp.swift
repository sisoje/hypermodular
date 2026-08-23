import SwiftUI

// The test host: one scenario per launch, selected by the SCENARIO
// environment variable, with the log surfaced on an accessibility element
// the UI tests read.
@main
struct BookAppTestHost: App {
    @State private var entries: [String] = []

    private var scenario: String {
        ProcessInfo.processInfo.environment["SCENARIO"] ?? "BookShelf"
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch scenario {
                case "BookShelf":         BookShelfScenario(log: append)
                case "BookDetail":        BookDetailScenario(log: append)
                case "BookDetailFailing": BookDetailFailingScenario(log: append)
                case "Search":            SearchScenario(log: append)
                case "Library":           LibraryScenario(log: append)
                case "Landing":           LandingScenario(log: append)
                case "LoginScreen":       LoginScreenScenario(log: append)
                default:                  Text("unknown scenario \(scenario)")
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("log")
            .accessibilityValue(encoded)
        }
    }

    private func append(_ entry: String) {
        entries.append(entry)
    }

    private var encoded: String {
        (try? String(data: JSONEncoder().encode(entries), encoding: .utf8)) as? String ?? "[]"
    }
}
