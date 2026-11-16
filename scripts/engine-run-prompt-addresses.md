You are building a small iPhone app with the hypermodular method. The method is four skills. Read them and follow them: `<REPO>/hypermodular/SKILL.md`, `<REPO>/data-coupling/SKILL.md`, `<REPO>/xcode-project/SKILL.md`, and `<COREFLOW>/skill/SKILL.md`, each with the references it points you to. Work only inside `<DIR>`, an empty directory.

The app. An address list. The user keeps addresses, and each address is a street and a city. The app has one screen, the list, and one form for adding.

The list. The screen is titled Addresses. It shows every saved address, one per row, the street on the first line and the city under it. When there are no addresses the screen shows the text "No addresses yet" in place of the rows. An Add button sits in the top bar. Tapping a row does nothing.

Sorting. The list is sorted by street, ascending, from A to Z. A control in the top bar switches the order between ascending and descending. The app does not remember the choice. Every time it is opened the list is ascending again.

Adding. Tapping Add opens the form over the list. The form has two empty text fields, Street and City, a Cancel button, and a Save button. Save is disabled until both fields contain something other than spaces. Tapping Save stores the address as typed, closes the form, and the new address is in the list. Tapping Cancel closes the form and stores nothing. Each time the form opens, both fields are empty again.

Deleting. Swiping a row to the left shows a Delete button. Tapping Delete removes that address from the list at once, with no confirmation and no undo.

Keeping. Addresses are kept in SwiftData. An address the user saved is still in the list after the app is closed and opened again, and a deleted one is still gone.

Nothing else. An address cannot be edited, there is no detail screen, and there is no search.

The machine. Whatever runs, runs in the iPhone 18 Pro simulator. Never drive the Mac's own interface: no System Events, no AppleScript, no accessibility scripting of a Mac app, nothing that takes the mouse or the keyboard. Nobody is available to answer during the run. Where a skill says to agree something with the owner, decide, and report the decision.

When it is done, report: what you built and where it is; every check the skills ask for, with its exact command and its result; every rule of a skill you broke on purpose, with the reason; and every place a skill was unclear, fell short of the app, or made you guess, with file and line.
