//
//  MockService.swift
//  SpaceXTests
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import Foundation

@testable import SpaceX

final class TestBundleLoader {}

extension Bundle {
    static var test: Bundle {
        Bundle(for: TestBundleLoader.self)
    }
}

final class MockService: Service {
    
    var launches: [Launch] = {
        try! JSONDecoder().readAndDecode(fromJSON: "Launches", bundle: .test)
    }()
    
    var info: CompanyInfo = {
        try! JSONDecoder().readAndDecode(fromJSON: "CompanyInfo", bundle: .test)
    }()
    
    var launchesResult: Result<[Launch], NetworkError>?
    func launches(completion: @escaping (Result<[Launch], NetworkError>) -> Void) {
        if let result = launchesResult {
            completion(result)
        }
    }
    
    var infoResult: Result<CompanyInfo, NetworkError>?
    func info(completion: @escaping (Result<CompanyInfo, NetworkError>) -> Void) {
        if let result = infoResult {
            completion(result)
        }
    }
    
    func fetchImage(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
    }
}
