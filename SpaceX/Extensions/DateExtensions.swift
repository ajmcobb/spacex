//
//  DateExtensions.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import Foundation

extension Date {
    
    var isFuture: Bool {
        self > Date()
    }
}

extension TimeInterval {
    func daysDifference(to other: TimeInterval) -> String {
        let difference = Int((other - self) / 86400)
        switch difference {
        case 0:
            return "Days".localized("0")
        case -1:
            return "Day".localized("-1")
        case 1:
            return "Day".localized("1")
        case ...(-2):
        return "Days".localized("\(difference)")
        case 2...:
            return "Days".localized("-\(difference)")
        default:
            return ""
        }
    }
}
