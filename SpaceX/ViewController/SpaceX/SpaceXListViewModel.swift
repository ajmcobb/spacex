//
//  SpaceXListViewModel.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 10/05/2021.
//

import UIKit

enum SpaceXListItem: Hashable {
    case info(String)
    case launch(Launch)
}

protocol SpaceXListViewDelegate: AnyObject {
    func didReceive(viewState: SpaceXListViewModel.ViewState)
}

protocol SpaceXListCoordinatorDelegate: AnyObject {
    func didReceive(action: SpaceXListViewModel.CoordinatorAction)
}

struct ListData: Equatable {
    var companyInfo: ListSection?
    var launches: ListSection?
}

struct ListSection: Equatable {
    var title: String
    var items: [SpaceXListItem]
}

final class SpaceXListViewModel {
    
    enum ViewState: Equatable {
        case loading
        case updated(ListData)
        case error(NetworkError)
    }
    
    enum CoordinatorAction: Equatable {
        case filterTapped
        case select(Launch)
    }
    
    let environment: Environment
    
    private(set) var filterModel: FilterModel
    
    weak var delegate: SpaceXListViewDelegate?
    weak var coordinatorDelegate: SpaceXListCoordinatorDelegate?
    
    private var listData = ListData() {
        didSet {
            delegate?.didReceive(viewState: .updated(listData))
        }
    }
    
    private var launches: [Launch] = [] {
        didSet {
            filterModel.set(years: launches.map { $0.year })
        }
    }
    
    init(environment: Environment) {
        self.environment = environment
        self.filterModel = FilterModel()
    }
    
    func fetchData() {
        delegate?.didReceive(viewState: .loading)
        environment.service.info { [weak self] result in
            self?.environment.dispatcher.main {
                switch result {
                case let .success(companyInfo):
                    self?.listData.companyInfo = ListSection(
                        title: "Company".localized,
                        items: [.info(companyInfo.displayString)]
                    )
                case let .failure(error):
                    self?.delegate?.didReceive(viewState: .error(error))
                }
            }
        }
        
        environment.service.launches { [weak self] result in
            self?.environment.dispatcher.main {
                switch result {
                case let .success(launches):
                    self?.launches = launches
                    self?.filterLaunches()
                case let .failure(error):
                    self?.delegate?.didReceive(viewState: .error(error))
                }
            }
        }
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        environment.imageProvider.image(url: urlString) { result in
            switch result {
            case let .success(image):
                completion(image)
            case .failure:
                completion(UIImage(systemName: "xmark.rectangle"))
            }
        }
    }
    
    func showFilter() {
        coordinatorDelegate?.didReceive(action: .filterTapped)
    }
    
    func apply(filterModel: FilterModel) {
        self.filterModel = filterModel
        filterLaunches()
    }
    
    func select(launch: Launch) {
        coordinatorDelegate?.didReceive(action: .select(launch))
    }
}

// MARK: - Private functions
extension SpaceXListViewModel {
    
    private func filterLaunches() {
        let filterModel = self.filterModel
        let filteredLaunches = launches.lazy
            .filter { launch in
                let filterSuccessLaunches = filterModel.success == (launch.launchSuccess ?? true)
                let filterFailedLaunches = filterModel.failed != (launch.launchSuccess ?? true)
                return filterSuccessLaunches || filterFailedLaunches
            }
            .filter { launch in
                guard let year = filterModel.year else { return true }
                let calendar = Calendar.current
                return calendar.component(.year, from: launch.date) == year
            }

        let filtered = Array(filteredLaunches)
        setLaunchListData(launches: filtered
                            .sorted(by: {
                                switch filterModel.sortOrder {
                                case .asc:
                                    return $0.launchDateUNIX < $1.launchDateUNIX
                                case .desc:
                                    return $0.launchDateUNIX > $1.launchDateUNIX
                                }
                            }))
    }
    
    private func setLaunchListData(launches: [Launch]) {
        listData.launches = ListSection(
            title: "Launches".localized,
            items: launches.map { .launch($0) })
    }
}

extension CompanyInfo {
    var displayString: String {
        "Info".localized(companyName,
                         founder,
                         NSNumber(value: yearFounded),
                         NSNumber(value: employeeCount),
                         NSNumber(value: launchSites),
                         NSNumber(value: valuation))
    }
}
