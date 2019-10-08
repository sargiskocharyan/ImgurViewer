//
//  CommentModels.swift
//  ImgurViewer
//
//  Created by sargis on 10/8/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import Foundation

struct CommentsResponse: Codable {
    let data: [Comment]?
    let success: Bool
    let status: Int
}

struct Comment: Codable {
    let id: Double
    let author: String
    let ups: Int
    let downs: Int
    let points: Int
    let comment: String
    let imageId: String
    
    enum CodingKeys: String, CodingKey {
           case id, author, ups, downs, points, comment
           case imageId = "image_id"
    }
}
