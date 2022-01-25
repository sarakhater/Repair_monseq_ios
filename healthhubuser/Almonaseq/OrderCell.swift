//
//  OrderCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 2/26/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import SDWebImage

protocol OrderCellDelegate: class {
    func didPressActionButton(sender: Any, request: Request)
    func didPressViewImage(sender: Any, request: Request)
    func didPressMapButton(sender: Any, request: Request)
    func didPressCancelOrderButton(sender :Any ,  request: Request)
    func didPressDeleteOrderButton(sender :Any ,  request: Request)

}

class OrderCell: UITableViewCell {
    var selectedRequest: Request?
    var delegate: OrderCellDelegate!
    var translatedTitles = [String: String]()
    @IBOutlet weak var serviceDay: UILabel!
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var providerMobile: UILabel!
    
    @IBOutlet weak var cancelOrder: UIButton! // delete order
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var orderImage: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
   // @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var smsButton: UIButton!
    
   // @IBOutlet weak var whatsAppButton: UIButton!
    
    @IBOutlet weak var cancelTechnician: UIButton! //delete technician
    
    @IBOutlet weak var mobile_label: UILabel!
    
    @IBOutlet weak var provider_info_label: UILabel!
    
    @IBOutlet weak var provider_info_stackview: UIStackView!
    
    @IBOutlet weak var order_no_label: UILabel!
    
    var filter = RequestFilter.waited;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewImage(_:)))
//        requestImage.addGestureRecognizer(tapGestureRecognizer)
        translatedTitles = [
            "awaiting": NSLocalizedString("orders.awaitingApproval", comment: ""),
            "accept": NSLocalizedString("orders.accept", comment: ""),
            "pending": NSLocalizedString("orders.pending", comment: ""),
            "rate": NSLocalizedString("orders.addRate", comment: ""),
            "completed": NSLocalizedString("orders.completed", comment: ""),
            "Cancel The Technician" :  NSLocalizedString("orders.cancelTechnician", comment: ""),
             "Cancel Order" :  NSLocalizedString("orders.cancelOrder", comment: "")
        ]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(request: Request) {
        self.selectedRequest = request
        desc.text = request.desc
        serviceTime.text = request.serviceTime;
        order_no_label.text = request.id;
        serviceDay.text = request.serviceDay
        providerName.text = request.userName
        providerMobile.text = request.userPhone
        orderImage.sd_setBackgroundImage(with: URL(string: request.image), for: .normal, placeholderImage: UIImage(named: "colored_logo"), options: [.continueInBackground, .progressiveDownload]);
        orderImage.layer.borderWidth = 1.5;
        orderImage.layer.borderColor = Constants.SencondColor.cgColor;
        //ervicesImage.layer.cornerRadius = 15;
        orderImage.layer.masksToBounds = true
        self.orderImage.layer.cornerRadius = self.orderImage.frame.size.width / 2;
        self.orderImage.clipsToBounds = true;
//        if(filter == RequestFilter.waited){
//            smsButton.isHidden = true;
//            status.text = translatedTitles["awaiting"]
//            actionButton.setTitle(translatedTitles["accept"], for: .normal)
//            actionButton.isHidden = false
//            provider_info_label.isHidden = true;
//            provider_info_stackview.isHidden = true;
//            cancelTechnician.isHidden = true;
//            cancelOrder.isHidden = true;
//            
//        }
        switch request.status {
            
        case 1:
            smsButton.isHidden = true;
            status.text = translatedTitles["awaiting"]
            actionButton.setTitle(translatedTitles["accept"], for: .normal)
            actionButton.isHidden = false
            provider_info_label.isHidden = true;
            provider_info_stackview.isHidden = true;
            cancelTechnician.isHidden = true;
            //cancelOrder.isHidden = false;
            cancelOrder.setTitle(translatedTitles["Cancel Order"], for: .normal)
        
        case 2:
            // Pending
            // Go to tech accept page
             smsButton.isHidden = false;
             //whatsAppButton.isHidden = true;
            status.text = translatedTitles["pending"]
            cancelTechnician.setTitle(translatedTitles["Cancel The Technician"], for: .normal)
            cancelTechnician.isHidden = false;
            actionButton.setTitle(translatedTitles["rate"], for: .normal)
            if(request.feedBack == "false"){
                //there is comment
                actionButton.isHidden = true
                
                
            }else if(request.feedBack == "true"){
                //there isn't comment
                actionButton.isHidden = false
                
                
            }
            cancelOrder.isHidden = false;
            cancelOrder.setTitle(translatedTitles["Cancel Order"], for: .normal)
            
            //whatsAppButton.isHidden = false;
            //phoneButton.isHidden = false;
            smsButton.isHidden = false;

        case 3:
            // completed
            // Go to review page
             smsButton.isHidden = false;
            // whatsAppButton.isHidden = true;

            status.text = translatedTitles["completed"]
            provider_info_label.isHidden = false;
            provider_info_stackview.isHidden = false;
            actionButton.setTitle(translatedTitles["rate"], for: .normal)
            if(request.feedBack == "false"){
                //there is comment
                actionButton.isHidden = true

                
            }else if(request.feedBack == "true"){
                //there isn't comment
                actionButton.isHidden = false

                
            }
            cancelTechnician.isHidden = true;
            cancelOrder.isHidden = true;
            //whatsAppButton.isHidden = true;
            //phoneButton.isHidden = true;
            smsButton.isHidden = true;
            providerMobile.isHidden = true;
            mobile_label.isHidden = true;
            

        default:
            //case 4
            smsButton.isHidden = true
           status.text =  translatedTitles["completed"]
           actionButton.isHidden = true
           cancelTechnician.isHidden = true;
           cancelOrder.isHidden = true;
           //whatsAppButton.isHidden = true;
          // phoneButton.isHidden = true;
           smsButton.isHidden = true;
           providerMobile.isHidden = true;
           mobile_label.isHidden = true;


        }
        
       
    }
    
    @IBAction func requestAction(_ sender: Any) {
        delegate.didPressActionButton(sender: sender, request: selectedRequest!)
    }
    
    
    @IBAction func cancelOrderAction(_ sender: Any) {
        delegate.didPressDeleteOrderButton(sender: sender, request: selectedRequest!);

    }
    
    @IBAction func cancelTechnicianAction(_ sender: Any) {
        delegate.didPressCancelOrderButton(sender: sender, request: selectedRequest!);

    }
    func onViewImage(_ gesture:UITapGestureRecognizer) {
        print("image selected")
        delegate.didPressViewImage(sender: self, request: selectedRequest!)
    }
    @IBAction func viewImage(_ sender: Any) {
        delegate.didPressViewImage(sender: sender, request: selectedRequest!)
    }
    
    @IBAction func openMap(_ sender: Any) {
        delegate.didPressMapButton(sender: sender, request: selectedRequest!)
    }
}
