import XCTest

final class APODDetailViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testFullNavigationFlow() {
        let homeTitle = app.staticTexts["NASA APOD"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 2), "Titulo 'NASA APOD' não encontrado")

        let optionsButton = app.buttons["optionsMenu"]
        XCTAssertTrue(optionsButton.waitForExistence(timeout: 2), "Botão 'optionsMenu' não apareceu")

        if optionsButton.isHittable {
            optionsButton.tap()
        } else {
            optionsButton.coordinate(withNormalizedOffset: .zero).tap()
        }

        let listButton = app.buttons["List"]
        XCTAssertTrue(listButton.waitForExistence(timeout: 2), "Lista não encontrada")
        listButton.tap()

        let firstAPODCell = app.cells.firstMatch
        XCTAssertTrue(firstAPODCell.waitForExistence(timeout: 2), "Célula não encontrada")
        firstAPODCell.tap()

        let detailTitle = app.staticTexts["detailTitle"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 2), "Botão 'detailTitle' não apareceu")
        XCTAssertTrue(detailTitle.exists)

        let detailDate = app.staticTexts["detailDate"]
        XCTAssertTrue(detailDate.waitForExistence(timeout: 2), "Botão 'detailDate' não apareceu")
        XCTAssertTrue(detailDate.exists)

        let favoritesButton = app.buttons["detailFavorites"]
        XCTAssertTrue(favoritesButton.waitForExistence(timeout: 3), "Botão 'Favorites' não apareceu")
        favoritesButton.tap()

        let unfavoriteButton = app.buttons["detailFavorites"]
        XCTAssertTrue(unfavoriteButton.waitForExistence(timeout: 2), "Botão 'Favorites' não apareceu")
        unfavoriteButton.tap()
    }
}
