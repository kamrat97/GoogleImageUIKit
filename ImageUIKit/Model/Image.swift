//
//  Image.swift
//  ImageUIKit
//
//  Created by Влад on 11.07.2022.
//

import Foundation

enum MainView {
    case initial
    case load
    case success
    case error
    
    typealias Images = Image
    
    struct Image: Decodable {
        let imagesResults: [ImagesResult]
        
        enum CodingKeys: String, CodingKey {
            case imagesResults = "images_results"
        }
    }
    
    struct ImagesResult: Decodable {
        let position: Int
        let thumbnail: String
        let source, title: String
        let link: String
        let original: String?
        let isProduct: Bool
        
        enum CodingKeys: String, CodingKey {
            case position, thumbnail, source, title, link, original
            case isProduct = "is_product"
        }
    }
}

enum SizeButton {
    case Large
    case Medium
    case Icon
    case NoSelection
}
