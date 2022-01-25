//
//  LoginViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 9/8/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
import MaterialTextField
import UICheckbox_Swift
import SideMenu
import SwiftValidator

class LoginViewController: UIViewController , ValidationDelegate{
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var passwordPhone: UIView!
    @IBOutlet weak var phoneView: UIView!
    var delegate: AuthStatus?
    var currentVC: UIViewController?
    let userDef = UserDefaults.standard
    var fromMenu: Bool = false
    var selected = false
    @IBOutlet weak var email: MFTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var password: MFTextField!
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
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.bigView.insertSubview(backgroundImage, at: 0);
        loginBtn.layer.cornerRadius = 20;
        
        phoneView.layer.cornerRadius = 23;
        passwordPhone.layer.cornerRadius = 23;
        if (fromMenu) {
            buildSideMenu()
        }
        
        // Add form validation
        addValidators()
        
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
        self.navigationItem.title = ""
        
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
    }
        
        @IBAction func login(_ sender: Any) {
            email.setError(nil, animated: false)
            password.setError(nil, animated: false)
            validator.validate(self)
        }

    func loginUser() {
        // Email is changed to mobile number
        UserManager.login(email: email.text!, password: password.text!, downloadCompeted: { (res) in
            self.delegate?.isLoggedIn(loggedIn: true)
            self.navigationController?.popViewController(animated: false)
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
            
        })
    }
    
    // Form Validation
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            print("error", error)
            if let field = field as? MFTextField {
                field.errorFont = UIFont(name: "Avenir", size: 10)
                field.setError(FormError.required, animated: true)
            }
        }
        //        self.tableView.scrollToRow(at: 0, at: 0, animated: true)
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
