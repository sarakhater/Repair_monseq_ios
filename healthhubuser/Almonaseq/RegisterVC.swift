//
//  RegisterVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/9/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import MaterialTextField
import LocationPicker
import CoreLocation
import UICheckbox_Swift
import SwiftValidator

class RegisterVC: UITableViewController, CLLocationManagerDelegate, ValidationDelegate {
    let validator = Validator()
    let geocoder = CLGeocoder()
    
    let userDef = UserDefaults.standard
    var coords: [String:Double]?
    var editProfile: Bool = false
    var userId: String?
    var user: [String: String]?
    var termsChecked = false


    @IBOutlet weak var address: MFTextField!
  
    @IBOutlet weak var otherAddress: MFTextField!
    @IBOutlet weak var fullName: MFTextField!
    
    @IBOutlet weak var userName: MFTextField!
    
    @IBOutlet weak var termsCheckbox: UICheckbox!
    
    @IBOutlet weak var email: MFTextField!
    
    @IBOutlet weak var mobile: MFTextField!
    
    @IBOutlet weak var password: MFTextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var confirmPassword: MFTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEditTextRoundedViews(textField: userName);
         self.setEditTextRoundedViews(textField: fullName);
         self.setEditTextRoundedViews(textField: email);
        self.setEditTextRoundedViews(textField: mobile);
        self.setEditTextRoundedViews(textField: password);
        self.setEditTextRoundedViews(textField: address);

        self.setEditTextRoundedViews(textField: otherAddress);
        self.setEditTextRoundedViews(textField: confirmPassword);


        // Prevent keyboard from opening
        // for location field
        address.inputView = UIView()
        
       
        fullName.errorFont = UIFont(name: "Avenir", size: 10)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Terms check
        termsCheckbox.onSelectStateChanged = {
            (checkbox, selected) in
            self.termsChecked = selected
        }
       
        
        // Add form validation
        addValidators()
        
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        mobile.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setEditTextRoundedViews(textField : UITextField){
        
        //textField.layer.borderWidth = 2.0;
        //textField.layer.borderColor = Constants.BORDER_COLOR;
        textField.layer.cornerRadius = 15;
        //textField.textPadding = CGSize(width: 5, height: 10)
        //textField.underlineHeight = 0.0;
        
    
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if(mobile.text!.count > 1){
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
    
    override func viewWillAppear(_ animated: Bool) {
        if (editProfile) {
            let buttonTitle: String = "save"
            userId = userDef.string(forKey: "user_id")
            user = userDef.dictionary(forKey: "user") as? [String : String]
            fullName.text = user?["name"]
            userName.text = user?["username"]
            mobile.text = user?["phone"]
            email.text = user?["email"]
            buildSideMenu()
            registerBtn.setTitle(buttonTitle, for: .normal)
        }
    }

   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (editProfile) {
            
            if 4 == indexPath.row {
                return 0
            } else {
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        }
        
        else {
//            if indexPath.row == 6 {
//                return 0
//            } else {
//                return super.tableView(tableView, heightForRowAt: indexPath)
//            }
          
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    
  func register() {
//    let activateVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ActivateCodeVC") as! ActivateCodeVC
//        self.navigationController?.pushViewController(activateVC, animated: false)
        if (fullName.text?.isEmpty)! {
            let error = NSError(domain: "", code: 1, userInfo: ["fullname": "fullname"])
            fullName.setError(error, animated: true)
        } else {
//            UserManager.register(name: fullName.text!, username: userName.text!, password: password.text!, email: email.text!, mobile: mobile.text!, lat: (self.coords?["lat"])!, long: (self.coords?["long"])!) { (res) in
//                Utils.showToast(message: "registration successfull")
//                let activateVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ActivateCodeVC") as! ActivateCodeVC
//                activateVC.fromMenu = false
//                self.navigationController?.pushViewController(activateVC, animated: false)
//            }
        }
    }

    func updateProfile() {
        print("update profile")
        let params: [String: Any] = [
            "user_id": userId!,
            "name": fullName.text!,
            "map_lat": self.coords?["lat"]! as Any,
            "map_lang": self.coords?["long"]! as Any,
            "user_name": userName.text!,
            "email": email.text!,
            "password": password.text!,
            "phone": mobile.text!
        ]
        UserManager.editUser(params: params) { (res) in
        }
    }
  
    @IBAction func register(_ sender: Any) {
        resetFieldErrors()
        validator.validate(self)
    }
    
    func sendRegister() {
        if (editProfile) {
            updateProfile()
        } else {
            register()
        }
    }

    @IBAction func chooseLocation(_ sender: MFTextField) {
        print("choose location")
//        self.coords = ["lat": 30.099, "long": 31.317]
        let locationPicker = LocationPickerViewController()
        locationPicker.mapType = .standard // default: .Hybrid
        locationPicker.showCurrentLocationInitially = true
        locationPicker.showCurrentLocationButton = true
        locationPicker.selectCurrentLocationInitially = true
        navigationController?.pushViewController(locationPicker, animated: true)

        locationPicker.completion = { location in
            // do some awesome stuff with location
            print("location is\(String(describing: location?.address)) - ")
            self.address.text = location?.address
            self.coords = ["lat": (location?.coordinate.latitude)!, "long": (location?.coordinate.longitude)!]
            print("coords: \(String(describing: self.coords))")
        }


    }
    
     // Setting location picker
    func setupLocationPicker() {
        
        // Get current coords
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startMonitoringSignificantLocationChanges()
//    
//        let location: CLLocation = locationAuthStatus()
//        print("current location \(location.coordinate.latitude) - \(location.coordinate.longitude)")
//
//        geocoder.reverseGeocodeLocation(location) { (placemarks, errors) in
//        let initialLocation = Location(name: "My home", location: location, placemark: (placemarks?[0])!)
//        self.locationPicker.location = initialLocation
//        }
//

    }
    
    @IBAction func viewTerms(_ sender: Any) {
//        let url = URL(string: "http://monasiq.com/")!
//        UIApplication.shared.open(url, options: [:], completionHandler: { (res) in
//            self.termsCheckbox.isSelected = true
//        })
        termsCheckbox.isSelected = true
        let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as! PageVC
        vc.fromMenu = false
//        let currentLanguage = Utils.getcurrentLanguage()
        vc.pageId = "10"
//        if currentLanguage == "en" {
//            vc.pageId = "12"
//        } else {
//            vc.pageId = "10"
//        }
        
        vc.navTitle = NSLocalizedString("register.terms", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    
    // Form Validation
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        if (confirmPassword.text != password.text) {
            confirmPassword.errorFont = UIFont(name: "Avenir", size: 10)
            confirmPassword.setError(FormError.match, animated: true)
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
        if (editProfile) {
            updateProfile()
        } else {
            if self.termsChecked {
                if(mobile.text?.characters.count  !=  10){
                    Utils.showToast(message: NSLocalizedString("formErrors.checkPhone", comment: ""))
                }else{
                    sendRegister()
                    
                }
            } else {
                Utils.showToast(message: NSLocalizedString("formErrors.checkTerms", comment: ""))
            }
        }
    }
    
    func resetFieldErrors() {
        fullName.setError(nil, animated: false)
        address.setError(nil, animated: false)
        mobile.setError(nil, animated: false)
        //email.setError(nil, animated: false)
        password.setError(nil, animated: false)
        confirmPassword.setError(nil, animated: false)
    }
    
    func addValidators() {
        // Required fields for register
        validator.registerField(fullName, rules: [RequiredRule()])
        validator.registerField(address, rules: [RequiredRule()])
        validator.registerField(mobile, rules: [RequiredRule()])
       // validator.registerField(email, rules: [RequiredRule()])
        validator.registerField(password, rules: [RequiredRule()])
        
        if (editProfile) {
            
        } else {
            //Match Passwords
            validator.registerField(confirmPassword, rules: [ConfirmationRule(confirmField: password)])
//            validator.registerField(confirmPassword, rules: [ConfirmationRule(confirmField: password)])
        }
        
        
        
    }
}
