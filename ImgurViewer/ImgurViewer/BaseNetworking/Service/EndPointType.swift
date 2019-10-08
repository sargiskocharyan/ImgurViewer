//
//  EndPoint.swift
//  idram
//
//  Created by sargis on 10/16/18.
//  Copyright © 2018 Sargis Kocharyan. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
   
