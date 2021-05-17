//
//  SpaceXCoordinator.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 10/05/2021.
//

import UIKit

final class SpaceXCoordinator: Coordinator {
    
    let router: Router
    let environment: Environment
    var childCoordinators: [Coordinator] = []
    
    private(set) var spaceXListViewModel: SpaceXListViewModel!
    
    init(router: Router,
         environment: Environment = .live) {
        self.router = router
        self.environment = environment
    }
    
    func start() {
        showSpaceXViewController()
    }
    
    func showSpaceXViewController() {
        let viewModel = SpaceXListViewModel(environment: environment)
        let spaceXListViewController = SpaceXListViewController(viewModel: viewModel)
        viewModel.coordinatorDelegate = self
        router.viewControllers = [spaceXListViewController]
        spaceXListViewModel = viewModel
    }
    
    func showFilterView() {
        let filterViewModel = FilterViewModel(filterModel: spaceXListViewModel.filterModel)
        let filterViewController = FilterViewController(viewModel: filterViewModel)
        
        filterViewController.modalPresentationStyle = .overCurrentContext
        filterViewController.modalTransitionStyle = .crossDissolve
        filterViewModel.coordinatorDelegate = self
        router.present(filterViewController, animated: true, completion: nil)
    }
    
    func showAlertController(with launch: Launch) {
        let alertController = UIAlertController(title: launch.missionName,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        if let article = launch.links.article {
            let action = UIAlertAction(title: "Article".localized,
                                       style: .default) { [weak self] _ in
                self?.environment.linkOpener.open(article)
            }
            alertController.addAction(action)
        }
        if let wiki = launch.links.wikipedia {
            let action = UIAlertAction(title: "Wikipedia".localized,
                                       style: .default) { [weak self] _ in
                self?.environment.linkOpener.open(wiki)
            }
            alertController.addAction(action)
        }
        if let video = launch.links.video {
            let action = UIAlertAction(title: "Video".localized,
                                       style: .default) { [weak self] _ in
                self?.environment.linkOpener.open(video)
            }
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel".localized,
                                                style: .cancel))
        
        router.present(alertController, animated: true, completion: nil)
    }
}

extension SpaceXCoordinator: SpaceXListCoordinatorDelegate {
    
    func didReceive(action: SpaceXListViewModel.CoordinatorAction) {
        switch action {
        case .filterTapped:
            showFilterView()
        case let .select(launch):
            showAlertController(with: launch)
        }
    }
}

extension SpaceXCoordinator: FilterCoordinatorDelegate {
    
    func didReceive(action: FilterViewModel.CoordinatorAction) {
        switch action {
        case let .filterChanged(filterModel):
            spaceXListViewModel.apply(filterModel: filterModel)
        }
    }
}
