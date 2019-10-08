//
//  UsersEndpoints.swift
//  ImageViewer
//
//  Created by sargis on 10/7/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import Foundation

struct ImagesUrls {
    static let getHotImages =       "/3/gallery/hot/viral/day/"
    static let getTopComments =     "/3/gallery/"
    
}

public enum ImgurImagesApi {
    case getHotImages(page:Int)
    case getTopComments(imageId: String)
}

extension ImgurImagesApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.imgur.com") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getHotImages(let page):
            return "\(ImagesUrls.getHotImages)\(page)"
        case .getTopComments(let imageId):
            return "\(ImagesUrls.getTopComments)\(imageId)/comments/top"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getHotImages, .getTopComments:
                return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getHotImages(_), .getTopComments(_):
            let headers: HTTPHeaders = ["Authorization":"Client-ID \(Client_ID)"]
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
