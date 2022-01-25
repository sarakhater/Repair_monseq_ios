//
//  PriceTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 1/29/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var itemLabel: UILabel!

    @IBOutlet weak var itemPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bigView.layer.cornerRadius = 10;
        bigView.layer.borderColor = Constants.MainColor.cgColor
        bigView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
