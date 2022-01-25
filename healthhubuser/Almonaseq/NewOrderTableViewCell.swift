//
//  NewOrderTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 9/16/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class NewOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var providerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var actionButtonConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var statusView: UIView!
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
    
    @IBOutlet weak var providerViewDetails: UIView!
     @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var smsButton: UIButton!
    
    // @IBOutlet weak var whatsAppButton: UIButton!
    
    @IBOutlet weak var cancelTechnician: UIButton! //delete technician
    
    @IBOutlet weak var mobile_label: UILabel!
    
    @IBOutlet weak var provider_info_label: UILabel!
    
    @IBOutlet weak var provider_info_stackview: UIStackView!
    
    @IBOutlet weak var order_no_label: UILabel!
    
    @IBOutlet weak var stackActionButtons: UIStackView!
    
    @IBOutlet weak var actionStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancelStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stackCancelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackCancelButtons: UIStackView!
    
    //@IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
   // @IBOutlet weak var providerBottomViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var address_label: UILabel!
    
    
       @IBOutlet weak var calender_icon: UIImageView!
       
       @IBOutlet weak var time_icon: UIImageView!
       
       @IBOutlet weak var map_icon: UIButton!
       
       @IBOutlet weak var orderNo_icon: UIImageView!
       
    @IBOutlet weak var showMapBtn: UIButton!
    
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var phone_icon: UIButton!
    var filter = RequestFilter.waited;

   // @IBOutlet weak var providerNameBotomConst: NSLayoutConstraint!
    
    @IBOutlet weak var serviceLable: UILabel!
    @IBOutlet weak var descTitle: UILabel!
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
                 
               phone_icon.setMainColoredButton(name: "icons8-phone-24");
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
           
              
        smsButton.layer.cornerRadius = 5;
        provider_info_label.layer.cornerRadius = 13;
        provider_info_label.layer.borderWidth = 2.0;
        self.provider_info_label.layer.borderColor = Constants.BORDER_COLOR;
        
        statusView.layer.cornerRadius = 25;
        statusView.layer.borderWidth = 2.0;
        self.statusView.layer.borderColor = Constants.BORDER_COLOR;
        cancelTechnician.layer.cornerRadius = 20;
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
        self.selectedRequest = request;
        if(request.lat !=  "" || request.lng != ""){
        latLong(lat: Double(request.lat) as! Double, long:  Double(request.lng)  as! Double);
               address_label.text = self.address;
        }
        else{
              address_label.text = request.address;
        }
        desc.text = request.desc
        serviceTime.text = request.serviceTime;
        order_no_label.text = request.id;
        serviceDay.text = request.serviceDay
        providerName.text = request.userName
        providerMobile.text = request.userPhone
        if(request.price  != "0" && request.price  != "" ){
               if(Utils.getcurrentLanguage() == "ar"){
                   servicePrice.text = " تكلفة الخدمة: " + request.price;
                   
               }else{
                   servicePrice.text = "Service Price: " + request.price;
               }
               }else{
                   servicePrice.isHidden = true;
               }
        
        serviceLable.text = request.main_cat +  "-" + request.subCat;
        orderImage.sd_setBackgroundImage(with: URL(string: request.image), for: .normal, placeholderImage: UIImage(named: ""), options: [.continueInBackground, .progressiveDownload])
        
        if(filter == RequestFilter.canceled){
            stackCancelConstraint.constant = 0; stackActionButtons.isHidden = true;
            actionStackHeight.constant = 0;
            cancelStackHeight.constant = 0 ;
            stackCancelButtons.isHidden = true;
            smsButton.isHidden = true
            providerViewHeight.constant = 0;
            status.text =  translatedTitles["canceled"]
            //bottomViewConstraint.constant = 0;
             provider_info_stackview.isHidden = true;
        }else{
        switch request.status {
        case 1:
            //waiting
            smsButton.isHidden = true;
            status.text = translatedTitles["awaiting"]
            actionButton.setTitle(translatedTitles["accept"], for: .normal)
            actionButton.isHidden = false
            provider_info_label.isHidden = true;
            actionButtonConstraintTop.constant = 0;
            providerViewHeight.constant = 0;
            provider_info_stackview.isHidden = true;
            cancelTechnician.isHidden = true;
            //cancelOrder.isHidden = false;
           // cancelOrder.setTitle(translatedTitles["Cancel Order"], for: .normal)
            providerViewDetails.isHidden = true;
            
            
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
                actionButton.isHidden = true;
            }else if(request.feedBack == "true"){
                //there isn't comment
                actionButton.isHidden = false
            }
            //cancelOrder.isHidden = false;
            //cancelOrder.setTitle(translatedTitles["Cancel Order"], for: .normal)
            
            //whatsAppButton.isHidden = false;
              phoneButton.isHidden = false;
             smsButton.isHidden = false;
            mobile_label.isHidden = false;

            
        case 3:
            // completed
            cancelOrder.isHidden = true;
             phoneButton.isHidden = true;
               status.text = translatedTitles["completed"]
             provider_info_label.isHidden = false;
             provider_info_stackview.isHidden = false;
             cancelTechnician.isHidden = true;
             providerMobile.isHidden = true;
             mobile_label.isHidden = true;
                 smsButton.isHidden = false;
             actionButton.setTitle(translatedTitles["rate"], for: .normal)
             if(request.feedBack == "false"){
                //there is comment
                actionButton.isHidden = true
                
                
             }else if(request.feedBack == "true"){
                //there isn't comment
                actionButton.isHidden = false
                
                
             }
            // Go to review page
        
            // whatsAppButton.isHidden = true;
           // providerNameBotomConst.constant = 1;
          
           // stackCancelConstraint.constant = 0; stackActionButtons.isHidden = true;
            //actionStackHeight.constant = 0;
            //cancelStackHeight.constant = 0 ;
            //stackCancelButtons.isHidden = true;
            //providerBottomViewConstraint.constant = 0;
           // cancelOrder.isHidden = true;
            //whatsAppButton.isHidden = true;
            //phoneButton.isHidden = true;
            //smsButton.isHidden = true;
           
            
            
        default:
            //case 4
            stackCancelConstraint.constant = 0; stackActionButtons.isHidden = true;
            //providerBottomViewConstraint.constant = 0;
            //providerNameBotomConst.constant = 1;
            actionStackHeight.constant = 0;
            cancelStackHeight.constant = 0 ;
            stackCancelButtons.isHidden = true;
            smsButton.isHidden = true
            status.text =  translatedTitles["completed"]
            actionButton.isHidden = true
            cancelTechnician.isHidden = true;
            //cancelOrder.isHidden = true;
            //whatsAppButton.isHidden = true;
            // phoneButton.isHidden = true;
           // smsButton.isHidden = true;
            providerMobile.isHidden = true;
            mobile_label.isHidden = true;
            
            
        }
        }//end if canceled status
        
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
    
    @IBAction func cancelOrder(_ sender: Any) {
        delegate.didPressDeleteOrderButton(sender: sender, request: selectedRequest!);
    }
}
