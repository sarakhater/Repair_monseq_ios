//
//  ChatMessagesTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 1/31/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class ChatMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bigView: UIView!
    
    @IBOutlet weak var sendToNameLabel: UILabel!
    
    @IBOutlet weak var createdLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.layer.cornerRadius = 10;
        //imageIcon.setColoredImage(name:"MaskGroup1" , colorName: Constants.SencondColor);

        
        //bigView.layer.borderWidth = 2.0;
        //self.bigView.layer.borderColor = UIColor.init(red: 38.0/255.0, green: 131.0/255.0, blue: 77.0/255.0, alpha: 1.0).cgColor;

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
