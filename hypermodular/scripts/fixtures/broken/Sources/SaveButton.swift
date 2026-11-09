import SwiftUI

struct SaveButton: View {
    let onSave: (String) -> Void
    let getUserName: () async throws -> Int
    @State private var draft = "draft"

    var body: some View {
        Button("Save") {
            onSave(draft)
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
