//
//  SpaceXViewModelTests.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 10/05/2021.
//

import XCTest
@testable import SpaceX

class SpaceXViewModelTests: XCTestCase {
    
    var subject: SpaceXListViewModel!
    var mockService: MockService!
    var environment: Environment!
    var mockViewStateDelegate: MockSpaceXListViewDelegate!
    var mockCoordinatorDelegate: MockSpaceXListCoordinatorDelegate!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockService()
        environment = .mock(service: mockService)
        subject = SpaceXListViewModel(environment: environment)
        
        mockViewStateDelegate = MockSpaceXListViewDelegate()
        mockCoordinatorDelegate = MockSpaceXListCoordinatorDelegate()
        subject.delegate = mockViewStateDelegate
        subject.coordinatorDelegate = mockCoordinatorDelegate
    }
    
    override func tearDownWithError() throws {
        subject = nil
        environment = nil
        mockService = nil
        mockViewStateDelegate = nil
        mockCoordinatorDelegate = nil
        try super.tearDownWithError()
    }
    
    func prepareData() {
        let companyInfo = mockService.info
        let launches = mockService.launches
        mockService.infoResult = .success(companyInfo)
        mockService.launchesResult = .success(launches)
        subject.fetchData()
        mockViewStateDelegate.receivedViewStates = []
    }
}

// MARK: - Tests
extension SpaceXViewModelTests {
    
    func test_fetchData_InfoCallSuccessful_LaunchesCallSuccessFul_SetsData_InformsViewStateDelegate() {
        
        let companyInfo = mockService.info
        let launches = mockService.launches
        
        mockService.infoResult = .success(companyInfo)
        mockService.launchesResult = .success(launches)
        
        subject.fetchData()
        
        let expectedSortedLaunches = mockService
            .launches
            .sorted(by: {
                $0.launchDateUNIX < $1.launchDateUNIX
            })
            .map { SpaceXListItem.launch($0) }
        
        let expectedInfo = [SpaceXListItem.info(
            "Info".localized(
            companyInfo.companyName,
            companyInfo.founder,
            NSNumber(value: companyInfo.yearFounded),
            NSNumber(value: companyInfo.employeeCount),
            NSNumber(value: companyInfo.launchSites),
            NSNumber(value: companyInfo.valuation)))]
        
        let expectedReceivedViewStates: [SpaceXListViewModel.ViewState] = [
            .loading,
            .updated(ListData(companyInfo: ListSection(title: "Company".localized,
                                                       items: expectedInfo),
                              launches: nil)),
            .updated(ListData(companyInfo: ListSection(title: "Company".localized,
                                                       items: expectedInfo),
                              launches: ListSection(title: "Launches".localized,
                                                    items: expectedSortedLaunches))
            )
        ]
        
        XCTAssertEqual(mockViewStateDelegate.receivedViewStates, expectedReceivedViewStates)
        }
    
    func test_fetchData_InfoUnsuccessFul_LaunchesSuccessFul_SetsData_InformsViewStateDelegate() {
        
        let launches = mockService.launches
        
        mockService.infoResult = .failure(.data)
        mockService.launchesResult = .success(launches)
        
        subject.fetchData()
        
        let expectedSortedLaunches = mockService
            .launches
            .sorted(by: {
                $0.launchDateUNIX < $1.launchDateUNIX
            })
            .map { SpaceXListItem.launch($0) }
        
        let expectedReceivedViewStates: [SpaceXListViewModel.ViewState] = [
            .loading,
            .error(.data),
            .updated(ListData(companyInfo: nil,
                              launches: ListSection(title: "Launches".localized,
                                                    items: expectedSortedLaunches)))
        ]
        
        XCTAssertEqual(mockViewStateDelegate.receivedViewStates, expectedReceivedViewStates)
    }
    
    func test_showFilter_SendsCoordinatorDelegateAction() {
        subject.showFilter()
        XCTAssertEqual(mockCoordinatorDelegate.receivedActions, [.filterTapped])
    }
    
    func test_applyFilterModel_NilYear_UnsuccessFulLaunch_AscSortOrder() {
        
        prepareData()
        
        let filterModel = FilterModel()
        filterModel.success = false
        
        subject.apply(filterModel: filterModel)
        
        XCTAssertEqual(mockViewStateDelegate.receivedLaunches.first?.map { $0.id }, [1, 2, 3])
    }
    
    func test_applyFilterModel_Year_DescSortOrder() {
        prepareData()
        
        let filterModel = FilterModel()
        filterModel.year = 2008
        filterModel.sortOrder = .desc
        
        subject.apply(filterModel: filterModel)
        
        XCTAssertEqual(mockViewStateDelegate.receivedLaunches.first?.map { $0.id }, [4, 3])
    }
    
    func test_selectLaunch_InformsCoordinatorDelegate() {
        let launch = mockService.launches.first!
        subject.select(launch: launch)
        XCTAssertEqual(mockCoordinatorDelegate.receivedActions, [.select(launch)])
    }
}
