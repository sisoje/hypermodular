import SwiftUI

struct SaveButton: View {
    let onSave: (String) -> Void
    let getUserName: () async throws -> Int
    @State private var draft = "draft"
    @State private var userName = ""

    var body: some View {
        SaveRow(draft: draft, onSave: onSave)   // the callback handed down by name, called in furniture
        Button("Save") {
            Task {
                do {
                    let id = try await getUserName()
                    userName = "\(id)"
                } catch {
                    userName = "Error fetching user"
                }
            }
        }
    }
}

private struct SaveRow: View {
    let draft: String
    let onSave: (String) -> Void
    var body: some View { Button("Save draft") { onSave(draft) } }
}
