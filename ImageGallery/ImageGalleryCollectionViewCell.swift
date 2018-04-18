//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    var isMarked: Bool = false{
        didSet{
            isMarked == true ? markImageLabel.setTitle("✔️", for: .normal) : markImageLabel.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var markImageLabel: UIButton!{
        didSet{
            markImageLabel.layer.masksToBounds = true
            markImageLabel.layer.cornerRadius = markImageLabel.bounds.width / 2
        }
    }
    @IBOutlet weak var collectionViewCellImage: UIImageView!
//    {
//        didSet{
//            collectionViewCellImage.layer.masksToBounds = true
//            collectionViewCellImage.layer.cornerRadius = 15.0 //some of good rounded radius value
//        }
//    }
    @IBAction func markImage(_ sender: UIButton) {
        isMarked = !isMarked
        //isMarked == true ? sender.setTitle("✔️", for: .normal) : sender.setTitle("", for: .normal)
    }
 
}
