//
//  NewOrderTabsViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 2/2/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import SWSegmentedControl

class NewOrderTabsViewController: UIViewController {

    @IBOutlet weak var segmentView: SWSegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Utils.getcurrentLanguage() == "ar"){
                segmentView.items = ["الطلبات الحالية" , "الطلبات السابقة"];
               }else{
                   segmentView.items = ["Current Orders" , "Previous Orders"];
               }
        segmentView.backgroundColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
        segmentView.selectedSegmentIndex = 0;

    }
      //send notification to tableview
    @IBAction func valueChanged(_ sender: SWSegmentedControl) {
        switch segmentView.selectedSegmentIndex {
               case 0:
                   //current order
            NotificationCenter.default.post(name: Notification.Name("getOrders"), object: nil, userInfo: ["type" : 0]);
            
               case 1:
                //previous
            NotificationCenter.default.post(name: Notification.Name("getOrders"), object: nil, userInfo: ["type" : 1]);
               default:
                   break;
               }
    }
    
    


}
