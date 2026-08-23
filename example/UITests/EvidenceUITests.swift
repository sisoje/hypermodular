import XCTest

// Each test drives one scenario for real and asserts its evidence log —
// the array that was written in the map, before any of this code existed.
// Comparing two values; no mock is inspected, no effect is executed.

@MainActor
final class EvidenceUITests: XCTestCase {

    private func launch(_ scenario: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["SCENARIO"] = scenario
        app.launch()
        return app
    }

    private func log(_ app: XCUIApplication) -> [String] {
        let raw = app.otherElements["log"].value as? String ?? "[]"
        return (try? JSONDecoder().decode([String].self, from: Data(raw.utf8))) ?? []
    }

    private func waitForLog(_ app: XCUIApplication, toEqual expected: [String]) {
        let deadline = Date().addingTimeInterval(5)
        while Date() < deadline {
            if log(app) == expected { return }
            _ = app.otherElements["log"].waitForExistence(timeout: 0.2)
        }
        XCTAssertEqual(log(app), expected)
    }

    // %% Evidence: BookShelf · Given: books [Dune] · sortByAuthor false
    // ["sortByAuthor true", "onDelete Dune"]
    func testBookShelfLogsTheSortWriteThenTheDeleteCallback() {
        let app = launch("BookShelf")
        XCTAssertTrue(app.switches["sortToggle"].waitForExistence(timeout: 5))
        app.switches["sortToggle"].switches.firstMatch.tap()
        let row = app.cells.containing(.staticText, identifier: "Dune").firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        row.swipeLeft()
        let delete = app.buttons["Delete"]
        XCTAssertTrue(delete.waitForExistence(timeout: 5))
        delete.tap()
        waitForLog(app, toEqual: ["sortByAuthor true", "onDelete Dune"])
    }

    // %% Evidence: BookDetail · Given: imageLoader returns cover
    // ["loadImage dune.jpg"], and the cover is written
    func testBookDetailLoadsTheCover() {
        let app = launch("BookDetail")
        XCTAssertTrue(app.staticTexts["coverLabel"].waitForExistence(timeout: 5))
        waitForLog(app, toEqual: ["loadImage dune.jpg"])
        XCTAssertEqual(app.staticTexts["coverLabel"].label, "cover")
    }

    // %% Evidence: BookDetail · Given: imageLoader throws
    // ["loadImage dune.jpg"] — and no cover written. Silence is the evidence.
    func testBookDetailWritesNothingWhenTheLoaderThrows() {
        let app = launch("BookDetailFailing")
        XCTAssertTrue(app.staticTexts["coverLabel"].waitForExistence(timeout: 5))
        waitForLog(app, toEqual: ["loadImage dune.jpg"])
        XCTAssertEqual(app.staticTexts["coverLabel"].label, "no cover")
    }

    // %% Evidence: Search · Given: searchAPI offline
    // ["search dune"] — the call is the event; the throw is supplied data.
    func testSearchLogsTheCallAndReportsOffline() {
        let app = launch("Search")
        XCTAssertTrue(app.textFields["searchField"].waitForExistence(timeout: 5))
        app.textFields["searchField"].tap()
        app.textFields["searchField"].typeText("dune")
        app.buttons["searchButton"].tap()
        waitForLog(app, toEqual: ["search dune"])
        XCTAssertEqual(app.staticTexts["statusLabel"].label, "offline")
    }

    // %% Evidence: Library · the deleteBook call at the parent's edge —
    // the same swipe that is "onDelete Dune" one level down (one event,
    // two edges). Its @AppStorage write is own storage: F20, asserted
    // nowhere here.
    func testLibraryDelegatesTheDeleteToTheDbService() {
        let app = launch("Library")
        let row = app.cells.containing(.staticText, identifier: "Dune").firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        row.swipeLeft()
        let delete = app.buttons["Delete"]
        XCTAssertTrue(delete.waitForExistence(timeout: 5))
        delete.tap()
        waitForLog(app, toEqual: ["deleteBook Dune"])
    }

    // Landing reads loginState and calls nothing: its log stays empty.
    // A read never logs — that is the whole point of the bare-dot line.
    func testLandingLogsNothingAndShowsTheGate() {
        let app = launch("Landing")
        XCTAssertTrue(app.staticTexts["loginScreen"].waitForExistence(timeout: 5))
        XCTAssertEqual(log(app), [])
    }
}
