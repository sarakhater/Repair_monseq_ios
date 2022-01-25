//
//  ServicesCollectionViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 3/13/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var servicesImage: UIImageView!
    
    @IBOutlet weak var nameView: UIView!
    
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var serviceName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bigView.layer.cornerRadius = 8;
        
        
        //servicesImage.layer.borderWidth = 1.5;
        //servicesImage.layer.borderColor = Constants.MainColor.cgColor;
        //ervicesImage.layer.cornerRadius = 15;
       // servicesImage.layer.masksToBounds = true
       //self.servicesImage.layer.cornerRadius = self.servicesImage.frame.size.width / 2;
        //self.servicesImage.clipsToBounds = true;
        
    }
    
    func configureCell(category: Category) {
           let currentLanguage = Utils.getcurrentLanguage()
           if currentLanguage == "en" {
               serviceName.text = category.englishName
           } else {
               serviceName.text = category.name
           }
           
           //        categoryIcon.image = UIImage(named: "service_\(category.id)")
           servicesImage.sd_setImage(with: URL(string: category.image), placeholderImage: UIImage(named: "colored_logo"))
           
       }
       
       
}
