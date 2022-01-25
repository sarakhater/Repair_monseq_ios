//
//  SettingsVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 2/27/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import SideMenu

class SettingsVC: UIViewController {
    
    @IBOutlet weak var UserView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userCodeLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var editDataView: UIView!
    
    @IBOutlet weak var changLangView: UIView!
    
    @IBOutlet weak var shareAppView: UIView!
    
    @IBOutlet weak var contactUsView: UIView!
    
    @IBOutlet weak var editLabelBtn: UIButton!
    
    @IBOutlet weak var changeLangBtn: UIButton!
    
    @IBOutlet weak var shareAppBtn: UIButton!
    
    
    @IBOutlet weak var contactUsBtn: UIButton!
    
    var loggedIn = false;
    let userDef = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSideMenu();
          loggedIn = userDef.bool(forKey: "logged_in")
        
        let currentLanguage = Utils.getcurrentLanguage()
              print("current language: \(currentLanguage)")
              if currentLanguage == "en" {
               editLabelBtn.contentHorizontalAlignment = .left
                              changeLangBtn.contentHorizontalAlignment = .left
                              shareAppBtn.contentHorizontalAlignment = .left
                              contactUsBtn.contentHorizontalAlignment = .left
                
                  
              } else {
                editLabelBtn.contentHorizontalAlignment = .right
                changeLangBtn.contentHorizontalAlignment = .right
                shareAppBtn.contentHorizontalAlignment = .right
                contactUsBtn.contentHorizontalAlignment = .right

              }
        UserView.layer.cornerRadius = 30;
        setRoundedCorner(view :editDataView )
        setRoundedCorner(view :changLangView )
        setRoundedCorner(view :shareAppView )
        setRoundedCorner(view :contactUsView )
      
        // Do any additional setup after loading the view.
    }
    func setRoundedCorner(view : UIView){
        view.layer.borderWidth = 2.0;
        view.layer.borderColor = Constants.BORDER_COLOR;
        view.layer.cornerRadius = 20;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func resetPassord(_ sender: Any) {
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func changeLanguage(_ sender: Any) {
        let currentLanguage = Utils.getcurrentLanguage()
        
        print("current language: \(currentLanguage)")
        var lang: String
        if currentLanguage == "en" {
            lang = "ar"
        } else {
            lang = "en"
        }
        let alert = UIAlertController(title: NSLocalizedString("alert.confirm", comment: ""), message: NSLocalizedString("alert.languageMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.cancel", comment: ""), style: .cancel, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.ok", comment: ""), style: .default, handler: { (action) in
            L102Language.setAppleLAnguageTo(lang: lang)
            
            self.reloadControllers(lang: lang)
            //self.reloadControllers(lang: lang);
        }))
        
        present(alert, animated: true, completion: nil)
        

    }
    
    func reloadControllers(lang: String) {
        // Reload controllers
        
        L102Localizer.DoTheMagic()
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigationController")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)

//        let sideMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuNavigationController") as! UISideMenuNavigationController
        
        
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            NotificationCenter.default.post(name: .languageChanged, object: ["language": lang])
        }
    }
    
    
    
    @IBAction func editData(_ sender: UIButton) {
        //ProfileVC in user story board
        
        if(loggedIn){
        let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true);
        }else{
             let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true);

        }
    }
    
    @IBAction func shareApp(_ sender: UIButton) {
        Utils.share(sender, context: self);
    }
    
    @IBAction func contactUs(_ sender: UIButton) {
        //ContactVC in app storybaord
        
        let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
}
