//
//  EnvironmentExtensions.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import Foundation

@testable import SpaceX

extension Environment {
    static func mock(service: Service = MockService()) -> Environment {
        return Environment(date: { fatalError("Implement in test") },
                           service: service,
                           dispatcher: .mock,
                           imageProvider: ImageProvider(service: service,
                                                        dispatcher: .mock,
                                                        imagePersister: .mock),
                           linkOpener: .mock,
                           dateFormater: DateFormatter())
    }
}

extension LinkOpener {
    static var mock: LinkOpener {
        LinkOpener(open: { _ in fatalError("Implement in test") })
    }
}

extension ImagePersister {
    static var mock: ImagePersister {
        ImagePersister(save: { _, _ in fatalError("Implement in test") },
                       loadImage: { _ in fatalError("Implement in test") })
    }
}

extension Dispatcher {
    static var mock: Dispatcher {
        Dispatcher(background: { $0() },
                   main: { $0() })
    }
}
