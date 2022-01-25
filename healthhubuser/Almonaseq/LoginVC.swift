//
//  LoginVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/9/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import MaterialTextField
import UICheckbox_Swift
import SideMenu
import SwiftValidator

class LoginVC: UITableViewController, ValidationDelegate {
 

    var delegate: AuthStatus?
    var currentVC: UIViewController?
    let userDef = UserDefaults.standard
    var fromMenu: Bool = false
    var selected = false
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var savePassword: UICheckbox!
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(L102Language.getRegisterType() == 1){
                   //school
                   if(L102Language.currentAppleLanguage() == "ar"){
                       email.placeholder = "الرقم الوزاري"
                   }else{
                       email.placeholder = "Ministerial No"

                   }
               }else if (L102Language.getRegisterType() == 2){
                   //family
                   if(L102Language.currentAppleLanguage() == "ar"){
                                  email.placeholder = "رقم الجوال"

                              }else{
                                  email.placeholder = "Phone No"

                              }
               }
      
        loginBtn.layer.cornerRadius = 15;
        registerBtn.layer.cornerRadius = 10;
        password.layer.cornerRadius = 12;
        email.layer.cornerRadius = 12;

        bigView.layer.cornerRadius = 20;
//        if (fromMenu) {
//          buildSideMenu()
//        }
//        buildSideMenu();

        // Add form validation
        addValidators()
        
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
        self.navigationItem.title = ""
        let imageView = UIImageView(image: UIImage(named: "bg-2"))
        self.tableView.backgroundView = imageView
//        _ = Utils.initializeGradient(view: loginBtn)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
//         self.navigationController?.setNavigationBarHidden(true, animated: false)
        let savedMobile = userDef.string(forKey: "mobile")
        let rememberMe = userDef.bool(forKey: "remember_me")
        
        savePassword.isSelected = rememberMe
        savePassword.onSelectStateChanged = { (checkbox, selected) in
            debugPrint("Clicked - \(selected)")
            self.selected = selected
        }
        
        if (savedMobile != nil) {
            email.text = savedMobile
        }
        if (rememberMe) {
            email.text = savedMobile
            password.text = userDef.string(forKey: "password")
        }
        
       
//        if let nav = self.navigationController as? UISideMenuNavigationController,
//            let presentingNav = nav.presentingViewController as? UINavigationController {
//            dismiss(animated: true, completion: nil)
//            presentingNav.setViewControllers([vc], animated: false)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func login(_ sender: Any) {
        validator.validate(self)
    }
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loginUser() {
        // Email is changed to mobile number
        UserManager.login(email: email.text!, password: password.text!, downloadCompeted: { (res) in
            self.delegate?.isLoggedIn(loggedIn: true)
            self.userDef.set(true, forKey: "logged_in")
            //self.navigationController?.popViewController(animated: false)
            if (self.fromMenu) {
                if self.currentVC != nil {
                    self.navigationController?.pushViewController(self.currentVC!, animated: true)
                } else {
                    // Sign in from menu clicked
                    // Navigate to home vc
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            if (self.selected) {
                self.userDef.set(self.email.text, forKey: "mobile")
                self.userDef.set(self.password.text, forKey: "password")
            }
            print("rememberme\(self.selected)")
            self.userDef.set(self.selected, forKey: "remember_me")
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    // Form Validation
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            print("error", error)
            if let field = field as? UITextField {
                SideMenuVC.showErrorMessage(txt: NSLocalizedString("register.completeAllFields", comment: ""), .error)
               
            }
        }
    }
    
    // Form is valid
    func validationSuccessful() {
        // submit the form
        loginUser()
        
    }
    
    func addValidators() {
        // Required fields
        validator.registerField(email, rules: [RequiredRule()])
        validator.registerField(password, rules: [RequiredRule()])
        
    }
}
