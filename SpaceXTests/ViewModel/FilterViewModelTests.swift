//
//  FilterViewModelTests.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 17/05/2021.
//

import XCTest

@testable import SpaceX

class FilterViewModelTests: XCTestCase {
    
    var subject: FilterViewModel!
    var filterModel: FilterModel!
    var mockDelegate: MockFilterCoordinatorDelegate!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDelegate = MockFilterCoordinatorDelegate()
        filterModel = FilterModel()
        subject = FilterViewModel(filterModel: filterModel)
        subject.coordinatorDelegate = mockDelegate
    }

    override func tearDownWithError() throws {
        subject = nil
        mockDelegate = nil
        filterModel = nil
        try super.tearDownWithError()
    }
}

extension FilterViewModelTests {
    
    func test_filterModel_SetYears_RemovesDuplicates_Sorts() {
        filterModel.set(years: [1, 1, 1, 2, 5, 4, 7, 3])
        XCTAssertEqual(filterModel.validYears, [nil, 7, 5, 4, 3, 2, 1])
    }
    
    func test_filterModel_rowIndex() {
        filterModel.set(years: [1, 1, 1, 2, 5, 4, 7, 3])
        XCTAssertEqual(filterModel.rowIndex, 0)
        filterModel.year = 5
        XCTAssertEqual(filterModel.rowIndex, 2)
    }
    
    func test_setYear_ChancesFilterModel_InformsDelegate() {
        filterModel.set(years: [1, 2, 3])
        subject.set(year: 3)
        XCTAssertEqual(filterModel.year, 3)
        XCTAssertEqual(mockDelegate.receivedActions, [.filterChanged(filterModel)])
    }
    
    func test_setSuccess_ChangesFilterModel_InformsDelegate() {
        subject.setSuccess(false)
        XCTAssertFalse(filterModel.success)
        XCTAssertTrue(filterModel.failed)
        XCTAssertEqual(mockDelegate.receivedActions, [.filterChanged(filterModel)])
    }
    
    func test_setFailure_ChangesFilterModel_InformsDelegate() {
        subject.setFailure(false)
        XCTAssertTrue(filterModel.success)
        XCTAssertFalse(filterModel.failed)
        XCTAssertEqual(mockDelegate.receivedActions, [.filterChanged(filterModel)])
    }
    
    func test_setSortOrder_ChangesFilterModel_InformsDelegate() {
        subject.set(sortOrder: .desc)
        XCTAssertEqual(filterModel.sortOrder, .desc)
        XCTAssertEqual(mockDelegate.receivedActions, [.filterChanged(filterModel)])
    }
    
    func test_filterYears_Labels() {
        filterModel.set(years: [1, 1, 1, 2, 5, 4, 7, 3])
        XCTAssertEqual(filterModel.validYears.map { $0.label }, [
            "All".localized, "7", "5", "4", "3", "2", "1"
        ])
    }
}
