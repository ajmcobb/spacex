//
//  Coordinator.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 10/05/2021.
//

import UIKit

protocol Router: AnyObject {
    var viewControllers: [UIViewController] { get set }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool) -> UIViewController?
}

extension UINavigationController: Router {}

protocol Coordinator: AnyObject {
    var router: Router { get }
    var environment: Environment { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func start(childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
}
