import SwiftUI

// Planted: an object that owns state, and an @Observable class with a method.
final class SaveViewModel: ObservableObject {
    @Published var name = ""
}

@Observable
final class Session {
    var token: String?
    func logout() { token = nil }
}
