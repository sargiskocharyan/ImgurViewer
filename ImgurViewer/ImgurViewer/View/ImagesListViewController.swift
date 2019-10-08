//
//  ImagesListViewController.swift
//  ImageViewer
//
//  Created by sargis on 10/5/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import UIKit

class ImagesListViewController: UIViewController {
    let ImageCellIdentifier = "ImageCellIdentifier"
    
    @IBOutlet var collectionView: UICollectionView!
    let viewModel = ImagesListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        
        viewModel.completion = { [weak self] (error) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if error == nil {
                    self.collectionView.reloadData()
                } else {
                    self.showErrorAlert(error!)
                }
            }
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureCollectionView() {
        self.collectionView.autoresizingMask = [.flexibleHeight]
        let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.estimated(300)
            )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        section.interGroupSpacing = 5

        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }
    
    func showErrorAlert(_ error: Error) {
        // TODO
    }
   
}
extension ImagesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        let viewModel = ImageDetailViewModel(model: self.viewModel.item(indexPath: indexPath))
        detailViewController.viewModel = viewModel
        self.present(detailViewController, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDataSource
extension ImagesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellIdentifier, for: indexPath) as! ImageViewCell
        let model = viewModel.item(indexPath: indexPath)
        cell.configure(model: model)
        return cell
    }

}
//MARK:- Scrollview delegate methods
extension ImagesListViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height - 1 {
            self.viewModel.addImagesNewPortion()
            self.collectionView.reloadData()
        }
    }
}

