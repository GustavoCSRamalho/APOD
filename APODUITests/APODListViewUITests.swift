import XCTest

final class APODListViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testOpenListViewAndSeeItems() {
        let optionsButton = app.buttons["optionsMenu"]
        XCTAssertTrue(optionsButton.waitForExistence(timeout: 5), "Botão de opções não apareceu na Home")

        if optionsButton.isHittable {
            optionsButton.tap()
        } else {
            let coordinate = optionsButton.coordinate(withNormalizedOffset: .zero)
            coordinate.tap()
        }

        let listButton = app.buttons["List"]
        XCTAssertTrue(listButton.waitForExistence(timeout: 3), "Botão 'List' não apareceu no menu")
        listButton.tap()

        let listTitle = app.navigationBars["List"]
        XCTAssertTrue(listTitle.waitForExistence(timeout: 3), "Tela de List não foi aberta")
        
        let progress = app.staticTexts["Loading..."]
        if progress.exists {
            XCTAssertTrue(progress.waitForExistence(timeout: 5), "Loading não apareceu")
        }

        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Nenhum item apareceu na lista")
    }
}
