//
//  NetworkLayer.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 15/05/2021.
//

import UIKit

enum NetworkError: Error, Equatable {
    case offline
    case parsing(Error)
    case urlFailure
    case statusCode(Int)
    case session(Error)
    case data
    case unknown
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.offline, .offline):
            return true
        case let (.parsing(left), .parsing(right)) where left.localizedDescription == right.localizedDescription:
            return true
        case (.urlFailure, .urlFailure):
            return true
        case let (.statusCode(left), .statusCode(right)) where left == right:
            return true
        case let (.session(left), .session(right)) where left.localizedDescription == right.localizedDescription:
            return true
        case (.data, .data):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}

enum RequestMethod {
    case post, get
}

enum Version: String {
    case v3, v4
}

enum RequestScheme: String {
    case http
    case https
}

protocol Target {
    var scheme: RequestScheme { get }
    var baseURL: String { get }
    var method: RequestMethod { get }
    var path: String { get }
    var version: Version { get }
    var query: [String: String] { get }
    var keyPath: String { get }
}

extension Target {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = baseURL
        components.path = path
        var queries: [URLQueryItem] = []
        query.forEach { queries.append(URLQueryItem(name: $0, value: $1)) }
        if queries.count > 0 {
            components.queryItems = queries
        }
        return components.url
    }
}

enum RequestTarget: Target {

    case allLaunches
    case info

    var scheme: RequestScheme {
        switch self {
        case .allLaunches, .info:
            return .https
        }
    }

    var baseURL: String {
        switch self {
        case .allLaunches, .info:
            return "api.spacexdata.com"
        }
    }

    var method: RequestMethod {
        switch self {
        case .allLaunches, .info:
            return .get
        }
    }

    var path: String {
        switch self {
        case .allLaunches:
            return "/\(version.rawValue)/launches"
        case .info:
            return "/\(version.rawValue)/info"
        }
    }
    
    var version: Version {
        .v3
    }

    var query: [String : String] {
        switch self {
        case .allLaunches, .info:
            return [:]
        }
    }
    
    var keyPath: String {
        ""
    }
}

final class NetworkLayer {

    let session: URLSession
    private var dataTask: URLSessionDataTask?

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request<T>(type: T.Type,
                    target: RequestTarget,
                    completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        if let url = target.url {
            switch target.method {
                case .get:
                    getRequest(url: url, jsonKeyPath: target.keyPath, completion: completion)
                case .post:
                    break
            }
        } else {
            completion(.failure(.urlFailure))
        }
    }

    func requestImage(url: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: url) else { completion(.failure(.urlFailure)); return }
        getRequest(url: url) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.data))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension NetworkLayer {

    func getRequest(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.dataTask = nil }
            if let error = error {
                if let response = response as? HTTPURLResponse {
                    completion(.failure(.statusCode(response.statusCode)))
                    return
                } else {
                    completion(.failure(.session(error)))
                }
            }
            if let data = data {
                completion(.success(data))
            }
        }
        dataTask?.resume()
    }

    func getRequest<T>(url: URL, jsonKeyPath: String = "", completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        getRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded: T = try data.jsonDecode(keyPath: jsonKeyPath)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.parsing(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum CodingError: Error {
    case decoding
    case encoding
}

struct CodableUIImage: Codable {

    let image: UIImage

    enum CodinKeys: String, CodingKey {
        case image
    }

    init(image: UIImage) {
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodinKeys.self)
        let imageData = try container.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: imageData) else {
            throw CodingError.decoding
        }
        self.init(image: image)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodinKeys.self)
        guard let data = image.pngData() else {
            throw CodingError.encoding
        }
        try container.encode(data, forKey: .image)
    }
}
