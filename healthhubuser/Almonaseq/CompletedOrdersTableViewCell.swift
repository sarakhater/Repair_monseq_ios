//
//  CompletedOrdersTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 9/25/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit

class CompletedOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusView: UIView!
    var selectedRequest: Request?
    var delegate: OrderCellDelegate!
    var translatedTitles = [String: String]()
    @IBOutlet weak var serviceDay: UILabel!
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var order_no_label: UILabel!
    @IBOutlet weak var orderImage : UIButton!
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var provider_info_label : UILabel!
    @IBOutlet weak var providerNameLabel: UILabel!
    
    
    @IBOutlet weak var serviceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = 25;
        statusView.layer.borderWidth = 2.0;
        self.statusView.layer.borderColor = Constants.BORDER_COLOR;
        provider_info_label.layer.cornerRadius = 13;
        provider_info_label.layer.borderWidth = 2.0;
        self.provider_info_label.layer.borderColor = Constants.BORDER_COLOR;
        translatedTitles = [
            "awaiting": NSLocalizedString("orders.awaitingApproval", comment: ""),
            "accept": NSLocalizedString("orders.accept", comment: ""),
            "pending": NSLocalizedString("orders.pending", comment: ""),
            "rate": NSLocalizedString("orders.addRate", comment: ""),
            "completed": NSLocalizedString("orders.completed", comment: ""),
            "Cancel The Technician" :  NSLocalizedString("orders.cancelTechnician", comment: ""),
            "Cancel Order" :  NSLocalizedString("orders.cancelOrder", comment: ""),"canceled" : NSLocalizedString("order.canceled", comment: "")
        ]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(request: Request) {
        self.selectedRequest = request
        status.text = translatedTitles["completed"];
        desc.text = request.desc
        address_label.text = request.address;
        serviceTime.text = request.serviceTime;
        order_no_label.text = request.id;
        serviceDay.text = request.serviceDay
        providerNameLabel.text = request.userName;
        serviceLabel.text = request.main_cat +  "-" + request.subCat;

         orderImage.sd_setBackgroundImage(with: URL(string: request.image), for: .normal, placeholderImage: UIImage(named: "colored_logo"), options: [.continueInBackground, .progressiveDownload]);
              orderImage.layer.borderWidth = 1.5;
              orderImage.layer.borderColor = Constants.SencondColor.cgColor;
              //ervicesImage.layer.cornerRadius = 15;
              orderImage.layer.masksToBounds = true
              self.orderImage.layer.cornerRadius = self.orderImage.frame.size.width / 2;
              self.orderImage.clipsToBounds = true;
    }
    @IBAction func viewImage(_ sender: Any) {
        delegate.didPressViewImage(sender: sender, request: selectedRequest!)
    }
    
    @IBAction func openMap(_ sender: Any) {
        delegate.didPressMapButton(sender: sender, request: selectedRequest!)
    }
    
}
