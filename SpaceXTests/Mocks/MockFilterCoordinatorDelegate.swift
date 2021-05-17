//
//  MockFilterCoordinatorDelegate.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 17/05/2021.
//

import Foundation

@testable import SpaceX

final class MockFilterCoordinatorDelegate: FilterCoordinatorDelegate {
    
    var receivedActions: [FilterViewModel.CoordinatorAction] = []
    
    func didReceive(action: FilterViewModel.CoordinatorAction) {
        receivedActions.append(action)
    }
}
