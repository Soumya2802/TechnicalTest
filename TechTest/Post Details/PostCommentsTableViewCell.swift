//
//  PostCommentsTableViewCell.swift
//  TechTest
//
//  Created by Soumya Ammu on 1/12/22.
//

import UIKit

class PostCommentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    
    @IBOutlet weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
