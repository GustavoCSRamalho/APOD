import XCTest
@testable import APOD

@MainActor
final class APODViewModelTests: XCTestCase {
    var viewModel: APODViewModel!
    var service: MockAPODService!

    override func setUp() {
        super.setUp()
        service = MockAPODService()
        viewModel = APODViewModel(service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        super.tearDown()
    }

    func testLoadTodaySuccess() async {
        await viewModel.loadToday()
        switch viewModel.state {
        case .loaded(let apod):
            XCTAssertEqual(apod.title, "Title 1")
        default:
            XCTFail("Expected loaded state")
        }
    }

    func testLoadTodayFailure() async {
        service.shouldFail = true
        await viewModel.loadToday()
        switch viewModel.state {
        case .failed(let error):
            XCTAssertEqual(error, APIError.network(APIError.apiError(statusCode: 400)).userMessage)
        default:
            XCTFail("Expected failed state")
        }
    }

    func testLoadSpecificDateSuccess() async {
        let date = "2025-09-11"
        await viewModel.load(date: date)
        switch viewModel.state {
        case .loaded(let apod):
            XCTAssertEqual(apod.date, date)
        default:
            XCTFail("Expected loaded state")
        }
    }

    func testLoadSpecificDateFailure() async {
        service.shouldFail = true
        await viewModel.load(date: "2025-09-11")
        switch viewModel.state {
        case .failed(let error):
            XCTAssertEqual(error, APIError.network(APIError.apiError(statusCode: 400)).userMessage)
        default:
            XCTFail("Expected failed state")
        }
    }
}
