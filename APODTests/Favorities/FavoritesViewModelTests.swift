import XCTest
@testable import APOD

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesViewModel!
    var mockRepo: FavoritesRepositoryProtocol!

    override func setUp() {
        super.setUp()
        mockRepo = MockFavoritesRepository()
        viewModel = FavoritesViewModel(repository: mockRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }

    func testAddFavorite() {
        let apod = APOD(
            date: "2025-09-12",
            explanation: "Test explanation",
            hdurl: nil,
            media_type: "image",
            service_version: "v1",
            title: "Test Title",
            url: "https://example.com/image.jpg"
        )

        XCTAssertFalse(viewModel.isFavorited(apod: apod))
        viewModel.addFavorite(apod: apod)
        XCTAssertTrue(viewModel.isFavorited(apod: apod))
        XCTAssertEqual(viewModel.favorites.count, 1)
        XCTAssertEqual(viewModel.favorites.first?.title, "Test Title")
    }

    func testRemoveFavorite() {
        let apod = APOD(
            date: "2025-09-12",
            explanation: "Test explanation",
            hdurl: nil,
            media_type: "image",
            service_version: "v1",
            title: "Test Title",
            url: "https://example.com/image.jpg"
        )

        viewModel.addFavorite(apod: apod)
        XCTAssertTrue(viewModel.isFavorited(apod: apod))
        viewModel.removeFavorite(apod)
        XCTAssertFalse(viewModel.isFavorited(apod: apod))
        XCTAssertEqual(viewModel.favorites.count, 0)
    }

    func testFetchFavorites() {
        let apod1 = APOD(
            date: "2025-09-12",
            explanation: "Test 1",
            hdurl: nil,
            media_type: "image",
            service_version: "v1",
            title: "Title 1",
            url: "https://example.com/1.jpg"
        )
        let apod2 = APOD(
            date: "2025-09-13",
            explanation: "Test 2",
            hdurl: nil,
            media_type: "image",
            service_version: "v1",
            title: "Title 2",
            url: "https://example.com/2.jpg"
        )

        mockRepo.addFavorite(apod1)
        mockRepo.addFavorite(apod2)

        viewModel.fetchFavorites()
        
        XCTAssertEqual(viewModel.favorites.count, 2)
        XCTAssertEqual(viewModel.favorites[0].title, "Title 1")
        XCTAssertEqual(viewModel.favorites[1].title, "Title 2")
    }
}
