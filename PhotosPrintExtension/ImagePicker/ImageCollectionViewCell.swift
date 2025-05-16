//
//  ImageCollectionViewCell.swift
//  ImagePicker
//
//  Created by poondi ganapathy sharvesh on 16/05/25.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(image: UIImage) {
        self.imageView.image = image
    }

}
