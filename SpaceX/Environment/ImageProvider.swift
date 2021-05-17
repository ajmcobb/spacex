//
//  ImageProvider.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import UIKit

final class ImageProvider {
    
    let service: Service
    let dispatcher: Dispatcher
    let imagePersister: ImagePersister
    
    private(set) var imageCache = NSCache<NSNumber, UIImage>()
    
    init(service: Service,
         dispatcher: Dispatcher = .live,
         imagePersister: ImagePersister = .live) {
        self.service = service
        self.dispatcher = dispatcher
        self.imagePersister = imagePersister
    }
    
    // 1. try the cache
    // 2. try the disk
    // 3. try the network
    func image(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let hash = url.hashValue
        let key = NSNumber(value: hash)
        let fileName = String(hash)
        
        if let cachedImage = imageCache.object(forKey: key) {
            completion(.success(cachedImage))
        } else if let savedImage = imagePersister.loadImage(fileName) {
            completion(.success(savedImage))
            imageCache.setObject(savedImage, forKey: key)
        } else {
            service.fetchImage(from: url, completion: { [weak self] result in
                
                switch result {
                case let .success(imageData):
                    if let image = UIImage(data: imageData) {
                        self?.dispatcher.main {
                            completion(.success(image))
                        }
                        self?.imagePersister.save(image, fileName)
                        self?.imageCache.setObject(image, forKey: key)
                    } else {
                        self?.dispatcher.main {
                            completion(.failure(NetworkError.data))
                        }
                    }
                case let .failure(error):
                    self?.dispatcher.main {
                        completion(.failure(error))
                    }
                }
            })
        }
    }
}

struct ImagePersister {
    var save: (UIImage, String) -> Void
    var loadImage: (String) -> UIImage?
}

extension ImagePersister {
    static var live: ImagePersister {
        ImagePersister(save: URL.saveImage,
                       loadImage: URL.loadImage)
    }
}
