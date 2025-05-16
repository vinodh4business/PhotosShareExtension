//
//  ShareViewController.swift
//  PrintExtension
//
//  Created by poondi ganapathy sharvesh on 16/05/25.
//

import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    let sharedKey = "ImageSharePhotoKey"
    var imagesUrls: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manageImages()
        
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
                        this.imagesUrls.append(url.absoluteString)
                        
                        if index == (content.attachments?.count)! - 1 {
                            DispatchQueue.main.async {
                                let userDefaults = UserDefaults(suiteName: "group.com.photos.testpush")
                                userDefaults?.set(this.imagesUrls, forKey: this.sharedKey)
                                userDefaults?.synchronize()
                                
                                this.redirectToHostApp()
                            }
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
