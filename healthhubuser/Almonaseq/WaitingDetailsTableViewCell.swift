//
//  WaitingDetailsTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 2/5/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import CoreLocation

protocol WaitingDetailsTableViewCellDelegate {
    func cancelTech(request : Request)
    func canelOrder(request: Request)
    func chooseTech(request : Request)
    func rateTech(request : Request)
}

class WaitingDetailsTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var stackTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var orderServicesLabel: UILabel!
    @IBOutlet weak var orderServicesTypeLabel: UILabel!
    @IBOutlet weak var orderCityLabel: UILabel!
    @IBOutlet weak var orderCPriceLabel: UILabel!
    @IBOutlet weak var orderStatus: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var selectTechBtn: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var proiderNameLabel: UILabel!
    @IBOutlet weak var providerJobLabel: UILabel!
    @IBOutlet weak var providerImageView: UIImageView!
    
    @IBOutlet weak var providerView: UIView!
    
    var selectedRequest: Request?
    var filter = RequestFilter.waited;
    var translatedTitles = [String: String]()
    var address = ""
    var delegate : WaitingDetailsTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.isUserInteractionEnabled = false
        bigView.layer.cornerRadius = 10
        bigView.layer.borderWidth = 1
        bigView.layer.borderColor = UIColor(red: 194/255 , green: 194/255, blue:194/255 , alpha: 1.0).cgColor
        
        providerView.layer.cornerRadius = 10
        providerView.layer.borderWidth = 1
        providerView.layer.borderColor = UIColor(red: 194/255 , green: 194/255, blue:194/255 , alpha: 1.0).cgColor
        
        orderStatus.layer.cornerRadius = 5
        orderImageView.layer.cornerRadius = 5
        orderImageView.layer.borderWidth = 1
        orderImageView.layer.borderColor = UIColor(red: 112/255 , green: 112/255, blue:112/255 , alpha: 1.0).cgColor
        translatedTitles = [
            "awaiting": NSLocalizedString("orders.awaitingApproval", comment: ""),
            "accept": NSLocalizedString("orders.accept", comment: ""),
            "pending": NSLocalizedString("orders.pending", comment: ""),
            "rate": NSLocalizedString("orders.addRate", comment: ""),
            "completed": NSLocalizedString("orders.completed", comment: ""),
            "executionFinished":NSLocalizedString("orders.executionFinished", comment: ""),
            "Cancel The Technician" :  NSLocalizedString("orders.cancelTechnician", comment: ""),
            "Select The Technician" :  NSLocalizedString("orders.accept", comment: ""),
            "Cancel Order" :  NSLocalizedString("orders.cancelOrder", comment: ""),"canceled" : NSLocalizedString("order.canceled", comment: "")]
        
        
        cancelBtn.layer.cornerRadius = 10
        selectTechBtn.layer.cornerRadius = 10
        self.bringSubview(toFront: cancelBtn)
        if(filter == RequestFilter.waited){
            self.providerView.isHidden = true
            stackTopConstarint.constant = 10
        }
        else{
            self.providerView.isHidden = false
            stackTopConstarint.constant = 85
        }
        
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        print("cancelllllllllllll")
        delegate?.canelOrder(request: selectedRequest!)
    }
    @IBAction func selectOrCancelTech(_ sender: Any) {
        if(filter == .waited){
            delegate?.chooseTech(request: selectedRequest!)
        } else if(filter == .underProcessing){
            delegate?.cancelTech(request: selectedRequest!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(request: Request) {
        self.selectedRequest = request
        if(filter == .waited){
            orderStatus.setTitle(translatedTitles["awaiting"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 137/255, alpha: 1.0)
            selectTechBtn.setTitle(translatedTitles["Select The Technician"], for: .normal)
            
            
        }else if(filter == .underProcessing){
            orderStatus.setTitle(translatedTitles["pending"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 137/255, alpha: 1.0)
            selectTechBtn.setTitle(translatedTitles["Cancel The Technician"], for: .normal)
            
            
        }
        else if(filter == .completed){
            orderStatus.setTitle(translatedTitles["executionFinished"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 137/255, alpha: 1.0)
            //selectTechBtn.setTitle(translatedTitles["Cancel The Technician"], for: .normal)
        }
        orderServicesLabel.text = request.main_cat ;
        orderServicesTypeLabel.text =  request.subCat;
        if(request.lat !=  "" || request.lng != ""){
            latLong(lat: Double(request.lat) as! Double, long:  Double(request.lng)  as! Double);
            orderCityLabel.text = self.address;
        }
        else{
            orderCityLabel.text = request.address;
        }
        orderCPriceLabel.text = request.price;
    }
    
    
    func latLong(lat: Double,long: Double) {
        var add_street : String = "" , add_city : String = "" , add_country : String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Country
            if(placeMark != nil){
                if let country = placeMark.addressDictionary!["Country"] as? String {
                    print("Country :- \(country)")
                    add_country = country ;
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? String {
                        print("City :- \(city)")
                        add_city =  city;
                        
                    }
                    
                }
                self.address = add_city + "," + add_country;
                if(self.address == ""){
                    self.orderCityLabel.text =  self.selectedRequest?.address;
                }else{
                    self.orderCityLabel.text =  self.address;
                }
            }//place mark != nil
            
            
        })
        
    }
    
    
}
