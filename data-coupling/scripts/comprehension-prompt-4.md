You are evaluating whether a SwiftUI architecture skill is understandable. Read `data-coupling/SKILL.md` in full first. Read files under `data-coupling/references/` only when the skill points you there for a question. Do not read anything else, and do not edit any file.

Then answer these questions, from the skill only, in your own words, two to four sentences each. Where you can, cite the line of the skill you relied on.

1. A screen lists the user's books, kept on the device, in an order decided by a flag the screen is handed. Where does the screen get the books, what does it pass, and what does it get back?
2. A teammate writes `@Query(sort: \Book.title) private var books: [Book]` in a new screen. What does the skill say, and what does the screen write in its place?
3. A teammate writes `let byAuthor = QueryUtilities.lazyQuery { (author: String) in Query(filter: …) }` in a node, asks it with `QueryView(byAuthor(author))`, and later makes the filter read a second value, which the closure captures. What can go wrong, does anything report it, and what removes the problem?
4. Where is the expression that sorts the books written, how many times, and which module holds it? Which test proves the order, and does that test need a view?
5. What does the environment entry of the store's reads default to, who writes that value, and how does it differ from every other contract's default?
6. A node's scenario needs three books on screen. What does the scenario set for the store's reads, and how does it supply the books?
7. A view written before the method holds a `@Query`, and the team converts the app one view at a time. What happens to that `@Query` now, and when does the read change?
8. Does reading the books produce an entry in the execution log? Why, in the skill's terms?

Then one design task. You are given a brief, as a manager would write it. Do it the way the skill asks, in Swift, under 150 lines, with the tests you would ship. Say what, if anything, is left without a test and why.

> The product. A wine cellar app. The Cellar screen lists the user's bottles, which are kept on the phone. A bottle has a name and a vintage year.
>
> What we want next.
> 1. Order. A control on the Cellar screen switches the list between by name and by vintage, newest first.
> 2. Search. A search field narrows the list to the bottles whose name contains what the user typed.
>
> Stack. SwiftUI, SwiftData, iOS 27, Swift 6. swift-core-flow is already a dependency.

Finally, list every place where the skill was unclear, contradictory, or where you had to guess, with the line number. Be specific: quote the sentence and say what confused you. If nothing confused you, say so. Report the answers, the code, and the list as your final message.
