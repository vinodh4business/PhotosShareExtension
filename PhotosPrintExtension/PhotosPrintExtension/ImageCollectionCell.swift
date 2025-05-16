//
//  ImageCollectionCell.swift
//  ImagePicker
//
//  Created by Abhishek on 16/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

struct CellModelData{
    var url:String
}

class ImageCollectionCell: UICollectionViewCell {
	
	@IBOutlet weak var imgView: UIImageView!
		
    var itemWithURL: CellModelData? {
        didSet {
            self.configureWithURL(itemWithURL)
        }
    }

	override func awakeFromNib() {
		super.awakeFromNib()
	}
    
    func configureWithURL(_ item: CellModelData?) {
        if let model = item {
            do {
                let url = URL(fileURLWithPath: model.url)
                let fileURL = URL(string: url.relativePath)
                let rawData = try Data(contentsOf: fileURL!)
                let rawImage = UIImage(data: rawData)
                self.imgView.image = rawImage
            } catch {
                print(error.localizedDescription)
            }
        }
    }
	
}
