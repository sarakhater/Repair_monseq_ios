//
//  utils.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import Toaster
import AVFoundation
import CoreLocation
import GradientView

class Utils {
    static var gradientLayer: CAGradientLayer!
    static func initializeGradient() -> CALayer {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradientColor1, gradientColor1]
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        //        view.layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
    static func setImageBackGround() -> CALayer {
        gradientLayer = CAGradientLayer()
        gradientLayer.backgroundFilters?.append( UIImage(named: "Header_Bg"))
        return gradientLayer
    }
    static func addGradientLayer(view: UIView) {
        let gradientLayer = initializeGradient()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    static func removeGradientLayer(view: UIView) {
        if ((view.layer.sublayers?.count ?? 0) > 0) {
            view.layer.sublayers?.forEach { layer in
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    
    static func showToast(message: String) {
        let toast = Toast(text: message, duration: Delay.long)
        toast.show()
    }
    
    static func captureThumbnail(withVideoURL videoURL:URL,secs:Int = 10,preferredTimeScale scale:Int = 1,completionHandler:((UIImage?) ->Void)?) -> Void
    {
        //let seconds : Int64 = 10
        // let preferredTimeScale : Int32 = 1
        
        DispatchQueue.global().async {
            
            do
            {
                let asset = AVURLAsset(url: videoURL)
                
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at:CMTimeMake(Int64(secs), Int32(scale)),actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                completionHandler?(thumbnail)
            }
            catch let error as NSError
            {
                print("Error generating thumbnail: \(error)")
                completionHandler?(nil)
            }
        }
    }
    
    static func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    static func getcurrentLanguage() -> String {
        //        return NSLocale.current.languageCode ?? "en"
        return L102Language.currentAppleLanguage()
    }
    
    static func share(_ sender: UIView, context: UIViewController) -> UIActivityViewController {
        // set up activity view controller
        
        // let appDescriptionforIphone = NSLocalizedString("app.share.ios", comment: "");
        // let appDescriptionforAndroid = NSLocalizedString("app.share.android", comment: "");
        print(ShareIphoneLink)
        var textTitle = ""
        if(L102Language.currentAppleLanguage() == "ar"){
            textTitle = "شارك تطبيق صلح مع اصدقائك"
        }else{
            textTitle = "Share Repair App with your friends"
        }
        let textToShare: [Any] = [textTitle ,  ShareIphoneLink , ShareAndroidLink];
        //let textToShare: [Any] = [ appDescriptionforIphone , Constants.APP_URL  , appDescriptionforAndroid ,  Constants.APP_Android_URL];
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.bounds
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
        // present the view controller
        context.present(activityViewController, animated: true, completion: nil)
        return activityViewController
    }
    
    static func showIntroAlert() -> UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("alert.title", comment: ""), message: NSLocalizedString("alert.message", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.cancel", comment: ""), style: .cancel, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.downloadApp", comment: ""), style: .default, handler: { (action) in
            UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/%D9%81%D9%86%D9%8A-%D8%A7%D9%84%D8%A7%D8%AD%D8%B3%D8%A7%D8%A1-%D9%85%D9%82%D8%AF%D9%85-%D8%AE%D8%AF%D9%85%D8%A9/id1380136758?ls=1&mt=8")! as URL)
        }))
        return alert
    }
    static func showAlertWithMsg(message : String)-> UIAlertController {
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "تم", style: UIAlertActionStyle.default, handler: nil))
        return alert;
        // self.presentViewController(alert, animated: true, completion: nil)
    }
    static func showAlertWithoutok(message : String)-> UIAlertController {
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.alert)
        return alert;
        // self.presentViewController(alert, animated: true, completion: nil)
    }
    static func buildMenuItems() -> [Menu] {
        
        let menuItems: [Menu] = [
            
            //Repair Menu:
            
            Menu(id: "1", name: NSLocalizedString("menu.home", comment: ""), icon: "ic_home", vc: "MainTabBarViewController", storyboard: "Main", showLoggedIn: false),
            Menu(id: "2", name: NSLocalizedString("menu.repair_about", comment: ""), icon: "menu-icon-3", vc: "PageVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "3", name: NSLocalizedString("menu.price_list", comment: ""), icon: "menu-icon-4",vc: "ServicePriceListViewController", storyboard: "Service", showLoggedIn: false),
            Menu(id: "4", name: NSLocalizedString("menu.customer_services", comment: ""), icon: "menu-icon-5", vc: "ContactVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "9", name: NSLocalizedString("menu.settings", comment: ""), icon: "menu-icon-7", vc: "SettingsVC", storyboard: "User", showLoggedIn: false),
            Menu(id: "7", name: NSLocalizedString("menu.share.repair", comment: ""), icon: "menu-icon-8", vc: "ShareVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "8", name: NSLocalizedString("menu.logout", comment: ""), icon: "menu-icon-9", vc: "SignoutVC", storyboard: "Auth", showLoggedIn: false)
        ]
        return menuItems
    }
    
    
    static func buildSchoolMenuItems() -> [Menu] {
        
        let menuItems: [Menu] = [
            
            //Repair Menu:
            
            Menu(id: "1", name: NSLocalizedString("menu.home", comment: ""), icon: "ic_home", vc: "MainTabBarViewController", storyboard: "Main", showLoggedIn: false),
            Menu(id: "2", name: NSLocalizedString("menu.repair_about", comment: ""), icon: "menu-icon-3", vc: "PageVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "4", name: NSLocalizedString("menu.customer_services", comment: ""), icon: "menu-icon-5", vc: "ContactVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "9", name: NSLocalizedString("menu.settings", comment: ""), icon: "menu-icon-7", vc: "SettingsVC", storyboard: "User", showLoggedIn: false),
            Menu(id: "7", name: NSLocalizedString("menu.share.repair", comment: ""), icon: "menu-icon-8", vc: "ShareVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "8", name: NSLocalizedString("menu.logout", comment: ""), icon: "menu-icon-9", vc: "SignoutVC", storyboard: "Auth", showLoggedIn: false),
          
        ]
        return menuItems
    }
    
    static func buildSchoolFirstMenuItems() -> [Menu] {
        print(NSLocalizedString("menu.home", comment: ""));
        let menuItems: [Menu] = [
            //Repair Menu:
            Menu(id: "1", name: NSLocalizedString("menu.home", comment: ""), icon: "ic_home", vc: "MainTabBarViewController", storyboard: "Main", showLoggedIn: false),
            Menu(id: "2", name: NSLocalizedString("menu.repair_about", comment: ""), icon: "menu-icon-3", vc: "PageVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "4", name: NSLocalizedString("menu.customer_services", comment: ""), icon: "menu-icon-5", vc: "ContactVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "9", name: NSLocalizedString("menu.settings", comment: ""), icon: "menu-icon-7", vc: "SettingsVC", storyboard: "User", showLoggedIn: false),
            Menu(id: "7", name: NSLocalizedString("menu.share.repair", comment: ""), icon: "menu-icon-8", vc: "ShareVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "8", name: NSLocalizedString("menu.logout", comment: ""), icon: "menu-icon-9", vc: "SignoutVC", storyboard: "Auth", showLoggedIn: false),
         
            
        ]
        return menuItems
    }
    static func buildFirstMenuItems() -> [Menu] {
        print(NSLocalizedString("menu.home", comment: ""));
        let menuItems: [Menu] = [
            //Repair Menu:
            Menu(id: "1", name: NSLocalizedString("menu.home", comment: ""), icon: "ic_home", vc: "MainTabBarViewController", storyboard: "Main", showLoggedIn: false),
            Menu(id: "2", name: NSLocalizedString("menu.repair_about", comment: ""), icon: "menu-icon-3", vc: "PageVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "3", name: NSLocalizedString("menu.price_list", comment: ""), icon: "menu-icon-4", vc: "ServicePriceListViewController", storyboard: "Service", showLoggedIn: false),
            Menu(id: "4", name: NSLocalizedString("menu.customer_services", comment: ""), icon: "menu-icon-5", vc: "ContactVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "9", name: NSLocalizedString("menu.settings", comment: ""), icon: "menu-icon-7", vc: "SettingsVC", storyboard: "User", showLoggedIn: false),
            Menu(id: "7", name: NSLocalizedString("menu.share.repair", comment: ""), icon: "menu-icon-8", vc: "ShareVC", storyboard: "App", showLoggedIn: false),
            Menu(id: "8", name: NSLocalizedString("menu.logout", comment: ""), icon: "menu-icon-9", vc: "SignoutVC", storyboard: "Auth", showLoggedIn: false),
          
        ]
        return menuItems
    }
    
    static func setGradientViewPod(gradientView : GradientView , view : UIView){
        // Initialize a gradient view
        //let gradientView = GradientView(frame: CGRectMake(x: view.bounds.x, y: 20, width: 280, height: 280))
        
        let colorTop =  UIColor(red: 80.0/255.0, green: 152.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 43.0/255.0, green: 90.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        
        // Set the gradient colors
        gradientView.colors = [colorTop, colorBottom]
        
        // Optionally set some locations
        gradientView.locations = [0.0, 1.0]
        
        // Optionally change the direction. The default is vertical.
        gradientView.direction = .vertical
        
        // Add some borders too if you want
        gradientView.topBorderColor = colorTop
        gradientView.bottomBorderColor = colorBottom
        gradientView.layer.cornerRadius = 25;
        
        // Add it as a subview in all of its awesome
        view.addSubview(gradientView)
    }
    
    
}
