//
//  ProviderCell.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/14/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import SDWebImage
import CoreLocation
import MapKit


protocol ProviderCellDelegate: class {
    func didPressAcceptButton(sender: UIButton, provider: Provider);
    func  openMapForPlace(latitude: Double, longitude: Double);

}
class ProviderCell: UITableViewCell {
    var delegate: ProviderCellDelegate!
    var selectedProvider: Provider?

   
    @IBOutlet weak var price_per_day_lavel: UILabel!
    @IBOutlet weak var price_by_hour_label: UILabel!
    @IBOutlet weak var dailyPrice: UILabel!
    @IBOutlet weak var hourlyPrice: UILabel!
    @IBOutlet weak var rating: SwiftyStarRatingView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var providerImage: UIImageView!
    
    
    @IBOutlet weak var addressLabelTapped: UILabel!
    @IBOutlet weak var locButton: UIButton!
    @IBOutlet weak var experience_title_label: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var btnView: UIButton!
    
    @IBOutlet weak var nationalityLabel: UILabel!
    
    @IBOutlet weak var address_title_label: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnView.layer.cornerRadius = 12
        locButton.setMainColoredButton(name: "order_loc_icon");
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))

        addressLabelTapped.isUserInteractionEnabled = true;
        addressLabelTapped.addGestureRecognizer(tap)
    }

    @IBAction func OpenMap(_ sender: UIButton) {
        
//        coordinates(forAddress: address.text ?? "") {
//            (location) in
//            guard let location = location else {
//                // Handle error here.
//                return
//            }
//            self.delegate.openMapForPlace(latitude: location.latitude, longitude: location.longitude)
        //}
        print(self.selectedProvider);
        self.delegate.openMapForPlace(latitude:  self.selectedProvider?.lat ?? 0.0, longitude:  self.selectedProvider?.long ?? 0.0)
        
    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        print (address);
          let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
           
            completion(placemarks?.first?.location?.coordinate);
        }
        
    }
    

    @objc func tapFunction(sender:UITapGestureRecognizer) {
       print("tap working")
//    coordinates(forAddress: address.text ?? "") {
//        (location) in
//        guard let location = location else {
//            // Handle error here.
//            return
//        }
       
        //self.delegate.openMapForPlace(latitude: location.latitude, longitude: location.longitude)
           print(self.selectedProvider);
       self.delegate.openMapForPlace(latitude:  self.selectedProvider?.lat ?? 0.0, longitude:  self.selectedProvider?.long ?? 0.0)
    
   }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(provider: Provider) {
        let currentLanguage = Utils.getcurrentLanguage()
        nationalityLabel.text = provider.nationality;
        if currentLanguage == "en" {
            providerName.text = provider.name
        
        } else {
            providerName.text = provider.name
            btnView.setTitle("إختر الفني", for: UIControlState.normal)
            price_per_day_lavel.text = "سعر الخدمة باليوم:"
            price_by_hour_label .text = "سعر الخدمة بالساعة:"
            nationLabel.text = "الجنسية:";
            experience_title_label.text = "الخبرة:";
            address_title_label.text = "العنوان:";

        }
        self.selectedProvider = provider
        rating.value = CGFloat(provider.rating)
        dailyPrice.text = provider.dailyPrice + " " + NSLocalizedString("app.currency", comment: "")
        hourlyPrice.text = provider.hourlyPrice + " " + NSLocalizedString("app.currency", comment: "")
        experienceLabel.text = provider.experience;
        address.text = provider.address;
        providerImage.sd_setImage(with: URL(string: provider.imageUrl), placeholderImage: UIImage(named: "logo-r"))
    }
    
    @IBAction func accept(_ sender: UIButton) {
        print("accept delegate click")
        if (selectedProvider != nil) {
            delegate.didPressAcceptButton(sender: sender, provider: selectedProvider!)
        }
    }
    
   
}
