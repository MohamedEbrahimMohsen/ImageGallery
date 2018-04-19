//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = cellView.bounds.height / 2
        }
    }
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.layer.masksToBounds = true
            cellImage.layer.cornerRadius = cellImage.bounds.height / 2
        }
    }
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellNumber: UILabel! //indicator of the number of photos inside the categoryFolder

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
