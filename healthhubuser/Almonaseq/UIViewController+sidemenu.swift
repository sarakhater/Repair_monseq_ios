//
//  UIViewController+sidemenu.swift
//  luxurious
//
//  Created by Nada El Hakim on 10/19/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SideMenu

extension UIViewController {
    func buildSideMenu(){
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.toggleSideMenu))
        menuBtn.width = 10
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "more"), for: .normal)
//        btn.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        btn.addTarget(self, action: #selector(self.toggleSideMenu), for: .touchUpInside)
//        let menuBtn = UIBarButtonItem(customView: btn)
        
        navigationItem.setLeftBarButtonItems([menuBtn], animated: false)
        let currentStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuNavigationController = currentStoryBoard.instantiateViewController(withIdentifier: "SideMenuNavigationController") as! UISideMenuNavigationController
        self.navigationController?.navigationBar.titleTextAttributes =
                  [NSAttributedString.Key.foregroundColor: UIColor.white ,  NSAttributedString.Key.font:UIFont(name: Constants.boldFont, size: 18)!]
        
        let currentLanguage = Utils.getcurrentLanguage()
        print("current language: \(currentLanguage)")
        if currentLanguage == "en" {
            menuNavigationController.leftSide = true
            SideMenuManager.default.menuLeftNavigationController = menuNavigationController
            
        } else {
            menuNavigationController.leftSide = false
            
            SideMenuManager.default.menuRightNavigationController = menuNavigationController
        }
    }
    
    @objc func toggleSideMenu() {
        let currentLanguage = Utils.getcurrentLanguage()

        if currentLanguage == "en" {
            if let menu = SideMenuManager.default.menuLeftNavigationController {
                present(menu, animated: true, completion: nil)
            }
        } else {
            if let menu = SideMenuManager.default.menuRightNavigationController {
                present(menu, animated: true, completion: nil)
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
