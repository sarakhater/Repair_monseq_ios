//
//  NotificationTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 9/23/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var createdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedView.layer.cornerRadius = 20;
        roundedView.layer.borderColor = Constants.BORDER_COLOR;
        roundedView.layer.borderWidth = 2.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(notifiaction : NotificationDetailsModel){
        self.notificationLabel.text = notifiaction.notification;
        self.createdLabel.text = notifiaction.created;
    }
    
    
}
