//
//  Service.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 15/05/2021.
//

import Foundation

protocol Service {
    func launches(completion: @escaping (Result<[Launch], NetworkError>) -> Void)
    func info(completion: @escaping (Result<CompanyInfo, NetworkError>) -> Void)
    
    func fetchImage(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class LiveService: Service {
    
    let networkLayer = NetworkLayer()
    
    func launches(completion: @escaping (Result<[Launch], NetworkError>) -> Void) {
        networkLayer.request(type: [Launch].self,
                             target: .allLaunches,
                             completion: completion)
    }
    
    func info(completion: @escaping (Result<CompanyInfo, NetworkError>) -> Void) {
        networkLayer.request(type: CompanyInfo.self,
                             target: .info,
                             completion: completion)
    }
    
    func fetchImage(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlFailure))
            return
        }
        networkLayer.getRequest(url: url,  completion: completion)
    }
}
