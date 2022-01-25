//
//  CompletingOrderTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 9/29/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
import CoreLocation


class CompletingOrderTableViewCell: UITableViewCell {

  
    @IBOutlet weak var statusView: UIView!
    var selectedRequest: Request?
    var delegate: OrderCellDelegate!
    var translatedTitles = [String: String]()
    
    @IBOutlet weak var attachedView: UIView!
    
    @IBOutlet weak var fileBtn: UIButton!
    
    @IBOutlet weak var fileBtn2: UIButton!
    
    @IBOutlet weak var fileBtn3: UIButton!
    
    
    @IBAction func openFiles(_ sender: UIButton) {
        
        var imageUrl = "";
        if(selectedRequest != nil && selectedRequest?.files != nil){
            
        if(sender.tag == 1){
            //file 1
            if(selectedRequest?.files[0] != nil){
                imageUrl = selectedRequest?.files[0].image ?? "";
            }
        }
        else  if(sender.tag == 2){
                   //file 2
            if(selectedRequest?.files[1] != nil){
               imageUrl = selectedRequest?.files[1].image ?? "";
            }
            
        }
        else  if(sender.tag == 3){
                   //file 3
            
            if(selectedRequest?.files[2] != nil){
                 imageUrl = selectedRequest?.files[2].image ?? "";
            }
        }
        }
        
        
        guard let url = URL(string: imageUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? "")
            else {
               
                return;
                
        }
        
        UIApplication.shared.open(url);
        
    }
    
    @IBOutlet weak var attachedFilesTitle: UILabel!{
       didSet { attachedFilesTitle.layer.cornerRadius =  7;
        attachedFilesTitle.layer.borderColor = Constants.BORDER_COLOR;
        attachedFilesTitle.layer.borderWidth = 1;
        }
    }
    
    @IBOutlet weak var showMapBtn: UIButton!
    
    @IBOutlet weak var servicePrice: UILabel!
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
    
    @IBOutlet weak var calender_icon: UIImageView!
      
      @IBOutlet weak var time_icon: UIImageView!
      
      @IBOutlet weak var map_icon: UIButton!
      
      @IBOutlet weak var orderNo_icon: UIImageView!
    
    @IBOutlet weak var descTitle: UILabel!

    @IBOutlet weak var serviceLabel: UILabel!
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
        
        
        var showMapbtnTitle = "Show On Map";
        var file1 = "File1";
        var file2 = "File2";
        var file3 = "File3";
        var attchedFileTxt = "Attached Files"

            if(Utils.getcurrentLanguage() == "ar"){
                showMapbtnTitle = "أظهر علي الخريطة";
                 file1 = "الملف١";
                 file2 = "الملف٢";
                 file3 = "الملف٣";
                attchedFileTxt =  " المرفقات ";
                   }
        
        attachedFilesTitle.text = attchedFileTxt;
        
            let attrs = [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13.0),
                NSAttributedStringKey.foregroundColor : Constants.MainColor ,
                NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]

            let attributedString = NSMutableAttributedString(string: "" )
              let showMapbuttonTitleStr = NSMutableAttributedString(string: showMapbtnTitle, attributes:attrs)
            attributedString.append(showMapbuttonTitleStr)
        
            showMapBtn.setAttributedTitle(attributedString, for: .normal);
        
         let File1attributedString = NSMutableAttributedString(string: "" )
        let File1buttonTitleStr = NSMutableAttributedString(string: file1, attributes:attrs)
        File1attributedString.append(File1buttonTitleStr);
            
        fileBtn.setAttributedTitle(File1attributedString, for: .normal);
        
        let File2attributedString = NSMutableAttributedString(string: "" )

        let File2buttonTitleStr = NSMutableAttributedString(string: file2, attributes:attrs)
              File2attributedString.append(File2buttonTitleStr);
                  
              fileBtn2.setAttributedTitle(File2attributedString, for: .normal);
        
        let File3attributedString = NSMutableAttributedString(string: "" )

        let File3buttonTitleStr = NSMutableAttributedString(string: file3, attributes:attrs)
              File3attributedString.append(File3buttonTitleStr);
                  
              fileBtn3.setAttributedTitle(File3attributedString, for: .normal);
        
        calender_icon.setMainColoredImage(name: "order_calender_icon");
                      
                    time_icon.setMainColoredImage(name: "order_time_icon");
                      
                    map_icon.setMainColoredButton(name: "order_loc_icon");
                      
                    orderNo_icon.setMainColoredImage(name: "order_orderno_icon");
        statusView.layer.cornerRadius = 25;
        statusView.layer.borderWidth = 2.0;
        self.statusView.layer.borderColor = Constants.BORDER_COLOR;
        //provider_info_label.layer.cornerRadius = 13;
       // provider_info_label.layer.borderWidth = 2.0;
        //self.provider_info_label.layer.borderColor = Constants.BORDER_COLOR;
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
        if(selectedRequest?.files != nil && selectedRequest?.files.count ?? 0 > 0){
            self.attachedView.isHidden = false;
            if(selectedRequest?.files.count == 1){
                self.fileBtn.isHidden = false;
                self.fileBtn2.isHidden = true;
                self.fileBtn3.isHidden = true;
                
                
            }else   if(selectedRequest?.files.count == 2){
                self.fileBtn.isHidden = false;
                self.fileBtn2.isHidden = false;
                self.fileBtn3.isHidden = true;
                
            }
            else  if(selectedRequest?.files.count == 3){
                self.fileBtn.isHidden = false;
                self.fileBtn2.isHidden = false;
                self.fileBtn3.isHidden = false;
                
            }
        }
        else{
            self.attachedView.isHidden = true;
            
        }
        status.text = translatedTitles["completed"];
        desc.text = request.desc
         if(request.lat !=  "" || request.lng != ""){
                latLong(lat: Double(request.lat) as! Double, long:  Double(request.lng)  as! Double);
                       address_label.text = self.address;
                }
                else{
                      address_label.text = request.address;
            
                }
        serviceTime.text = request.serviceTime;
        order_no_label.text = request.id;
        serviceDay.text = request.serviceDay
        //providerNameLabel.text = request.userName;
        if(request.price  != "0" && request.price  != "" ){
               if(Utils.getcurrentLanguage() == "ar"){
                   servicePrice.text = " تكلفة الخدمة: " + request.price;
                   
               }else{
                   servicePrice.text = "Service Price: " + request.price;
               }
               }else{
                   servicePrice.isHidden = true;
               }
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
