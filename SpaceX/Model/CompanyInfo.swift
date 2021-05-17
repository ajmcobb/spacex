//
//  CompanyInfo.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 15/05/2021.
//

import Foundation

struct CompanyInfo: Codable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case companyName = "name"
        case founder
        case yearFounded = "founded"
        case employeeCount = "employees"
        case launchSites = "launch_sites"
        case valuation
    }
    
    var companyName: String
    var founder: String
    var yearFounded: Int
    var employeeCount: Int
    var launchSites: Int
    var valuation: Int
}
