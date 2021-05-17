//
//  Launch.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 11/05/2021.
//

import Foundation

struct Launch: Codable, Identifiable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case missionName = "mission_name"
        case launchDateUNIX = "launch_date_unix"
        case launchSuccess = "launch_success"
        case rocket
        case links
    }
    
    var flightNumber: Int
    var missionName: String
    var launchSuccess: Bool?
    var launchDateUNIX: TimeInterval
    var rocket: Rocket
    var links: Links
    
    var id: Int { flightNumber }
    
    var date: Date {
        Date(timeIntervalSince1970: launchDateUNIX)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: date)
    }
}

struct Rocket: Codable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case id = "rocket_id"
        case name = "rocket_name"
        case type = "rocket_type"
    }
    
    var id: String
    var name: String
    var type: String
}


struct Links: Codable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case article = "article_link"
        case wikipedia
        case video = "video_link"
        case missionPatchSmall = "mission_patch_small"
    }
    
    var article: String?
    var wikipedia: String?
    var video: String?
    var missionPatchSmall: String?
}
