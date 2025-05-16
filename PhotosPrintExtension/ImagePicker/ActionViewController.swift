//
//  ActionViewController.swift
//  ImagePicker
//
//  Created by poondi ganapathy sharvesh on 15/05/25.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import MobileCoreServices

class ActionViewController: UIViewController {
    
    let sharedKey = "ImageSharePhotoKey"

    var selectedImages: [UIImage] = []
    var imagesUrls: [String] = []

    @IBOutlet weak var imgCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
//        self.imgCollectionView.delegate = self
//        self.imgCollectionView.dataSource = self

        
//        self.navigationItem.title = "Picked Images Via Extension"

        self.manageImages()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.redirectToHostApp()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    func redirectToHostApp() {
        let url = URL(string: "ImagePicker://dataUrl=\(sharedKey)")
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url!, options: [:], completionHandler: nil)
            }
            responder = responder?.next
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }


    func manageImages() {
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = UTType.image.identifier
        
        for (index, attachment) in (content.attachments!).enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { [weak self] data, error in
                    
                    if error == nil, let url = data as? URL, let this = self {
                        do {
                            
                            this.imagesUrls.append(url.absoluteString)
                            
                            // GETTING RAW DATA
                            let rawData = try Data(contentsOf: url)
                            let rawImage = UIImage(data: rawData)
                            
                            // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                            // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                            let image = UIImage.resizeImage(image: rawImage!, width: 100, height: 100)
                            let imgData = image.pngData()
                            
                            this.selectedImages.append(image)
                            
                            if index == (content.attachments?.count)! - 1 {
                                DispatchQueue.main.async {
                                    //this.imgCollectionView.reloadData()
                                    let userDefaults = UserDefaults(suiteName: "group.com.photos.testpush")
                                    userDefaults?.set(this.imagesUrls, forKey: this.sharedKey)
                                    userDefaults?.synchronize()
                                    
                                    this.redirectToHostApp()
                                }
                            }
                        }
                        catch let exp {
                            print("GETTING EXCEPTION \(exp.localizedDescription)")
                        }
                        
                    } else {
                        print("GETTING ERROR")
                        let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}


extension ActionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = UIScreen.main.bounds.size.width
        let width = (viewWidth - 40) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.configure(image: selectedImages[indexPath.row])
        return cell
    }

}


extension UIImage {
    class func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
