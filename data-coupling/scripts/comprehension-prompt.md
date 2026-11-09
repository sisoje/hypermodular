You are evaluating whether a SwiftUI architecture skill is understandable. Read `data-coupling/SKILL.md` in full first. Read files under `data-coupling/references/` only when the skill points you there for a question. Do not read anything else, and do not edit any file.

Then answer these questions, from the skill only, in your own words, two to four sentences each. Where you can, cite the line of the skill you relied on.

1. A `Book` model has an `isbn` field. A teammate wants `Book.init` to reject invalid ISBNs and wants `isbn` behind `private(set)`. What does the skill say, and why?
2. A screen needs to fetch search results from a REST API. In what form does the API reach the view, and what does the view know about HTTP?
3. The same screen needs to validate the search text before submitting (non-empty, under 100 characters). Where does that validation live and in what form does it reach the view?
4. May the inner part of a view (the "core") read a value with `@Environment`? Why or why not?
5. A teammate has removed the ViewModel and replaced it with `final class BookStore` that has `load()` and `delete(_:)` methods and holds the loaded array, passed into the view as `let store: BookStore`. Is this in line with the skill? If not, what should they do instead?
6. A view is handed `@Binding var sortByAuthor: Bool` and a closure `onDelete: (Book) -> Void`. Tapping a toggle flips the binding, swiping a row calls the closure. How is this behavior tested, what does the test compare, and what is the role of a UI test?

Then one design task. Write a `Favorites` SwiftUI view following the skill: it shows a list of `Book`s, lets the user star or unstar one, and persists the star through a service. Decide what enters the view (lets, bindings, closures, environment values), write the struct's stored properties and `body` in Swift, write the test scenario that constructs it with logging boundaries, and write the expected execution log for one acceptance criterion: "starring Dune persists the star". Keep it short, under 80 lines of Swift total. No ViewModel, no protocol, no mock class.

Finally, list every place where the skill was unclear, contradictory, or where you had to guess, with the line number. Be specific: quote the sentence and say what confused you. If nothing confused you, say so. Report the answers, the code, and the list as your final message.
