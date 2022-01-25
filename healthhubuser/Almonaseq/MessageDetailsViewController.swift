//
//  MessageDetailsViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 1/31/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SVProgressHUD


class MessageDetailsViewController: UIViewController  , UITextFieldDelegate{
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageLabel: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var send_btn: UIButton!
    
    var chatMessagesList : [MessageModel] = [];
    let reuseIdentifier = "MessageDetailsTableViewCell"
    var userId = "";
    var tech_id =  "";
    let userDef = UserDefaults.standard
    var userName = "";
    var order_id = "";
     var timer = Timer();
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval();
        send_btn.setMainColoredButton(name: "right-arrow");
        NotificationCenter.default.addObserver(self, selector: #selector(MessageDetailsViewController.handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageDetailsViewController.handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        userId = userDef.string(forKey: "user_id")!;
        userLabel.text = userName;
        messageLabel.delegate = self;
        messageLabel.returnKeyType = .done;
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier);
        getAllMessages(showLoader: true);
        let currentLanguage = Utils.getcurrentLanguage()
        print("current language: \(currentLanguage)")
        if currentLanguage == "en" {
            
            self.backButton.imageView?.image = UIImage(named: "back");
            
        } else {
            self.backButton.imageView?.image = UIImage(named: "right_back");
        }
    }
    
    
    @objc func handleKeyboardNotification(_ notification: Notification) {

         if let userInfo = notification.userInfo {

             let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue

             let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow

             bottomConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height : 0

             UIView.animate(withDuration: 0.5, animations: { () -> Void in
                 self.view.layoutIfNeeded()
             })
         }
     }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        view.endEditing(true);
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        return true
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        messageLabel = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        messageLabel = nil
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        getAllMessages(showLoader : false);
        
    }
    
    func  getAllMessages(showLoader : Bool){
        if(showLoader){
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
            SVProgressHUD.show();
        }
        // http://monasiq.com/mobile/show_singl_msg/87/575  87 ==> user 574==>tech
        var url = Constants.API_ENDPOINT + "show_singl_msg/" + "\(self.userId)" + "/" + "\(self.tech_id)"
        print(url);
        Alamofire.request(url).responseObject { (response: DataResponse<ChatMessages>) in
            
            let menuResponse = response.result.value
            if(menuResponse?.data != nil){
                self.chatMessagesList = (menuResponse?.data)!;
                if(self.chatMessagesList.count > 0){
                   self.tableView.reloadData();
                    var indexPath = IndexPath(row: (self.chatMessagesList.count-1), section: 0)
                    self.tableView.scrollToRow(at:indexPath, at: .bottom, animated: false);
                }
                else{
                    Utils.showToast(message: "لا يوجد رسائل")
                }
            }
            SVProgressHUD.dismiss();
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    @IBAction func sendMessageClicked(_ sender: Any) {
        if(!(messageLabel.text?.isEmpty)! && tech_id != ""){
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
            SVProgressHUD.show();
            sendMessageToServer();
        }
    }
    
    func sendMessageToServer(){
        var message = messageLabel.text!;
        /*
         [{"key":"msg","value":"الحمد لله بخير حال ابغى تصليح سخان كهرباء ","description":"","type":"text","enabled":true},
         {"key":"user_id","value":"87","description":"","type":"text","enabled":true},
         {"key":"tech_id","value":"575","description":"","type":"text","enabled":true},
         {"key":"msg_from","value":"87","description":"","type":"text","enabled":true},
         {"key":"msg_to","value":"575","description":"","type":"text","enabled":true}]
         
         
         */
        let params: Parameters = [
            "msg": message,
            "user_id": userId,
            "tech_id" : tech_id,
            "msg_from" : userId,
            "msg_to" : tech_id,
            "id" : order_id
        ]
        var url = Constants.API_ENDPOINT + "add_msg";
        print(params);
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                print(response.result.value);
                Utils.showToast(message: "تم ارسالة الرسالة بنجاح");
            case .failure(let error):
                print(error)
                
            }
            SVProgressHUD.dismiss();
            self.messageLabel.text = "";
            self.getAllMessages(showLoader: false);
        }
    }
    
    
    @IBAction func refreshDataClicked(_ sender: Any) {
        self.getAllMessages(showLoader: true);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate();
    }
}
extension MessageDetailsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessagesList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! MessageDetailsTableViewCell;
        cell.messageLabel.text = self.chatMessagesList[indexPath.row].msg;
        cell.createdLabel.text = self.chatMessagesList[indexPath.row].created;
        print(self.chatMessagesList[indexPath.row].sent_from)
        if(self.chatMessagesList[indexPath.row].sent_from ==  "\(userId)")
        {
            let secondaryColor = Constants.MainColor
            cell.bigView.backgroundColor = secondaryColor;
            cell.viewConstrained.constant = 12;
            
        }else if(self.chatMessagesList[indexPath.row].sent_from ==  "\(tech_id)"){
            cell.bigView.backgroundColor = UIColor(red:0.30, green:0.27, blue:0.27, alpha:1.0);
            cell.viewConstrained.constant = 50;
        }
        return cell;
        
    }
    
   
    
}
