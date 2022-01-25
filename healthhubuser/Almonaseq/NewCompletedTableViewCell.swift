//
//  NewCompletedTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 2/2/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class NewCompletedTableViewCell: UITableViewCell {
    @IBOutlet weak var bigView: UIView!
    
    @IBOutlet weak var orderImageView: UIImageView!
    
    @IBOutlet weak var orderTitleLabel: UILabel!
    
    @IBOutlet weak var orderServicesLabel: UILabel!
    
    @IBOutlet weak var orderTimeLabel: UILabel!
    
    @IBOutlet weak var orderStatus: UIButton!
    
    @IBOutlet weak var providerView: UIView!
    
    @IBOutlet weak var providerImageView: UIImageView!
    
    @IBOutlet weak var providerNameLabel: UILabel!
    
    @IBOutlet weak var providerJobLabel: UILabel!
    
    @IBOutlet weak var providerRateLabel: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descBtn: UIButton!

    var selectedRequest: Request?
    var translatedTitles = [String: String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.layer.cornerRadius = 10
        bigView.layer.borderWidth = 1
        bigView.layer.borderColor = UIColor(red: 194/255 , green: 194/255, blue:194/255 , alpha: 1.0).cgColor
        descBtn.layer.cornerRadius = 10
        if(L102Language.currentAppleLanguage() == "ar"){
            descBtn.setTitle("تفاصيل الطلب >", for: .normal)

        }else{
            descBtn.setTitle("< Order Description", for: .normal)
        }
        orderStatus.layer.cornerRadius = 5
        orderImageView.layer.cornerRadius = 5
        orderImageView.layer.borderWidth = 1
        orderImageView.layer.borderColor = UIColor(red: 112/255 , green: 112/255, blue:112/255 , alpha: 1.0).cgColor
        
        providerView.layer.cornerRadius = 5
        providerView.layer.borderWidth = 1
        providerView.layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        
        providerImageView.clipsToBounds = true
        providerImageView.layer.borderColor = UIColor(red: 65/255, green: 46/255, blue: 170/255, alpha: 1.0).cgColor
        providerImageView.layer.masksToBounds = false
        providerImageView.layer.cornerRadius = providerImageView.frame.size.width / 2
        translatedTitles = [
            "awaiting": NSLocalizedString("orders.awaitingApproval", comment: ""),
            "accept": NSLocalizedString("orders.accept", comment: ""),
            "pending": NSLocalizedString("orders.pending", comment: ""),
            "rate": NSLocalizedString("orders.addRate", comment: ""),
            "completed": NSLocalizedString("orders.completed", comment: ""),
            "Cancel The Technician" :  NSLocalizedString("orders.cancelTechnician", comment: ""),
            "Cancel Order" :  NSLocalizedString("orders.cancelOrder", comment: ""),"canceled" : NSLocalizedString("order.canceled", comment: "")]
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(request: Request) {
        self.selectedRequest = request
        
        orderStatus.setTitle(translatedTitles["completed"], for: .normal)
        providerNameLabel.text = request.userName 
        orderTitleLabel.text =  request.main_cat 
        orderServicesLabel.text =  request.subCat 
        providerRateLabel.text =  "4/5"//request.rate
        providerNameLabel.text = request.userName 
        orderTimeLabel.text = request.serviceTime 
        providerJobLabel.text = request.userPhone 
        descriptionLbl.text = request.desc 
        
    }
    
}
