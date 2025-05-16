//
//  ViewController.swift
//  PhotosPrintExtension
//
//  Created by poondi ganapathy sharvesh on 15/05/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    var cellURLItems: [CellModelData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self

        self.navigationItem.title = "Host App"
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellURLItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.itemWithURL = self.cellURLItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dimension = (self.view.frame.size.width - 40)/3
        return CGSize(width: dimension, height: dimension)
    }

}

