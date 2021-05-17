//
//  Dispatcher.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 15/05/2021.
//

import Foundation

struct Dispatcher {
    var background: (@escaping () -> Void) -> Void
    var main: (@escaping () -> Void) -> Void
}

extension Dispatcher {
    static var live: Dispatcher {
        Dispatcher(background: {
            DispatchQueue.global(qos: .background).async(execute: $0)
        }, main: {
            DispatchQueue.main.async(execute: $0)
        })
    }
}
