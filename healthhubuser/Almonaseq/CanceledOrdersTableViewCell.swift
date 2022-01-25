//
//  CanceledOrdersTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 9/25/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
import CoreLocation

class CanceledOrdersTableViewCell: UITableViewCell {
    
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
    
    
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var descTitle: UILabel!

    
    @IBOutlet weak var showMapBtn: UIButton!
    
    
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var calender_icon: UIImageView!
      
      @IBOutlet weak var time_icon: UIImageView!
      
      @IBOutlet weak var map_icon: UIButton!
      
      @IBOutlet weak var orderNo_icon: UIImageView!
    
    var address = "";

    
    func latLong(lat: Double,long: Double) {
        var add_street : String = "" , add_city : String = "" , add_country : String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
          
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                print("Country :- \(country)")
                add_country = country ;
                // City
                if let city = placeMark.addressDictionary!["City"] as? String {
                    print("City :- \(city)")
                    add_city =  city;
                    // State
                    if let state = placeMark.addressDictionary!["State"] as? String{
                        print("State :- \(state)")

                        // Street
                        if let street = placeMark.addressDictionary!["Street"] as? String{
                            print("Street :- \(street)")
                           add_street =   street;

                            let str = street
                            let streetNumber = str.components(
                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                            print("streetNumber :- \(streetNumber)" as Any)

                            // ZIP
                            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                                print("ZIP :- \(zip)")
                                // Location name
                                if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                                    print("Location Name :- \(locationName)")
                                    // Street address
                                    if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
                                    print("Thoroughfare :- \(thoroughfare)")

                                    }
                                }
                            }
                        }
                    }
                }
              
            }
            self.address =  add_street + "," + add_city + "," + add_country;
            if(self.address == ""){
                self.address_label.text =  self.selectedRequest?.address;
            }else{
                  self.address_label.text =  self.address;
            }
                   

        })
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        calender_icon.setMainColoredImage(name: "order_calender_icon");
                      
        time_icon.setMainColoredImage(name: "order_time_icon");
                      
        map_icon.setMainColoredButton(name: "order_loc_icon");
                      
         orderNo_icon.setMainColoredImage(name: "order_orderno_icon");
        
        var btnTitle = "Show On Map"

            if(Utils.getcurrentLanguage() == "ar"){
                btnTitle = "أظهر علي الخريطة"
                   }
            let attrs = [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13.0),
                NSAttributedStringKey.foregroundColor : UIColor.black ,
                NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]

            let attributedString = NSMutableAttributedString(string: "" )
              let buttonTitleStr = NSMutableAttributedString(string: btnTitle, attributes:attrs)
            attributedString.append(buttonTitleStr)
            showMapBtn.setAttributedTitle(attributedString, for: .normal);
        
           
        statusView.layer.cornerRadius = 25;
        statusView.layer.borderWidth = 2.0;
        self.statusView.layer.borderColor = Constants.BORDER_COLOR;
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
        desc.text = request.desc
        status.text = translatedTitles["canceled"];

      if(request.lat !=  "" || request.lng != ""){
              latLong(lat: Double(request.lat) as! Double, long:  Double(request.lng)  as! Double);
                     address_label.text = self.address;
              }
              else{
                    address_label.text = request.address;
              }
        
        if(request.price  != "0" && request.price  != "" ){
               if(Utils.getcurrentLanguage() == "ar"){
                   servicePrice.text = " تكلفة الخدمة : " + request.price;
                   
               }else{
                   servicePrice.text = "Service Price: " + request.price;
               }
               }else{
                   servicePrice.isHidden = true;
               }
        serviceTime.text = request.serviceTime;
        order_no_label.text = request.id;
        serviceDay.text = request.serviceDay;
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
