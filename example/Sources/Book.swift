import SwiftData

// The one shared model — Diagram 2, the data coupling layer.
@Model
final class Book {
    var title: String
    var author: String
    var coverName: String

    init(title: String, author: String, coverName: String = "cover") {
        self.title = title
        self.author = author
        self.coverName = coverName
    }
}
