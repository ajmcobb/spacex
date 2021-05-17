//
//  MockSpaceXListCoordinatorDelegate.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 17/05/2021.
//

import Foundation

@testable import SpaceX

final class MockSpaceXListCoordinatorDelegate: SpaceXListCoordinatorDelegate {
    
    var receivedActions: [SpaceXListViewModel.CoordinatorAction] = []
    
    func didReceive(action: SpaceXListViewModel.CoordinatorAction) {
        receivedActions.append(action)
    }
}
