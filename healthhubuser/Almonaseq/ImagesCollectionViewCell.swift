//
//  ImagesCollectionViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 3/16/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import UIKit
import SDWebImage
import FSPagerView


class ImagesCollectionViewCell: FSPagerViewCell {
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var bigView: UIView!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        bigView.layer.shadowRadius = 0;
        bigView.layer.cornerRadius = 15;
        bigView.layer.shadowColor = UIColor.clear.cgColor ;
        bigView.layer.shadowOpacity = 0.0 ;
        bigView.layer.shadowOffset = .zero;
       // bigView.layer.shouldRasterize = true

       // bigView.layer.rasterizationScale = UIScreen.main.scale;

        
    }
    
    func configureCell(imageStr : String){
        var imgUrl = URL(string: imageStr)
        cellImageView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "colored_logo"));
        cellImageView.contentMode = .scaleAspectFit;

        //cellImageView.layer.masksToBounds = true;
        cellImageView.clipsToBounds = true
        cellImageView.contentMode = .scaleAspectFit;
        cellImageView.layer.cornerRadius = 15;
        
    }

}
