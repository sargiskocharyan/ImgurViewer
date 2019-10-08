//
//  CommentViewCell.swift
//  ImgurViewer
//
//  Created by sargis on 10/8/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(_ model: Comment) {
        self.commentsLabel.text = model.comment
        self.votesLabel.text = "Rate \(model.points)"
    }
}
