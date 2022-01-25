//
//  RepairHomeServicesCollectionViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 1/23/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class RepairHomeServicesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var RoundedView: UIView!
    
    @IBOutlet weak var serviceImageView: UIImageView!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        RoundedView.layer.cornerRadius = RoundedView.frame.size.width/2
        RoundedView.clipsToBounds = true
        RoundedView.layer.borderColor = UIColor(red: 65/255, green: 46/255, blue: 170/255, alpha: 1.0).cgColor
        RoundedView.layer.borderWidth = 5.0
    }
    
    func configureCell(category: Category) {
              let currentLanguage = Utils.getcurrentLanguage()
              if currentLanguage == "en" {
                  serviceLabel.text = category.englishName
              } else {
                  serviceLabel.text = category.name
              }
              
              //        categoryIcon.image = UIImage(named: "service_\(category.id)")
              serviceImageView.sd_setImage(with: URL(string: category.image), placeholderImage: UIImage(named: "logo-r"))
              
          }

}
