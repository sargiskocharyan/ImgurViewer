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
                        let resized = image
                        ImageCacher.shared.cacheObject().setObject(resized, forKey: url as NSString)
                        self?.imageView.image = resized
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

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension
                    height = dimension / aspectRatio
                } else {                                        // Portrait image
                    height = dimension
                    width = dimension * aspectRatio
                }

        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        return newImage
    }
}
