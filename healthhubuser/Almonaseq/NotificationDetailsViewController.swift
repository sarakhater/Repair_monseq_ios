//
//  NotificationDetailsViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 9/25/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var linkWepView: UIWebView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var createdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedView.layer.cornerRadius = 20;
        roundedView.layer.borderColor = Constants.BORDER_COLOR;
        roundedView.layer.borderWidth = 2.0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
