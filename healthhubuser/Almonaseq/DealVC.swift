//
//  DealVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 2/28/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit

class DealVC: UITableViewController {
    var provider: Provider?
    var orderId: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func review(_ sender: Any) {
        if (provider != nil) {
            let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
            vc.provider = provider
            vc.orderId = orderId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

   
}
