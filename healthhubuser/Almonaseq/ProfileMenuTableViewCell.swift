//
//  ProfileMenuTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 1/20/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class ProfileMenuTableViewCell: UITableViewCell {
    
//MARK:- outlet
    
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var walletBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.layer.cornerRadius = 20;
        walletBtn.layer.cornerRadius  = 10;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
