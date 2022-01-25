//
//  MessageDetailsTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 1/31/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class MessageDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var viewConstrained: NSLayoutConstraint!
    @IBOutlet weak var createdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.layer.cornerRadius = 12;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
