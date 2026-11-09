You are evaluating whether a SwiftUI architecture skill is understandable. Read `data-coupling/SKILL.md` in full first. Read files under `data-coupling/references/` only when the skill points you there for a question. Do not read anything else, and do not edit any file.

Then answer these questions, from the skill only, in your own words, two to four sentences each. Where you can, cite the line of the skill you relied on.

1. A view owns `@State var token: String?` and hands `$token` to its children. Logging out must also clear the keychain and cancel an in-flight refresh task. A teammate adds `.onChange(of: token) { _, new in if new == nil { clearKeychain() } }`. What does the skill say about that, and what is the alternative?
2. The app's API client is a generated struct with 340 async closures, one per endpoint. A reviewer asks for it to be split into per-feature services because it is too big. What does the skill say?
3. "What if someone forgets to set the `@Entry` for the store at the root?" What does the skill say to do about that?
4. A search screen needs `@FocusState` for its text field. Where does the focus state live in the by-hand cut, where does it live with `@Shell`, and how does a test see it?
5. A teammate puts an `@Observable final class SessionStore` into the environment with `.environment(store)` and reads it in the core with `@Environment(SessionStore.self)`. Is that what the skill means by "a core reads the environment as it reads a binding"? Why or why not?
6. After logout the app must show the login screen. A teammate adds a route named `logout` and pushes it from the place the token is cleared. What does the skill say about how the login screen appears?

Then one design task. Write an `Account` SwiftUI view with a Sign out button. Signing out sets the session token to nil; the app must then clear the keychain and show the login screen. Decide what enters `Account` (lets, bindings, closures, environment values), write its stored properties and `body` in Swift, write the test scenario that constructs it with logging boundaries, and write the expected execution log for one acceptance criterion: "signing out clears the token". Say where the keychain clearing and the login screen live, and why they are or are not in `Account`'s log. Keep it under 60 lines of Swift total. No ViewModel, no protocol, no mock class, no `.onChange`.

Finally, list every place where the skill was unclear, contradictory, or where you had to guess, with the line number. Be specific: quote the sentence and say what confused you. If nothing confused you, say so. Report the answers, the code, and the list as your final message.
