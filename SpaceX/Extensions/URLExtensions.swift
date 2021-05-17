//
//  URLExtensions.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import UIKit

extension URL {
    
    static var documentsDirectory: URL {
        FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func loadImage(name: String) -> UIImage? {
        let imagePath = documentsDirectory.appendingPathComponent(name)
        do {
            let data = try Data(contentsOf: imagePath)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    static func saveImage(image: UIImage, name: String) {
        let imagePath = documentsDirectory.appendingPathComponent(name)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: imagePath)
        }
    }
}
