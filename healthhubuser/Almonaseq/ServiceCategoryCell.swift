//
//  ServiceCategoryCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/14/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SDWebImage



class ServiceCategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(category: Category) {
        let currentLanguage = Utils.getcurrentLanguage()
        if currentLanguage == "en" {
            categoryName.text = category.englishName
        } else {
            categoryName.text = category.name
        }
        
//        categoryIcon.image = UIImage(named: "service_\(category.id)")
        categoryIcon.sd_setImage(with: URL(string: category.image), placeholderImage: UIImage(named: "service_1"));


    }
}
