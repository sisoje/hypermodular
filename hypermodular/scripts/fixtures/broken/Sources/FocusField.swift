import SwiftUI

struct FocusField: View {
    @Environment(\.settings) private var settings: Settings
    @State private var isFocused = false   // planted: the label says @FocusState
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
