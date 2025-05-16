//
//  AppDelegate.swift
//  PhotosPrintExtension
//
//  Created by poondi ganapathy sharvesh on 15/05/25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}


extension AppDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let userDefaults = UserDefaults(suiteName: "group.com.photos.testpush")
        
        if let key = url.absoluteString.components(separatedBy: "=").last,
           let sharedArray = userDefaults?.object(forKey: key) as? [String]{
            
            var imageURLArray: [CellModelData] = []
            
            
            for imageurl in sharedArray {
                print("IMAGE URL \(imageurl)")
                let model = CellModelData(url: imageurl)
                imageURLArray.append(model)
            }
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            homeVC.cellURLItems = imageURLArray
            
            let navVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            
            navVC.viewControllers = [homeVC]
            self.window?.rootViewController = navVC
            self.window?.makeKeyAndVisible()
            
            return true
        }
        
        
        return false
    }
    
}
