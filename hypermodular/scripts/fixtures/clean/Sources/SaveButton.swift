import SwiftUI

struct SaveButton: View {
    let onSave: (String) -> Void
    let getUserName: () async throws -> Int
    @State private var draft = "draft"
    @State private var userName = ""

    var body: some View {
        Button("Save") {
            onSave(draft)
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
