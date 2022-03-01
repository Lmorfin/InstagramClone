//
//  PostTableViewCell.swift
//  InstagramClone
//
//  Created by Luis Morfin on 2/28/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {


    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
