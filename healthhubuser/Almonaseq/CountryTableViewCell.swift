//
//  CountryTableViewCell.swift
//  AlmonaseqProvider
//
//  Created by unitlabs on 12/12/19.
//  Copyright © 2019 Sara khater. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func  configCell(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
