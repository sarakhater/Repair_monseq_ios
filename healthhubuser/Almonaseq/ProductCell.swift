//
//  ProductCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 1/19/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var storeLabel: UILabel!
    
    @IBOutlet weak var descLabvel: UILabel!
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var storeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIView.roundView(view: card, radius: 8)
       
            self.card.layer.borderWidth = 1.0;
        card.layer.borderColor = Constants.BORDER_COLOR;
    }
    
    func configureCell(product: Product) {
        let currentLanguage = Utils.getcurrentLanguage()
        if currentLanguage == "en" {
            nameLabel.text = "Name:"
               storeLabel.text = "StoreName:"
               descLabvel.text = "Description:"
            name.text = product.englishName
            storeName.text = product.storeNameEn
            desc.text = product.descEn
        } else {
            nameLabel.text = "اسم المنتج :"
            storeLabel.text = "اسم المتجر :"
            descLabvel.text = " الوصف :"
            name.text = product.name
            storeName.text = product.storeNameAr
            desc.text = product.descAr
        }
        
        price.text = product.price
         productImage.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "colored_logo"))
    }

}
