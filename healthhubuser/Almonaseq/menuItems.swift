//
//  menuItems.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
let menuItems: [Menu] = [
   //Repair Menu:
    
     Menu(id: "1", name: NSLocalizedString("menu.home", comment: ""), icon: "ic_home", vc: "MainTabBarViewController", storyboard: "Main", showLoggedIn: false),
             Menu(id: "2", name: NSLocalizedString("menu.repair_about", comment: ""), icon: "menu-icon-3", vc: "PageVC", storyboard: "App", showLoggedIn: false),
             Menu(id: "3", name: NSLocalizedString("menu.price_list", comment: ""), icon: "menu-icon-4", vc: "ServicePriceListViewController", storyboard: "Service", showLoggedIn: false),
              Menu(id: "4", name: NSLocalizedString("menu.customer_services", comment: ""), icon: "menu-icon-5", vc: "ContactVC", storyboard: "App", showLoggedIn: false),
               Menu(id: "9", name: NSLocalizedString("menu.settings", comment: ""), icon: "menu-icon-7", vc: "SettingsVC", storyboard: "User", showLoggedIn: false),
               Menu(id: "7", name: NSLocalizedString("menu.share.repair", comment: ""), icon: "menu-icon-8", vc: "ShareVC", storyboard: "App", showLoggedIn: false),
                Menu(id: "8", name: NSLocalizedString("menu.logout", comment: ""), icon: "menu-icon-9", vc: "SignoutVC", storyboard: "Auth", showLoggedIn: false),
                //Menu(id: "10", name:NSLocalizedString("menu.notification", comment: ""), icon: "menu-notification", vc: "NotificationsVC", storyboard: "User", showLoggedIn: true)
    //Menu(id: "2", name: NSLocalizedString("menu.materialList", comment: ""), icon: "menu_icon4", vc: "StoresVC", storyboard: "Store", showLoggedIn: false),
    //Menu(id: "3", name: NSLocalizedString("menu.profile", comment: ""), icon: "menu_icon8", vc: "SettingsVC", storyboard: "Auth", showLoggedIn: true),
//    Menu(name: "", englishName: "Notifications", icon: "notification", vc: "NotificationsVC", storyboard: "User", showLoggedIn: true),
    
    //Menu(id: "5", name: NSLocalizedString("menu.myOrder", comment: ""), icon: "basket", vc: "OrdersVC", storyboard: "User", showLoggedIn: true),
//    Menu(name: "", englishName: "My Acceptances", icon: "basket", vc: "ServiceAcceptanceVC", storyboard: "User", showLoggedIn: false),
    
  
      //Menu(id: "12", name: NSLocalizedString("menu.share", comment: ""), icon: "share", vc: "ShareVC", storyboard: "App", showLoggedIn: true),
   // Menu(id: "11", name: NSLocalizedString("menu.contact", comment: ""), icon: "tel", vc: "ContactVC", storyboard: "App", showLoggedIn: false),
    //Menu(id: "9", name: NSLocalizedString("menu.login", comment: ""), icon: "switch", vc: "LoginViewController", storyboard: "Auth", showLoggedIn: false),
   
]
