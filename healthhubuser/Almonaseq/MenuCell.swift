//
//  MenuCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/15/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
  @IBOutlet weak var checkNotifImageView: UIImageView!
    @IBOutlet weak var menuItemIcon: UIImageView!
    @IBOutlet weak var menuItemTitle: UILabel!
    
    @IBOutlet weak var expandImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(showExistNotif : Bool , menu: Menu) {
        menuItemTitle.text =  menu.name
        menuItemIcon.image = UIImage(named: menu.icon)
         self.expandImageView.isHidden = true;
       // menuItemIcon.setMainColoredImage(name: menu.icon)

//        if(menu.id == "5") {
//            self.expandImageView.isHidden = false;
//        }else{
//            self.expandImageView.isHidden = true;
//
//        }
//        if(menu.id == "2" && showExistNotif == true){
//            self.checkNotifImageView.isHidden = false;
//        }else{
//            self.checkNotifImageView.isHidden = true;
//            
//        }
     
    }
    
}
