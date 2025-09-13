import XCTest
@testable import APOD

@MainActor
final class APODListViewModelTests: XCTestCase {
    var viewModel: APODListViewModel!
    var service: MockAPODService!
    
    override func setUp() {
        super.setUp()
        service = MockAPODService()
        viewModel = APODListViewModel(service: service, lastDays: 2)
    }
    
    override func tearDown() {
        viewModel = nil
        service = nil
        super.tearDown()
    }
    
    func testLoadLastDaysSuccess() async {
        await viewModel.loadLastDays()
        
        switch viewModel.state {
        case .loaded(let apods):
            XCTAssertEqual(apods.count, 2)
            XCTAssertEqual(apods.first?.title, "Title 1") // sorted descending
            XCTAssertEqual(apods.last?.title, "Title 2")
        default:
            XCTFail("Expected loaded state")
        }
    }
    
    func testLoadLastDaysFailure() async {
        service.shouldFail = true
        await viewModel.loadLastDays()
        
        switch viewModel.state {
        case .failed(let error):
            XCTAssertEqual(error, "Mock failure")
        default:
            XCTFail("Expected failed state")
        }
    }
}
