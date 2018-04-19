//
//  OnlyImageTableViewCell.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/19/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class OnlyImageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var cellImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
