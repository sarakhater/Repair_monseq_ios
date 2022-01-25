//
//  ContactUsTabsTableViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 2/13/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SVProgressHUD

class ContactUsTabsTableViewController: UITableViewController ,  MFMessageComposeViewControllerDelegate {


var phoneNo = "0500037608";
var phoneNo2 = "0547372499";
var email = "";
let ContactURL = Constants.API_ENDPOINT + "contact_data";

@IBOutlet weak var emailLabel: UILabel!
@IBOutlet weak var phone1Label: UILabel!


    @IBOutlet weak var mailTitleLabel: UILabel!
    @IBOutlet weak var phone2Label: UILabel!

    @IBOutlet weak var phoneTiltleLabel: UILabel!
    
    @IBOutlet weak var phone2TitleLabel: UILabel!
    
    @IBAction func handleCall(_ sender: Any) {
    
    guard let number = URL(string: "tel://" + (self.phoneNo)) else { return }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(number)
    } else {
        // Fallback on earlier versions
    }
}

@IBAction func handleCall2(_ sender: Any) {
       
       guard let number = URL(string: "tel://" + (self.phoneNo2)) else { return }
       if #available(iOS 10.0, *) {
           UIApplication.shared.open(number)
       } else {
           // Fallback on earlier versions
       }
   }


@IBAction func sendMessage(_ sender: Any) {
    
    if (MFMessageComposeViewController.canSendText()) {
        let controller = MFMessageComposeViewController()
        controller.body = ""
        controller.recipients = [(self.phoneNo)]
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
}


@IBAction func sendMessage2(_ sender: Any) {
       
       if (MFMessageComposeViewController.canSendText()) {
           let controller = MFMessageComposeViewController()
           controller.body = ""
           controller.recipients = [(self.phoneNo2)]
           controller.messageComposeDelegate = self
           self.present(controller, animated: true, completion: nil)
       }
   }

@IBAction func openWhatsApp(_ sender: Any) {
    
    let urlWhats = "whatsapp://send?phone=\(self.phoneNo))"
    if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
        if let whatsappURL = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(whatsappURL){
                UIApplication.shared.openURL(whatsappURL)
            }
            else {
                print("Install Whatsapp")
            }
        }
    }
}


@IBAction func openWhatsApp2(_ sender: Any) {
       
       let urlWhats = "whatsapp://send?phone=\(self.phoneNo2))"
       if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
           if let whatsappURL = URL(string: urlString) {
               if UIApplication.shared.canOpenURL(whatsappURL){
                   UIApplication.shared.openURL(whatsappURL)
               }
               else {
                   print("Install Whatsapp")
               }
           }
       }
   }

override func viewDidLoad() {
    super.viewDidLoad()
    buildSideMenu()
    
    tableView.backgroundView = UIImageView(image: UIImage(named: "bg-2"))
    getContactData();
    if(Utils.getcurrentLanguage() == "ar"){
         mailTitleLabel.text = "البريد الالكتروني"
        phoneTiltleLabel.text = "الجوال"
         phone2TitleLabel.text = "الهاتف"
        self.title = "اتصل بنا"
    }else{
        mailTitleLabel.text = "Email"
        phoneTiltleLabel.text = "Mobile"
         phone2TitleLabel.text = "Phone"
           self.title = "Contact Us"

    }
   
    //call web services to get phone numbers:
   
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
}

func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
    //... handle sms screen actions
    self.dismiss(animated: true, completion: nil)
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
                                    self.email = dataArr!["email"]  as! String ?? "";
                                    
                                    
                                    self.phone1Label.text = self.phoneNo;
                                    
                                    self.phone2Label.text = self.phoneNo2;
                                    
                                    self.emailLabel.text = self.email;
                                    
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


