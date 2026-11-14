import SwiftUI

struct SaveButton: View {
    @Environment(\.deeplink) private var deeplink
    let onSave: (String) -> Void
    let getUserName: () async throws -> Int
    @State private var draft = "draft"

    var body: some View {
        Button("Save") {
            onSave(draft)
            deeplink(draft)   // planted: a flow called with no line on the label
            Task {
                do {
                    let id = try await getUserName()
                    _ = id
                } catch {
                    _ = error
                }
            }
        }
    }
}
