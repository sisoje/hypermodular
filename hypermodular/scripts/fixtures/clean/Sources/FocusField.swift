import SwiftUI

struct FocusField: View {
    @Environment(\.settings) private var settings: Settings
    @FocusState private var isFocused: Bool
    @State private var text = ""

    var body: some View {
        VStack {
            TextField("Text", text: $text).focused($isFocused)
            Button("Toggle focus") {
                isFocused.toggle()
                settings.toggleCount.wrappedValue += 1
            }
        }
    }
}
