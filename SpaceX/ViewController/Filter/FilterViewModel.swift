//
//  FilterViewModel.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import Foundation

protocol FilterCoordinatorDelegate: AnyObject {
    func didReceive(action: FilterViewModel.CoordinatorAction)
}

// reference type so its not copied
final class FilterModel: Equatable {
    
    enum SortOrder: Int {
        case asc, desc
    }
    
    var year: Int?
    var success: Bool = true
    var failed: Bool = true
    var sortOrder: SortOrder = .asc
    
    func set(years: [Int]) {
        let uniqueYears = Set(years)
        validYears = [nil] + Array(uniqueYears).sorted(by: >)
    }
    
    private(set) var validYears: [Int?] = [nil]
    
    var rowIndex: Int {
        validYears.lastIndex(of: year) ?? 0
    }
    
    public static func == (lhs: FilterModel, rhs: FilterModel) -> Bool {
        lhs.year == rhs.year
            && lhs.success == rhs.success
            && lhs.failed == rhs.failed
            && lhs.sortOrder == rhs.sortOrder
    }
    
}

final class FilterViewModel {
    
    enum CoordinatorAction: Equatable {
        case filterChanged(FilterModel)
    }
    
    weak var coordinatorDelegate: FilterCoordinatorDelegate?
    
    private(set) var filterModel: FilterModel
    
    init(filterModel: FilterModel) {
        self.filterModel = filterModel
    }
    
    func set(year: Int?) {
        filterModel.year = year
        filterChanged()
    }
    
    func setSuccess(_ value: Bool) {
        filterModel.success = value
        filterChanged()
    }
    
    func setFailure(_ value: Bool) {
        filterModel.failed = value
        filterChanged()
    }
    
    func set(sortOrder: FilterModel.SortOrder) {
        filterModel.sortOrder = sortOrder
        filterChanged()
    }
    
    private func filterChanged() {
        coordinatorDelegate?.didReceive(action: .filterChanged(filterModel))
    }
}

extension Optional where Wrapped == Int {
    var label: String {
        switch self {
        case let .some(number):
            return String(number)
        case .none:
            return "All".localized
        }
    }
}
