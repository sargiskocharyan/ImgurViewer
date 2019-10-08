//
//  ImagesNetworkManager.swift
//  ImageViewer
//
//  Created by sargis on 10/7/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import Foundation

class ImagesNetworkManager: NetworkManager {

    let router = Router<ImgurImagesApi>()
    
    func getHotImages(page: Int, completion: @escaping (ImagesResponse?, Error?) -> ()) {
        router.request(.getHotImages(page:page)) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil, error)
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, nil)
                        return
                    }
                    do {
                        let responseObject = try JSONDecoder().decode(ImagesResponse.self, from: responseData)
                        completion(responseObject, nil)
                    } catch {
                        print(error)
                        completion( nil, error)
                    }
                case .failure(_):
                    completion(nil, ImagesDataError.connectionFailed)
                }
            }
        }
    }
    
    func getTopComments(imageId: String, completion: @escaping (CommentsResponse?, Error?) -> ()) {
        router.request(.getTopComments(imageId:imageId)) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil, error)
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, nil)
                        return
                    }
                    do {
                        let responseObject = try JSONDecoder().decode(CommentsResponse.self, from: responseData)
                        completion(responseObject, nil)
                    } catch {
                        print(error)
                        completion( nil, error)
                    }
                case .failure(_):
                    completion(nil, ImagesDataError.connectionFailed)
                }
            }
        }
    }

}
