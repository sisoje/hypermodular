You are evaluating whether a SwiftUI architecture skill is understandable. Read `data-coupling/SKILL.md` in full first. Read files under `data-coupling/references/` only when the skill points you there for a question. Do not read anything else, and do not edit any file.

Then answer these questions, from the skill only, in your own words, two to four sentences each. Where you can, cite the line of the skill you relied on.

1. A child view receives `seed: Int` from its parent, declares `@State private var doubler: Doubler`, and sets it in `init` with `State(wrappedValue: Doubler(seed: seed))`. The parent later hands a new seed. What does the child show, how many `Doubler`s were built over three creations, and what does the skill call the kept one?
2. A teammate swaps that for a wrapper whose initial value is a closure that runs once. Which problem does that remove and which does it leave?
3. A view's `init(id:)` builds its `@Query` from `id`, and another view's `init(id:)` builds a model object from it. What does the skill say the two have in common, and what replaces each?
4. A list row is tapped and a detail screen is pushed. The detail needs data from a service. Where is the load started, which node holds the task, and what does the detail screen receive? What goes wrong, concretely, if the detail carries `.task { await load() }` instead?
5. A screen has a sort toggle and refetches when the sort changes. A teammate writes `.task(id: sortByAuthor) { … }`. What does the skill say, and when is `.task(id:)` used at all?
6. A teammate adds `.onChange(of: selection) { haptics.play() }` to a node, for a selection its parent owns. What does the skill say, and where does the haptic go?
7. The first screen the app shows needs to load its list at launch. What starts that load, and on which node does it hang? Why that node?
8. A feature has to react when the app is opened from a link and when the app goes to the background. By what test does the skill recognize this case, where does the system's own modifier go, where does the handling go, and how does a scenario make the event happen?
9. What does the skill say the struct of a view is, as against the view on screen, and which of the two has a lifecycle?
10. The skill names one principle that every rule serves. Which, and what does each of its two halves hold?

Then one design task. You are given a brief, as a manager would write it. Do it the way the skill asks, in Swift, under 130 lines, with the tests you would ship. Say what, if anything, is left without a test and why.

> The product. A recipes app. The Recipes screen lists the user's recipes, and tapping one opens it. An open recipe shows its steps, loaded from our server, and a cooking timer the user starts with a button.
>
> What we want next.
> 1. Links. A link like `recipes://recipe/17`, sent in a message or a notification, opens that recipe.
> 2. The timer. A running cooking timer stops counting when the user leaves the app and continues when they come back.
>
> Stack. SwiftUI, iOS 27, Swift 6. swift-core-flow is already a dependency. The URL scheme `recipes` is already registered.

Finally, list every place where the skill was unclear, contradictory, or where you had to guess, with the line number. Be specific: quote the sentence and say what confused you. If nothing confused you, say so. Report the answers, the code, and the list as your final message.
