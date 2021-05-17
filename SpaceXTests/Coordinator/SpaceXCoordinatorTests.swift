//
//  SpaceXCoordinatorTests.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 17/05/2021.
//

import XCTest

@testable import SpaceX

class SpaceXCoordinatorTests: XCTestCase {
    
    var subject: SpaceXCoordinator!
    var mockRouter: MockRouter!
    var environment: Environment!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        environment = .mock()
        mockRouter = MockRouter()
        subject = SpaceXCoordinator(router: mockRouter,
                                    environment: environment)
        
        subject.start()
    }
    
    override func tearDownWithError() throws {
        subject = nil
        mockRouter = nil
        environment = nil
        try super.tearDownWithError()
    }
}

extension SpaceXCoordinatorTests {
    
    func test_SpaceXListViewModelCoordinatorAction_filterTapped_PresentsFilter() {
        
        subject.didReceive(action: .filterTapped)
        
        XCTAssertTrue(mockRouter.viewControllerPresented is FilterViewController)
    }
    
    func test_SpaceXListViewModelCoordinatorAction_selectLaunch_PresentsAlertController() {
        let launch = MockService().launches.first!
        
        subject.didReceive(action: .select(launch))
        
        guard let alertController = mockRouter.viewControllerPresented as? UIAlertController else {
            XCTFail("The presented View Controller is not a UIALertController")
            return
        }
        
        XCTAssertEqual(alertController.actions.compactMap { $0.title }, [
            "Article".localized,
            "Wikipedia".localized,
            "Video".localized,
            "Cancel".localized
        ])
    }
    
    func test_FilterViewModelCoordinatorAction_filterChanged_SetsFilterModelOnSpaceXListViewModel() {
        let filterModel = FilterModel()
        filterModel.year = 123
        
        subject.didReceive(action: .filterChanged(filterModel))
        
        XCTAssertEqual(subject.spaceXListViewModel.filterModel.year, 123)
    }
}
