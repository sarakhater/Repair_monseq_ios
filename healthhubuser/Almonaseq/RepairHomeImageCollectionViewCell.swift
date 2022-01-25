//
//  RepairHomeImageCollectionViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 1/25/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class RepairHomeImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var toolsImageView: UIImageView!
    
    @IBOutlet weak var toolsLabel: UILabel!
    
    @IBOutlet weak var labelView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        toolsImageView.layer.cornerRadius  = 10
        toolsImageView.layer.borderColor = Constants.MainColor.cgColor
        toolsImageView.layer.borderWidth = 1
        labelView.layer.cornerRadius  = 7
    }
    
    func configureCell(imageSlider: ImageSlider) {
        let currentLanguage = Utils.getcurrentLanguage()
        if currentLanguage == "en" {
            toolsLabel.text = imageSlider.title_en
        } else {
            toolsLabel.text = imageSlider.title_ar
        }
        toolsImageView.sd_setImage(with: URL(string: imageSlider.image), placeholderImage: UIImage(named: "logo-r"))
        
    }

}
