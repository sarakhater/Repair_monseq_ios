//
//  PriceItemTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 2/2/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class PriceItemTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
