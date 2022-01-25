//
//  ReviewCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/15/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
class ReviewCell: UITableViewCell {

    @IBOutlet weak var reviewDetails: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var rating: SwiftyStarRatingView!
    @IBOutlet weak var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(review: Review) {
        
    }
    
}
