//
//  MockRouter.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 17/05/2021.
//

import UIKit

@testable import SpaceX

final class MockRouter: Router {
    var viewControllers: [UIViewController] = []
    
    var viewControllerPresented: UIViewController?
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        viewControllerPresented = viewControllerToPresent
    }
    
    var viewControllerPushed: UIViewController?
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllerPushed = viewController
    }
    
    var popViewControllerCalled = false
    func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return nil
    }
}
