//
//  StoreCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 12/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
class StoreTableCell: UITableViewCell {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var storeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(store: Store) {
        name.text = store.name
        address.text = store.address
        storeImage.sd_setImage(with: URL(string: store.image), placeholderImage: UIImage(named: "colored_logo"))
    }
}
