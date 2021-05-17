//
//  Environment.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 10/05/2021.
//

import Foundation

struct Environment {
    var date: () -> Date
    var service: Service
    var dispatcher: Dispatcher
    var imageProvider: ImageProvider
    var linkOpener: LinkOpener
    var dateFormater: DateFormatter
}

extension Environment {
    static var live: Environment = {
        let service = LiveService()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        
        return Environment(date: { Date() },
                           service: service,
                           dispatcher: .live,
                           imageProvider: ImageProvider(service: service),
                           linkOpener: .live,
                           dateFormater: dateFormatter)
    }()
}
