//
//  ImageDetailViewController.swift
//  ImgurViewer
//
//  Created by sargis on 10/8/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var InfoLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var viewModel: ImageDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InfoLabel.text = viewModel.model.title
        self.spinner.startAnimating()
        viewModel.completion = { [weak self] (error) in
           guard let self = self else {return}
           DispatchQueue.main.async {
               self.spinner.stopAnimating()
               if error == nil {
                   self.tableView.reloadData()
               } else {
                   self.showErrorAlert(error!)
               }
           }
       }
    }
  
    func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ImageDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentViewCell", for: indexPath) as! CommentViewCell
        cell.configure(viewModel.item(indexPath: indexPath))
        return cell
    }
    
    
}
