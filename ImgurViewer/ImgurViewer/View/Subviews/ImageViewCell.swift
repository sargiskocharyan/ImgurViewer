//
//  ImageViewCell.swift
//  ImgurViewer
//
//  Created by sargis on 10/7/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.imageView.contentMode = .scaleAspectFit
        self.layoutIfNeeded()
    }
    var isHeightCalculated: Bool = false

    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
    
    func configure(model: ImageModel) {
        
        let networkManager = ImagesNetworkManager()
        if let url = model.images?.first?.link {
            if let cachedImage = ImageCacher.shared.cacheObject().object(forKey: url as NSString) {
                self.imageView.contentMode = .scaleAspectFit
                self.imageView.image = cachedImage
            }
            self.spinner.startAnimating()
            networkManager.downloadImage(imageUrl: url) { [weak self] (data, error) in
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    if error != nil {
                        self?.imageView.image = UIImage(named: "placeholder")
                        
                    } else if let data = data, let image = UIImage(data: data) {
                        ImageCacher.shared.cacheObject().setObject(image, forKey: url as NSString)
                        self?.imageView.image = image
                        self?.layoutIfNeeded()
                    } else {
                         self?.imageView.image = UIImage(named: "placeholder")
                    }
                }
            }
        }
        self.titleLabel.text = model.title
    }
}
