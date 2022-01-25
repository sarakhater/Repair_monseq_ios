//
//  ForgotPasswordVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 12/25/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SwiftValidator
import MaterialTextField

class ForgotPasswordVC: UITableViewController, ValidationDelegate  {

    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var mobileStack: UIStackView!
    @IBOutlet weak var mobile: MFTextField!
    @IBOutlet weak var email: MFTextField!
    @IBOutlet var emailMobileToggle: [UIButton]!

    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobile.layer.borderWidth = 2.0;
        self.mobile.layer.borderColor = Constants.BORDER_COLOR;
        self.mobile.layer.cornerRadius = 15;
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        self.mobile.textPadding = CGSize(width: 5, height: 10)
        Utils.removeGradientLayer(view: emailMobileToggle[1])
        emailMobileToggle[1].setTitleColor(UIColor.black, for: .normal);
        
        // Add form validation
        addValidators()
        
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    
    @IBAction func toggleEmailMobile(_ sender: UIButton) {
        emailMobileToggle.forEach { (button) in
            Utils.removeGradientLayer(view: button)
            button.setTitleColor(UIColor.black, for: .normal)
        }
        print("tapped\(sender.tag)")
         Utils.addGradientLayer(view: sender)
        sender.setTitleColor(UIColor.white, for: .normal)
        if (sender.tag == 1) {
            emailStack.isHidden = true
            mobileStack.isHidden = false
        } else {
            mobileStack.isHidden = true
            emailStack.isHidden = false
        }
    }
    func reset() {
        UserManager.resetPassword(phone: self.mobile.text!) { (res) in
            // self.validator.errors.removeAll()
//            UserDefaults.standard.set(false, forKey: "remember_me")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        self.mobile.setError(nil, animated: false)
        validator.validate(self)
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
    }
    
    // Form is valid
    func validationSuccessful() {
        // submit the form
        reset()
    }
    
    func addValidators() {
        // Required fields
        validator.registerField(mobile, rules: [RequiredRule()])
    }

    

}
