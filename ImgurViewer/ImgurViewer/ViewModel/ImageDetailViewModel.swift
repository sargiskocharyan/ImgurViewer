//
//  ImageDetailViewModel.swift
//  ImgurViewer
//
//  Created by sargis on 10/8/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import Foundation


class ImageDetailViewModel {
    let networkManager = ImagesNetworkManager()
    var completion: ((Error?) -> Void)?
    
    var imageTopCommentsDataSource = [Comment]()
    var model: ImageModel!
   
    init(model: ImageModel) {
        self.model = model
        networkManager.getTopComments(imageId: self.model.id) { [weak self] (response, error) in
            guard let self = self else {return}
            guard error == nil else {
                self.completion!(error)
                return
            }
            if let commentsData = response?.data {
                self.createDataForView(commentsData)
                self.completion!(nil)
            }
            
        }
 
    }

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return imageTopCommentsDataSource.count
    }
    
    func item(indexPath: IndexPath) -> Comment {
        return imageTopCommentsDataSource[indexPath.row]
    }
    
    func createDataForView(_ data: [Comment]) {
        var allComments = data
        allComments.sort { $0.points > $1.points }
        self.imageTopCommentsDataSource = allComments
    }
   
}
