//
//  RepairWaitingOrderTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 13/03/2021.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import CoreLocation

class RepairWaitingOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var serviceTitleLbl: UILabel!
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var cityTitleLbl: UILabel!
    
    @IBOutlet weak var priceTitleLbl: UILabel!
    
    @IBOutlet weak var cancelTitleLbl: UIButton!
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
    @IBOutlet weak var orderTimeLabel: UILabel!
    var delegate : WaitingDetailsTableViewCellDelegate?
    
    @IBOutlet weak var providerView: UIView!
    
    var selectedRequest: Request?
    var filter = RequestFilter.waited;
    var translatedTitles = [String: String]()
    var address = ""
    var requestType = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func initView(){
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
            "Cancel The Technician" :  NSLocalizedString("orders.cancelTechnician", comment: ""),
            "Select The Technician" :  NSLocalizedString("orders.accept", comment: ""),
            "Cancel Order" :  NSLocalizedString("orders.cancelOrder", comment: ""),"canceled" : NSLocalizedString("order.canceled", comment: "")]
        
        
        cancelBtn.layer.cornerRadius = 10
        selectTechBtn.layer.cornerRadius = 10
        if(filter == RequestFilter.waited){
            self.providerView.isHidden = true
            stackTopConstarint.constant = 10
        }
        else{
            self.providerView.isHidden = false
            stackTopConstarint.constant = 100
        }
        
        if(L102Language.currentAppleLanguage() == "ar"){
            serviceTitleLbl.text = "نوع الخدمة:"
            
            cityTitleLbl.text = "المدينة: "
            
            priceTitleLbl.text = "التكلفة:"
            
            cancelTitleLbl.setTitle("إلغاء", for: .normal)
            descTitleLbl.text = "الوصف:"
        }else{
            serviceTitleLbl.text = "Service Type"
            
            cityTitleLbl.text = "city: "
            
            priceTitleLbl.text = "Price: "
            
            cancelTitleLbl.setTitle("Cancel", for: .normal)
            descTitleLbl.text = "desc:"
        }
        
    }
    func configureCell(request: Request) {
        self.selectedRequest = request
        if(selectedRequest?.status  == 1){
            orderStatus.setTitle(translatedTitles["awaiting"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
            selectTechBtn.setTitle(translatedTitles["Select The Technician"], for: .normal)
            stackTopConstarint.constant = 10
            providerView.isHidden = true
            
            
        }else if(selectedRequest?.status  == 2){
            orderStatus.setTitle(translatedTitles["pending"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
            selectTechBtn.setTitle(translatedTitles["rate"], for: .normal)
            selectTechBtn.isHidden = false
            stackTopConstarint.constant = 100
            self.providerView.isHidden = false
            proiderNameLabel.text = request.userName
            providerJobLabel.text = request.userPhone
            cancelBtn.isHidden = true

            
            
            
        }
        
        else if(request.status == 3){
            //انتهي التنفيذ
            orderStatus.setTitle(translatedTitles["canceled"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
            selectTechBtn.isHidden = false
            cancelBtn.isHidden = true
            selectTechBtn.setTitle(translatedTitles["rate"], for: .normal)
            self.providerView.isHidden = false
            stackTopConstarint.constant = 100
            proiderNameLabel.text = request.userName
            providerJobLabel.text = request.userPhone
        }
        orderTimeLabel.text = request.serviceTime + "   -   " + request.serviceDay
        orderServicesLabel.text = request.main_cat ;
        orderServicesTypeLabel.text =  request.subCat;
        descLbl.text = request.desc ?? ""
        //        if(request.lat !=  "" || request.lng != ""){
        //            latLong(lat: Double(request.lat) as! Double, long:  Double(request.lng)  as! Double);
        //            orderCityLabel.text =  request.city //self.address;
        //        }
        //        else{
        if(L102Language.currentAppleLanguage() == "ar"){
            orderCityLabel.text = request.cityAr;

        }else{
            orderCityLabel.text = request.cityEN;

        }
        //}
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
    
    @IBAction func selectTech(_ sender: Any) {
        if(selectedRequest?.status == 1){
            delegate?.chooseTech(request: selectedRequest!)
        }
        else{
            delegate?.rateTech(request: selectedRequest!)
        }
    }
    
    
    @IBAction func cancelOrder(_ sender: Any) {
        delegate?.canelOrder(request: selectedRequest!)
    }
    
}
