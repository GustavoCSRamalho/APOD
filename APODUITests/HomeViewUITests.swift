import XCTest

final class HomeViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        XCUIDevice.shared.orientation = .portrait
    }

    func testHomeViewLoadsAndShowsTitle() throws {
        XCTAssertTrue(app.navigationBars["NASA APOD"].exists)
    }

    func testTapOptionsMenu() {
        let optionsButton = app.buttons["optionsMenu"]
        XCTAssertTrue(optionsButton.waitForExistence(timeout: 5))

        if optionsButton.isHittable {
            optionsButton.tap()
        } else {
            let coordinate = optionsButton.coordinate(withNormalizedOffset: .zero)
            coordinate.tap()
        }

        XCTAssertTrue(app.buttons["List"].waitForExistence(timeout: 2), "O menu não foi aberto corretamente")
        XCTAssertTrue(app.buttons["Favorites"].waitForExistence(timeout: 2), "O menu não mostra favoritos")
    }
}
