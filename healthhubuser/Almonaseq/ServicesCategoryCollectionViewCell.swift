//
//  ServicesCategoryCollectionViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 9/13/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class ServicesCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCategoryName: UIView!
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        //categoryName.setBoldFont();
        categoryName.font = UIFont(name: Constants.boldFont, size: 12);
        self.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
        self.layer.borderWidth = 1.0;
              self.layer.borderColor = Constants.Grey_BORDER_COLOR;
       self.layer.cornerRadius = 10;
        
        
        self.categoryIcon.clipsToBounds = true;
        //self.categoryIcon.layer.borderWidth = 2.0;
        //self.categoryIcon.layer.borderColor = Constants.Grey_BORDER_COLOR;
        //viewCategoryName.layer.cornerRadius = 15;
        
        
    }

    
    func configureCell(category: Category) {
        let currentLanguage = Utils.getcurrentLanguage()
        if currentLanguage == "en" {
            categoryName.text = category.englishName
        } else {
            categoryName.text = category.name
        }
        
        //        categoryIcon.image = UIImage(named: "service_\(category.id)")
        categoryIcon.sd_setImage(with: URL(string: category.image), placeholderImage: UIImage(named: "colored_logo"))
        
    }
    
    func configureStoreCell(store: Store) {
        let currentLanguage = Utils.getcurrentLanguage()
        if currentLanguage == "en" {
            categoryName.text = store.englishName
        } else {
            categoryName.text = store.name
        }
        
        
        categoryIcon.sd_setImage(with: URL(string: store.image), placeholderImage: UIImage(named: "colored_logo"))
    }

}
