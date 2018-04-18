//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewCellImage: UIImageView!{
        didSet{
            collectionViewCellImage.layer.masksToBounds = true
            collectionViewCellImage.layer.cornerRadius = 15.0 //some of good rounded radius value
        }
    }
//    var image = UIImage()
//    
}
