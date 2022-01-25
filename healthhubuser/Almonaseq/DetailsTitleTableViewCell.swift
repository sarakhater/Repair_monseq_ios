//
//  DetailsTitleTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 2/5/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

protocol DetailsTitleTableViewCellDelegate {
     func dismissView()
}

class DetailsTitleTableViewCell: UITableViewCell {
    var delegate : DetailsTitleTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var backBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        if(Utils.getcurrentLanguage() == "ar"){
            backBtn.setImage(UIImage(named: "arrow-right"), for: .normal)
        }else{
             backBtn.setImage(UIImage(named: "arrow-left"), for: .normal)
        }
    }

    @IBAction func backPressed(_ sender: Any) {
        self.delegate?.dismissView()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
