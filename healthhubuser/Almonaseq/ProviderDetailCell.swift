//
//  ProviderDetailCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/15/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class ProviderDetailCell: UITableViewCell {
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rating: SwiftyStarRatingView!
    @IBOutlet weak var providerDescription: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bookService(_ sender: Any) {
    }
    
    func configureCell(provider: Provider) {
        price.text = "\(provider.price)"
        rating.value = CGFloat(provider.rating)
        providerDescription.text = provider.providerDescription
        reviews.text = "\(provider.comments) comments"
        providerName.text = provider.englishName
        providerImage.image = UIImage(named: provider.imageUrl)
    }
}
