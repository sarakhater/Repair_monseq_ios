
//  ActivateCodeVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 2/25/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import MaterialTextField
import SwiftValidator
import  UserNotifications
import Alamofire
import SVProgressHUD
import UserNotificationsUI //framework to customize the notification

class ActivateCodeVC: UITableViewController, ValidationDelegate {
    let validator = Validator()
    let userDef = UserDefaults.standard
    var userId: Int?
    var fromMenu = true
    var phoneNo = "0500037608";
    var phoneNo2 = "0547372499";
 
     let ContactURL = "http://masae-sa.com/app/mobile3/contact_data";

    @IBOutlet weak var wait_label: UILabel!

    @IBOutlet weak var code: MFTextField!{
    didSet {
        code.layer.cornerRadius =  15
        code.layer.borderColor = Constants.BORDER_COLOR;
        code.layer.borderWidth = 2
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        code.leftView = leftView
        code.leftViewMode = .always
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad();
        getContactData();
       
        userId = userDef.integer(forKey: "user_id");
        if (fromMenu) {
            buildSideMenu()
        }
        // Add form validation
        addValidators()
        
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
    }

    
    @IBAction func activateUser(_ sender: Any) {
        validator.validate(self)
    }
    
    @IBAction func resendCode(_ sender: Any) {
       callResendCode()
    }
    
    func callActivateUser() {
        if (userId != nil) {
            UserManager.activateAccount(id: userId!, code: code.text!, downloadCompleted: { (res) in
                print("user activated")
                self.showLocalNotification();
                let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                vc.fromMenu = true
                self.navigationController?.setViewControllers([vc], animated: true)
            })
        }
       
    }
    func showLocalNotification(){
        
        print("notification will be triggered in five seconds..Hold on tight")
        let content = UNMutableNotificationContent()
        content.title = "تهانينا"
        content.subtitle = ""
        content.body = "مبروك تم تفعيل حسابك كطالب الخدمة"
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "colored_logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier:"userActive", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription)
            }
        }
    }

    func callResendCode() {
        if (userId != nil) {
            UserManager.resendCode(id: userId!, downloadCompleted: { (res) in
                print("resend")
            })
        }
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
        callActivateUser()
    }
    
    func addValidators() {
        // Required fields
        validator.registerField(code, rules: [RequiredRule()])
    }
    
    func getContactData(){
           
           //mobile1":"05411150000101","mobile2":"054111406461032","email":"info@ameen.com"
           SVProgressHUD.show();
           Alamofire.request(ContactURL, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil)
                             .responseJSON { response in
                                 switch response.result {
                                 case .success:
                                     print(response.request as Any)  // original URL request
                                     print(response.response as Any) // URL response
                                     //print(response.result.value as? NSDictionary)
                                     if(response.result.value != nil){
                                         var json =  (response.result.value as! NSDictionary)
                                         var status = json ["result"]
                                         print(status)
                                         var  dataArr =  json["data"]as? NSDictionary
                                       if(dataArr != nil){
                                           
                                           self.phoneNo = dataArr!["mobile1"] as! String ?? "";
                                           self.phoneNo2 = dataArr!["mobile2"] as! String ?? "";
                                         
                                        self.wait_label.text = NSLocalizedString("waitlabel", comment: "")
                                             //+ self.phoneNo + NSLocalizedString("orlabel", comment: "") + self.phoneNo2;
                                           
                
                                           
                                       }
                                        
                                     }
                                 case .failure(let error):
                                     print(error)
                                     
                                 }
                                 
                                 SVProgressHUD.dismiss();
                                 //self.tableView.reloadData();
                         }
                     
                     
                 }
}
extension ActivateCodeVC:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "userActive"{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}
