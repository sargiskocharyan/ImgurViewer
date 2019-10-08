//
//  ImageDetailViewController.swift
//  ImgurViewer
//
//  Created by sargis on 10/8/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet var InfoLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var viewModel: ImageDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InfoLabel.text = viewModel.model.title
        viewModel.completion = { [weak self] (error) in
           guard let self = self else {return}
           DispatchQueue.main.async {
               if error == nil {
                   self.tableView.reloadData()
               } else {
                   //self.showErrorAlert(error!)
               }
           }
       }
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
