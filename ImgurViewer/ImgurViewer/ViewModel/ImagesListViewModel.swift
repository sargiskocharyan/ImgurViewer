//
//  UsersTableViewModel.swift
//  ImageViewer
//
//  Created by sargis on 10/7/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import Foundation


enum ImagesDataError: Error {
    case accessDenied
    case connectionFailed
    case other
}

class ImagesListViewModel {
    let networkManager = ImagesNetworkManager()
    var completion: ((Error?) -> Void)?
    
    var imagesDataSource = [ImageModel]()
    
    var imagesAllData =  [ImageModel]()
    var pageCount = 0
    let portionCount = 5
    
    init() {
        networkManager.getHotImages(page: 1) { [weak self] (response, error) in
            guard let self = self else {return}
            guard error == nil else {
                self.completion!(error)
                return
            }
            if let imageData = response?.data {
                self.createDataForView(imageData)
                //self.imagesDataSource = imageData
                self.completion!(nil)
            }
            
        }
 
    }

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return imagesDataSource.count
    }
    
    func item(indexPath: IndexPath) -> ImageModel {
        return imagesDataSource[indexPath.row]
    }
    
    func createDataForView(_ data: [ImageModel]) {
        let imagesOnlyData = data.filter { ($0.images?[0].type?.contains("image") ?? false) }
        self.imagesAllData = imagesOnlyData
        
        self.imagesDataSource = Array(self.imagesAllData[0..<self.portionCount])
        self.pageCount += 1
    }
    
    func addImagesNewPortion() {        
        let startIndex = pageCount * portionCount
        self.pageCount += 1
        let endIndex = pageCount * portionCount
        let newArrrayToAdd = Array(self.imagesAllData[startIndex..<endIndex])
        self.imagesDataSource += newArrrayToAdd
    }
}
