//
//  FirstRegisterViewController.swift
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
import MaterialTextField
import SVProgressHUD
import Alamofire
import MapKit


class FirstRegisterViewController: UIViewController , ValidationDelegate , UITextFieldDelegate{
    let validator = Validator()
    var selectedCategoriesList : [Category] = []
    var selectedSubCategoriesList : [Category] = []
    var selectedCountryIds: [String] = []
    var selectedCityIds: [String] = []
    var categories = [Category]()
    var categoryNames = [String]()
    var subCategories = [Category]()
    var subCategoryNames = [String]()
    let currentLanguage = L102Language.currentAppleLanguage()
    var params = [String: Any]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var fullNameLabel: UITextField!{
        didSet {
        fullNameLabel.layer.cornerRadius =  20
        fullNameLabel.layer.borderColor = Constants.MainColor.cgColor
        fullNameLabel.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var confirmPhoneNumberLabel: UITextField!{
        didSet {
        confirmPhoneNumberLabel.layer.cornerRadius =  20
        confirmPhoneNumberLabel.layer.borderColor = Constants.MainColor.cgColor
        confirmPhoneNumberLabel.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var phoneNumberLabel: UITextField!{
        didSet {
        phoneNumberLabel.layer.cornerRadius =  20
        phoneNumberLabel.layer.borderColor = Constants.MainColor.cgColor
        phoneNumberLabel.layer.borderWidth = 1
        
        }
    }
    
    @IBOutlet weak var passwordLabel: UITextField!{
        didSet {
           passwordLabel.layer.cornerRadius =  20
           passwordLabel.layer.borderColor = Constants.MainColor.cgColor
           passwordLabel.layer.borderWidth = 1
           
           }
       }
    
    @IBOutlet weak var passwordConfirmLabel: UITextField!{
        didSet {
           passwordConfirmLabel.layer.cornerRadius =  20
           passwordConfirmLabel.layer.borderColor = Constants.MainColor.cgColor
           passwordConfirmLabel.layer.borderWidth = 1
           
           }
       }
    @IBOutlet weak var addressLabel: UITextField!{
         didSet {
            addressLabel.layer.cornerRadius =  20
            addressLabel.layer.borderColor = Constants.MainColor.cgColor
            addressLabel.layer.borderWidth = 1
            
            }
        }
    @IBOutlet weak var nextBtn: UIButton!
    
    
    let userDef = UserDefaults.standard;
    var editProfile: Bool = false;
    var userId: String?
    var user: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEditTextRoundedViews(textField: fullNameLabel);
        self.setEditTextRoundedViews(textField: confirmPhoneNumberLabel);
        self.setEditTextRoundedViews(textField: phoneNumberLabel);
        nextBtn.layer.borderWidth = 2.0;
        nextBtn.layer.borderColor = Constants.BORDER_COLOR;
        nextBtn.layer.cornerRadius = 20;
        //fullNameLabel.errorFont = UIFont(name: "Avenir", size: 10);
        
        addValidators()
        self.hideKeyboardWhenTappedAround()
        phoneNumberLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPhoneNumberLabel.enablesReturnKeyAutomatically = true;
        self.confirmPhoneNumberLabel.delegate = self
        confirmPhoneNumberLabel.returnKeyType = .done;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        self.view.endEditing(true)
        return true;
    }
    func setEditTextRoundedViews(textField : UITextField){
        
        textField.layer.borderWidth = 1.0;
        //textField.layer.borderColor = Constants.BORDER_COLOR;
        textField.layer.cornerRadius = 20;
        //textField.textPadding = CGSize(width:10, height: 5)
        //textField.underlineHeight = 0.0;
        textField.textAlignment = .center;
    }
    
    func addValidators() {
        // Required fields for register
        validator.registerField(fullNameLabel, rules: [RequiredRule()])
        validator.registerField(phoneNumberLabel, rules: [RequiredRule()])
        validator.registerField(confirmPhoneNumberLabel, rules: [RequiredRule()])
        //validator.registerField(confirmPhoneNumberLabel, rules: [ConfirmationRule(confirmField: phoneNumberLabel)])
    }
    
    func resetFieldErrors() {
        //fullNameLabel.setError(nil, animated: false);
        //phoneNumberLabel.setError(nil, animated: false);
        //confirmPhoneNumberLabel.setError(nil, animated: false);
    }
    
    // Form is valid
    func validationSuccessful() {
        // submit the form
        
        if(phoneNumberLabel.text?.characters.count  !=  10){
            Utils.showToast(message: NSLocalizedString("formErrors.checkPhone", comment: ""))
        }else  if ((confirmPhoneNumberLabel.text != phoneNumberLabel.text) && !confirmPhoneNumberLabel.text!.isEmpty) {
            //phoneNumberLabel.errorFont = UIFont(name: "Avenir", size: 15)
            //confirmPhoneNumberLabel.errorFont = UIFont(name: "Avenir", size: 15)
            
            //confirmPhoneNumberLabel.setError(FormError.match, animated: false)
            Utils.showToast(message: NSLocalizedString("register.confirmPhoneNumber", comment: ""))
        } else{
            //go to second registeration page
            let secondVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SecondRegisterViewController") as! SecondRegisterViewController
            secondVC.fullName = fullNameLabel.text!
            secondVC.mobile = phoneNumberLabel.text!;
            if(self.selectedCountryIds.count > 0){
                secondVC.countryId =  self.selectedCountryIds[0] ;
            }
            if(self.selectedCityIds.count > 0){
                secondVC.cityId =  self.selectedCityIds[0];
            }
            self.navigationController?.pushViewController(secondVC, animated: false)
        }
        
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        
        
        for (field, error) in errors {
            if let field = field as? MFTextField {
                field.errorFont = UIFont(name: "Avenir", size: 15)
                if (field.tag != 10) {
                    field.setError(FormError.required, animated: true)
                }
            }
            Utils.showToast(message: NSLocalizedString("formErrors.required", comment: ""))
        }
        
        
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if(phoneNumberLabel.text!.count > 1){
            if(textField.text?.starts(with: "05"))!{
                if(textField.text!.count > 1 && textField.text!.count < 11){
                    let first2 = textField.text?.substring(to:(textField.text?.index((textField.text?.startIndex)!, offsetBy: 2))!)
                }else{
                    textField.text = "";
                    let color = UIColor.red
                    Utils.showToast(message: "رقم جوال مثل  (05xxxxxxx)");
                    textField.attributedPlaceholder = NSAttributedString(string: "رقم جوال مثل  (05xxxxxxx)", attributes: [NSAttributedStringKey.foregroundColor : color])
                }
            }else{
                Utils.showToast(message: " رقم جوال مثل (05xxxxxxx)");
                
                textField.text = "";
                let color = UIColor.red
                textField.attributedPlaceholder = NSAttributedString(string: "رقم جوال مثل (05xxxxxxx)", attributes: [NSAttributedStringKey.foregroundColor : color])
            }
        }
    }
    
    
    @IBAction func GoToSecondRegisterationPage(_ sender: UIButton) {
        // addValidators();
        resetFieldErrors()
        validator.validate(self)
        
        
        
        
        
        
    }
}
