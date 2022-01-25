//
//  headerCollectionReusableView.swift
//  Almonaseq
//
//  Created by unitlabs on 12/29/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class headerCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var lBlTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if(Utils.getcurrentLanguage() == "en"){
             lBlTitle.text = "Select Services Type";
        }else{
            lBlTitle.text = "إختر نوع الخدمة";

              }
    }
    
}
