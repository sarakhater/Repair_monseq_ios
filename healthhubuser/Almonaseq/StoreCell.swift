//
//  StoreCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 1/18/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit

class StoreCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var storeImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.storeImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.storeImage)
        
        self.addConstraint(NSLayoutConstraint(item: self.storeImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.storeImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.storeImage, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.storeImage, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeItCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeItCircle() {
        self.storeImage.layer.masksToBounds = true
        self.storeImage.layer.cornerRadius  = CGFloat(roundf(Float(self.storeImage.frame.size.width/2.0)))
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        UIView.circularView(view: storeImage)
    }
    
   
    
    func configureCell(store: Store) {
        let currentLanguage = Utils.getcurrentLanguage()
        if currentLanguage == "en" {
            name.text = store.englishName
        } else {
            name.text = store.name
        }
        
       
    storeImage.sd_setImage(with: URL(string: store.image), placeholderImage: UIImage(named: "colored_logo"))
    }

}
