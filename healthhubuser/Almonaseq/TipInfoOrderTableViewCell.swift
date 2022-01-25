//
//  TipInfoOrderTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 9/24/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class TipInfoOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tipLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tipLabel.text = NSLocalizedString("order.tip", comment: "");

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
