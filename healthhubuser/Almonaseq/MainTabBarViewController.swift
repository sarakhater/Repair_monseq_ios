//
//  MainTabBarViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 1/29/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import  Alamofire

class MainTabBarViewController: UITabBarController {
    let notificationCenter = NotificationCenter.default
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSideMenu()
        if(index > 0){
            self.selectedIndex = 2
        }
        if(Utils.getcurrentLanguage() == "ar"){
            self.title = "الرئيسية";
        }else{
            self.title = "Home";
        }
        getShareLinks()
        
        notificationCenter.addObserver(self,selector: #selector(changeTabs(notification:)), name: .changeTabBar,object: nil)
        
    }
    @objc func changeTabs(notification : Notification){
        self.selectedIndex = 1
        
        
    }
    
    func  getShareLinks(){
           Alamofire.request(Constants.Share_URL)
           .responseJSON{ (response) in
                   if response.result.isSuccess {
                       guard  let data = response.result.value as? [String : Any] else {
                           return
                       }
                       print(data);
                       guard let json = data["status"] as? String else {
                           return
                       }
                       print(json)
                       if(json == "true"){
                           //show Payment Method
                           guard let dataLinks = data["data"] as? [String : Any] else{
                               return
                           }
                           ShareAndroidLink = dataLinks["android"] as? String ?? "";
                           ShareIphoneLink = dataLinks["iphone"]  as? String ?? "";
                        self.getAPPVERSION()
                       }else{
                         
                       }
                   }
                   else{
                       print("there was an error")
                   }
           }
           
       }
    func getAPPVERSION(){
        
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        ApiManager.updateApp(version: Int(version) ?? 0) {
                    (res: String?) in
            if(res == "true"){
                
            }else{
                //show alert
                var message = ""
                var alerttitle = ""
                var okBtn = ""
                var closeBtn = ""
                if(L102Language.currentAppleLanguage() == "ar"){
                    alerttitle = "تحديث"
                    message = "يجب تحديث تطبيقك لاحدث اصدار للاستمتاع بالميزات الجديدة"
                    okBtn = "تحديث التطبيق"
                    closeBtn = "إغلاق"
                }
                else{
                    alerttitle = "Upgrade"
                    message = "Your app must be upgraded to the latest version to enjoy with new features"
                    okBtn = "Update App"
                    closeBtn = "Close"
                    
                }
                let alert = UIAlertController(title: alerttitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: okBtn, style: .default, handler: { action in
                      switch action.style{
                      case .default:
                            print("default")
                        if let url = URL(string: ShareIphoneLink) {
                            UIApplication.shared.open(url)
                        }
                      case .cancel:
                            print("cancel")

                      case .destructive:
                            print("destructive")


                }}))
                alert.addAction(UIAlertAction(title: closeBtn, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
       localizeTabBar()
    }
    
  
    func localizeTabBar() {
        if(L102Language.getRegisterType() == 1){
            //school
            self.viewControllers?.remove(at: 1)
            tabBar.items![0].title =  NSLocalizedString("tab.services", comment: "")
            tabBar.items![1].title =  NSLocalizedString("tab.orders", comment: "")
            tabBar.items![2].title =  NSLocalizedString("tab.notification", comment: "")
            tabBar.items![3].title =  NSLocalizedString("tab.about", comment: "")
            tabBar.items![4].title =  NSLocalizedString("tab.contactus", comment: "")
            
            
        }else if (L102Language.getRegisterType() == 2){
            //family
            self.viewControllers?.remove(at: 0)
            //self.viewControllers?.remove(at: 1)
            tabBar.items![0].title =  NSLocalizedString("tab.services", comment: "")
            tabBar.items![1].title =  NSLocalizedString("tab.orders", comment: "")
            tabBar.items![2].title =  NSLocalizedString("tab.notification", comment: "")
            tabBar.items![3].title =  NSLocalizedString("tab.about", comment: "")
            tabBar.items![4].title =  NSLocalizedString("tab.contactus", comment: "")
            
            
        }
        
        
    }
}
