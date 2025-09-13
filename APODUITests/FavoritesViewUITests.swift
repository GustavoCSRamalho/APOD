import XCTest

final class FavoritesViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testOpenFavoritesView() {
        let optionsButton = app.buttons["optionsMenu"]
        XCTAssertTrue(optionsButton.waitForExistence(timeout: 5), "Botão de opções não apareceu na Home")

        if optionsButton.isHittable {
            optionsButton.tap()
        } else {
            let coordinate = optionsButton.coordinate(withNormalizedOffset: .zero)
            coordinate.tap()
        }

        let favoritesButton = app.buttons["Favorites"]
        XCTAssertTrue(favoritesButton.waitForExistence(timeout: 3), "Botão 'Favorites' não apareceu no menu")
        favoritesButton.tap()

        let favoritesTitle = app.navigationBars["Favorites"]
        XCTAssertTrue(favoritesTitle.waitForExistence(timeout: 3), "Tela de Favorites não foi aberta")

        let noFavoritesText = app.staticTexts["No favorites yet"]
        XCTAssertTrue(noFavoritesText.waitForExistence(timeout: 2), "Texto de favoritos vazios não apareceu")
    }
}
