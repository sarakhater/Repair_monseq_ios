//
//  NewDeleteOrdersViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 9/28/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class NewDeleteOrdersViewController: UIViewController , UITextViewDelegate{

    var  requestId = "";

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var reasonTextView: UITextView!
    
    
    @IBOutlet weak var cancelOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Utils.getcurrentLanguage() == "en"){
            reasonTextView.text = " Write Delete Reason";
        }else{
            reasonTextView.text = "اكتب سبب الحذف";
        }
        reasonTextView.delegate = self;
        reasonTextView.returnKeyType = .done;
        reasonTextView.layer.borderWidth = 1.0;
        self.reasonTextView.layer.borderColor = Constants.BORDER_COLOR;
        self.reasonTextView.layer.cornerRadius = 15;
        
        self.cancelOrderButton.layer.cornerRadius = 15;

    
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        reasonTextView.text = "";
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            reasonTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            reasonTextView.resignFirstResponder()
            return false
        }
        return true
    }

    
    @IBAction func cancelOrders(_ sender: UIButton) {
        if(reasonTextView.text.isEmpty){
            Utils.showToast(message:  "ادخل السبب")
        }else{
            self.view.endEditing(true);
            UserManager.deleteOrder(reqId: requestId , reason : reasonTextView.text){
                (res) in
                self.dismiss(animated: true, completion: nil);
                NotificationCenter.default.post(name: .Refreshorders, object: nil)
                //send notification to ordervc to update requests
                //self.getRequests(refresher: true)
            }
        }
        
        
    }
    
    @IBAction func dismissControler(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);

    }
    
    
}
