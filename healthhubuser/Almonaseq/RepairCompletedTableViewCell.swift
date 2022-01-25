//
//  RepairCompletedTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 13/03/2021.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import CoreLocation

class RepairCompletedTableViewCell: UITableViewCell {
    @IBOutlet weak var descTitleLbl: UILabel!
  
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var serviceTitleLbl: UILabel!
    
    @IBOutlet weak var cityTitleLbl: UILabel!
    
    @IBOutlet weak var priceTitleLbl: UILabel!
    
    
    var delegate : WaitingDetailsTableViewCellDelegate?
    @IBOutlet weak var stackTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var orderServicesLabel: UILabel!
    @IBOutlet weak var orderServicesTypeLabel: UILabel!
    @IBOutlet weak var orderCityLabel: UILabel!
    @IBOutlet weak var orderCPriceLabel: UILabel!
    @IBOutlet weak var orderStatus: UIButton!
    @IBOutlet weak var editRateBtn: UIButton!
    @IBOutlet weak var rateView: SwiftyStarRatingView!
    @IBOutlet weak var providerRateLabel: UILabel!
    @IBOutlet weak var proiderNameLabel: UILabel!
    @IBOutlet weak var providerJobLabel: UILabel!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var providerView: UIView!
    @IBOutlet weak var orderTimeLabel: UILabel!

    var selectedRequest: Request?
    var filter = RequestFilter.waited;
    var translatedTitles = [String: String]()
    var address = ""
    
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
        editRateBtn.layer.cornerRadius = 10
        if(L102Language.currentAppleLanguage() == "ar"){
            serviceTitleLbl.text = "نوع الخدمة:"
            
            cityTitleLbl.text = "المدينة: "
        
            priceTitleLbl.text = "التكلفة:"
            
            editRateBtn.setTitle("أضف تقييم", for: .normal)
            orderStatus.setTitle("مكتمل", for: .normal)
            descTitleLbl.text = "الوصف:"
        }else{
            serviceTitleLbl.text = "Service Type"
            
            cityTitleLbl.text = "city: "
        
            priceTitleLbl.text = "Price: "
            descTitleLbl.text = "desc:"
            
            editRateBtn.setTitle("Add Review", for: .normal)
            orderStatus.setTitle("Completed", for: .normal)
        }
     
       
    }
    
    
    @IBAction func editRatePressed(_ sender: UIButton) {
        delegate?.rateTech(request: selectedRequest!)
    }
    
    func configureCell(request: Request) {
        self.selectedRequest = request
        
        orderServicesLabel.text = request.main_cat ;
        orderServicesTypeLabel.text =  request.subCat;
//        if(request.lat !=  "" || request.lng != ""){
//            latLong(lat: Double(request.lat) as! Double, long:  Double(request.lng)  as! Double);
//            orderCityLabel.text = self.address;
//        }
       // else{
        if(L102Language.currentAppleLanguage() == "ar"){
            orderCityLabel.text = request.cityAr;

        }else{
            orderCityLabel.text = request.cityEN;

        }
       // }
//        if(request.feedBack == "false"){
//            self.editRateBtn.isHidden = false
//        }else{
//            self.editRateBtn.isHidden = true
//        }
        orderCPriceLabel.text = request.price;
        orderTimeLabel.text = request.serviceTime + "   -   " + request.serviceDay
        providerJobLabel.text = request.userPhone
        proiderNameLabel.text = request.userName
        providerRateLabel.text = "4/5" //request.rate
        descLbl.text = request.desc ?? ""

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
