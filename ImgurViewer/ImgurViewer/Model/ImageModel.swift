//
//  ImageModel.swift
//
//  Created by sargis on 10/7/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import Foundation

struct ImagesResponse: Codable {
    let data: [ImageModel]?
    let success: Bool
    let status: Int
}

struct ImageModel: Codable {
    
    let id: String
    let title: String?
    let commentCount: Int?
    let favoriteCount: Int?
    let imagesCount : Int?
    let tags: [Tag]?
    let images: [ImgurImage]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, images, tags
        case commentCount = "comment_count"
        case favoriteCount = "favorite_count"
        case imagesCount = "images_count"
       
    }
    
    init(id: String, title: String, commentCount: Int, favoriteCount: Int, imagesCount: Int, tags: [Tag], images: [ImgurImage]) {
        self.id = id
        self.title = title
        self.commentCount = commentCount
        self.favoriteCount = favoriteCount
        self.imagesCount = imagesCount
        self.tags = tags
        self.images = images
        
    }
}

struct Tag: Codable {
    let name: String
    let description: String
}

struct ImgurImage: Codable {
    let id: String
    let title: String?
    let description: String?
    let link: String?
    let commentCount: Int?
    let type: String?
    let animated: Bool?
    
  enum CodingKeys: String, CodingKey {
      case id, title, description, link, type, animated
      case commentCount = "comment_count"
  }
}
