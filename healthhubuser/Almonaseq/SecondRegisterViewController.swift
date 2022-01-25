//
//  SecondRegisterViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 10/1/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
import MaterialTextField
import LocationPicker
import CoreLocation
import UICheckbox_Swift
import SwiftValidator


class SecondRegisterViewController: UIViewController , ValidationDelegate , UITextFieldDelegate {
    let validator = Validator()
    let geocoder = CLGeocoder()
    
    let userDef = UserDefaults.standard
    var coords: [String:Double]?
    var editProfile: Bool = false
    var userId: String?
    var user: [String: String]?
    var termsChecked = false
    
    var mobile : String = "";
    var fullName = "";
   var countryId =  "";
    var cityId = "";
    var genderTypeArrayAR = ["ذكر" , "أنثي" ];
    var genderTypeArrayEN = ["Male" , "Female" ];

    
    @IBOutlet weak var termsCheckbox: UICheckbox!

    @IBOutlet weak var email: MFTextField!
    @IBOutlet weak var password: MFTextField!
    @IBOutlet weak var registerBtn: UIButton!
    var genderPicker = UIPickerView();
    
    @IBOutlet weak var ageTxtField: MFTextField!{
        didSet {
            ageTxtField.layer.cornerRadius =  20
            ageTxtField.layer.borderColor = Constants.BORDER_COLOR
            ageTxtField.layer.borderWidth = 2
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
            ageTxtField.leftView = leftView
            ageTxtField.leftViewMode = .always
        }
    }
    @IBOutlet weak var chooseTypeTxtField: MFTextField!{
        didSet {
            chooseTypeTxtField.layer.cornerRadius =  20
            chooseTypeTxtField.layer.borderColor = Constants.BORDER_COLOR
            chooseTypeTxtField.layer.borderWidth = 2
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
            chooseTypeTxtField.leftView = leftView
            chooseTypeTxtField.leftViewMode = .always
        }
    }
    @IBOutlet weak var confirmPassword: MFTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPassword.delegate = self;
        confirmPassword.returnKeyType = .done;
        genderPicker.delegate = self;
        genderPicker.dataSource = self;
        // Terms check
        termsCheckbox.onSelectStateChanged = {
            (checkbox, selected) in
            self.termsChecked = selected
        }
        chooseTypeTxtField.inputView = genderPicker;
        if(Utils.getcurrentLanguage() == "ar"){
            chooseTypeTxtField.placeholder = "اختر الجنس";
            ageTxtField.placeholder = "العمر";
        }else{
            chooseTypeTxtField.placeholder = "Choose Gender";
            ageTxtField.placeholder = "Age";


        }
        
        // Add form validation
        addValidators();

//        let tapGenderTypeGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSelectGenderType(_:)));
//              chooseTypeTxtField.addGestureRecognizer(tapGenderTypeGestureRecognizer);
        
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        self.setEditTextRoundedViews(textField: email);
        self.setEditTextRoundedViews(textField: password);
        self.setEditTextRoundedViews(textField: confirmPassword);

    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmPassword.resignFirstResponder();
        self.view.endEditing(true);
        return true;
    }
    func setEditTextRoundedViews(textField : MFTextField){
        
        textField.layer.borderWidth = 2.0;
        textField.layer.borderColor = Constants.BORDER_COLOR;
        textField.layer.cornerRadius = 15;
        //textField.textPadding = CGSize(width: 5, height: 10)
        textField.underlineHeight = 0.0;
        textField.textAlignment = .center;
        
        
    }
    func addValidators() {
        // Required fields for register
        validator.registerField(password, rules: [RequiredRule()])
        validator.registerField(confirmPassword, rules: [RequiredRule()])
            //Match Passwords
        validator.registerField(confirmPassword, rules: [ConfirmationRule(confirmField: password)])

    }
    
    
    @IBAction func viewTerms(_ sender: Any) {
        termsCheckbox.isSelected = true
        let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as! PageVC
        vc.fromMenu = false
        vc.pageId = "10"
        
        vc.navTitle = NSLocalizedString("register.terms", comment: "");
        self.navigationController?.pushViewController(vc, animated: true);

    }
    
    
    // Form Validation
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        if (confirmPassword.text != password.text) {
            confirmPassword.errorFont = UIFont(name: "Avenir", size: 10)
            confirmPassword.setError(FormError.match, animated: true)
            Utils.showToast(message: NSLocalizedString("register.confirmPassword", comment: ""));
        }
        for (field, error) in errors {
            if let field = field as? MFTextField {
                field.errorFont = UIFont(name: "Avenir", size: 10)
                if (field.tag != 10) {
                    field.setError(FormError.required, animated: true)
                }
            }
        }
        //        self.tableView.scrollToRow(at: 0, at: 0, animated: true)
    }
    
    // Form is valid
    func validationSuccessful() {
        // submit the form
       
            if self.termsChecked {
                
                    sendRegister()
                    
                
            } else {
                Utils.showToast(message: NSLocalizedString("formErrors.checkTerms", comment: ""))
            }
        }
    
    
    func resetFieldErrors() {
        password.setError(nil, animated: false)
        confirmPassword.setError(nil, animated: false)
    }
    
    
    @IBAction func register(_ sender: Any) {
        resetFieldErrors()
        validator.validate(self)
    }
    
    
    
    func sendRegister() {
        
        UserManager.register(name: fullName,  password: password.text!, email: email.text!, mobile: mobile ,countryid : countryId , cityid : cityId , age : ageTxtField.text  ?? "" , gender : chooseTypeTxtField.text ?? "" ) { (res) in
                Utils.showToast(message: "registration successfull")
                let activateVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ActivateCodeVC") as! ActivateCodeVC
                activateVC.fromMenu = false
                self.navigationController?.pushViewController(activateVC, animated: false)
            }
        }
    

    
}

extension SecondRegisterViewController :  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderTypeArrayAR.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(Utils.getcurrentLanguage() == "ar"){
            return self.genderTypeArrayAR[row];
        }else{
         return self.genderTypeArrayEN[row];
        }
     
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if(Utils.getcurrentLanguage() == "ar"){
                      chooseTypeTxtField.text = genderTypeArrayAR[row];
                   }else{
                  chooseTypeTxtField.text = genderTypeArrayEN[row];
                   }
    }

    
}
