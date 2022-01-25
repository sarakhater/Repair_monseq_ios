//
//  DeleteReasonsViewController.swift
//  AlmonaseqProvider
//
//  Created by unitlabs on 2/4/19.
//  Copyright © 2019 Sara khater. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import MaterialTextField


class DeleteReasonsViewController: UIViewController {
    
    
    @IBOutlet weak var deleteReasonTextField:MFTextField!
    
    @IBOutlet weak var cancelOrderBtn: UIButton!
    
    @IBOutlet weak var closeBtn: UIButton!
    let currentLanguage = L102Language.currentAppleLanguage()
    var reasonsDeleteAr = [String]();
    var reasonsDeleteEn = [String]();
    var  requestId = "";
   static  var selectedReason = "";
    override func viewDidLoad() {
        super.viewDidLoad();
        
        deleteReasonTextField.layer.borderWidth = 2.0;
        self.deleteReasonTextField.layer.borderColor = Constants.BORDER_COLOR;
        self.deleteReasonTextField.layer.cornerRadius = 15;
       

        // Do any additional setup after loading the view.
        // reasonsDeleteAr.append("اختر سبب");
         reasonsDeleteAr.append("عملت الطلب للتجرية فقط");
         reasonsDeleteAr.append("حصلت علي مقدم خدمة من خارج التطبيق");
         reasonsDeleteAr.append("تأخر قبول طلبي");
         reasonsDeleteAr.append("لم يعجبني السعر");
         reasonsDeleteAr.append("لم يعجبني التطبيق");
         reasonsDeleteAr.append("سبب أخر");
        
        
        ///////////
        //reasonsDeleteEn.append("Choose delete reason");
        reasonsDeleteEn.append("I did request for experiment only");
        reasonsDeleteEn.append("I got a services provider outside app");
        reasonsDeleteEn.append("Delayed Acceptance of my application");
        reasonsDeleteEn.append("I don't like the price");
        reasonsDeleteEn.append("I don't like the Application");
        reasonsDeleteEn.append("Another reason");
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSelectCategory(_:)))
      
        deleteReasonTextField.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func onSelectCategory(_ gesture:UITapGestureRecognizer){
        var reasonDeleteArray : [String]  = [];
        var title = "";
        if self.currentLanguage == "en-US"{
            reasonDeleteArray = self.reasonsDeleteEn;
           
        }else{
            reasonDeleteArray = self.reasonsDeleteAr;
            
        }
        ActionSheetStringPicker.show(withTitle: NSLocalizedString(title, comment: ""), rows: reasonDeleteArray, initialSelection: 0, doneBlock: { (picker, index, value) in
            
            let selectedCategory = reasonDeleteArray[index]
            self.deleteReasonTextField.text = selectedCategory;
            DeleteReasonsViewController.selectedReason = selectedCategory;
            }, cancel: { (picker) in
                
        }, origin: deleteReasonTextField)
    }

    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func cancelOrderClicked(_ sender: UIButton) {
        if(DeleteReasonsViewController.selectedReason.isEmpty){
           Utils.showToast(message: "ادخل السبب")
        }else{
        UserManager.deleteOrder(reqId: requestId , reason : DeleteReasonsViewController.selectedReason){
            (res) in
            self.dismiss(animated: true, completion: nil);
             NotificationCenter.default.post(name: .Refreshorders, object: nil)
            //send notification to ordervc to update requests
            //self.getRequests(refresher: true)
        }
        }
    }
    
    
}
