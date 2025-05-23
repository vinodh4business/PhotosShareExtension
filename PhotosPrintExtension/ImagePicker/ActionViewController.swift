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
    
    var imagesUrls: [String] = []
    
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manageImages()
        
    }
    
    @IBAction func close() {
        self.dismiss(animated: false, completion: { [self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.redirectToHostApp()
                self.extensionContext?.completeRequest(returningItems: [])
            }
        })
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
                                
                                this.closeBtn.sendActions(for: UIControl.Event.touchUpInside)
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


