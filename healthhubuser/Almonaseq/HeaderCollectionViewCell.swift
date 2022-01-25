//
//  HeaderCollectionViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 12/29/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(Utils.getcurrentLanguage() == "en"){
            headerTitle.text = "Select Services Type";
        }else{
                       headerTitle.text = "إختر نوع الخدمة";

        }
    }

}
