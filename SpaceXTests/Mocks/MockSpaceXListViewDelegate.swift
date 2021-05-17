//
//  MockSpaceXListViewDelegate.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 17/05/2021.
//

import Foundation

@testable import SpaceX

final class MockSpaceXListViewDelegate: SpaceXListViewDelegate {
    
    var receivedViewStates: [SpaceXListViewModel.ViewState] = []
    
    var receivedLaunches: [[Launch]] {
        var launchLists: [[Launch]] = []
        receivedViewStates.forEach { viewState in
            switch viewState {
            case let .updated(listData):
                let launches = listData.launches?.items.compactMap { item -> Launch? in
                    switch item {
                    case let .launch(launch):
                        return launch
                    case .info:
                        return nil
                    }
                } ?? []
                launchLists.append(launches)
            default:
                break
            }
        }
        return launchLists
    }
    
    func didReceive(viewState: SpaceXListViewModel.ViewState) {
        receivedViewStates.append(viewState)
    }
}
