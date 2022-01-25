//
//  NewWaitingTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 2/2/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class NewWaitingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var bigView: UIView!
    
    @IBOutlet weak var orderImageView: UIImageView!
    
    @IBOutlet weak var descBtn: UIButton!
    @IBOutlet weak var orderTitleLabel: UILabel!
    
    @IBOutlet weak var orderServicesLabel: UILabel!
    
    @IBOutlet weak var orderTimeLabel: UILabel!
    
    @IBOutlet weak var orderStatus: UIButton!
    var selectedRequest: Request?
    var translatedTitles = [String: String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.layer.cornerRadius = 10
        bigView.layer.borderWidth = 1
        bigView.layer.borderColor = UIColor(red: 194/255 , green: 194/255, blue:194/255 , alpha: 1.0).cgColor
        descBtn.layer.cornerRadius = 10
        orderStatus.layer.cornerRadius = 5
        orderImageView.layer.cornerRadius = 5
        orderImageView.layer.borderWidth = 1
        orderImageView.layer.borderColor = UIColor(red: 112/255 , green: 112/255, blue:112/255 , alpha: 1.0).cgColor
        if(L102Language.currentAppleLanguage() == "ar"){
            descBtn.setTitle("تفاصيل الطلب >", for: .normal)

        }else{
            descBtn.setTitle("< Order Description", for: .normal)
        }
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
        if(request.status == 1){
           orderStatus.setTitle(translatedTitles["awaiting"], for: .normal)
            self.orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
        }
        else if(request.status == 2){
            //قيذ التنفيذ
            orderStatus.setTitle(translatedTitles["pending"], for: .normal)
            self.orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)

        }
        else if(request.status == 3){
             //انتهي التنفيذ
            orderStatus.setTitle(translatedTitles["canceled"], for: .normal)
            self.orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)

        }
           orderServicesLabel.text = request.main_cat +  "-" + request.subCat;
        orderTimeLabel.text = request.serviceTime
        descLbl.text = request.desc
        
       }
    
}
